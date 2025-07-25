#include "system_health.h"
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"
#include <stdio.h>
#include <string.h>

// Internal state
static system_health_t health_data = {0};
static performance_metrics_t perf_data = {0};
static system_error_t last_error = ERROR_NONE;
static uint32_t error_count = 0;
static uint32_t last_uptime_update = 0;

// Task monitoring
static uint32_t task_start_times[5] = {0};
static uint32_t task_execution_times[5] = {0};
static const char* task_names[5] = {"Heartbeat", "UartConsole", "LedPwm", "LEDControl", "ToF"};

// Performance tracking
static uint32_t loop_start_time = 0;
static uint32_t total_loop_time = 0;
static uint32_t loop_count = 0;

// Error strings
static const char* error_strings[] = {
    "None",
    "Malloc Failed",
    "Stack Overflow",
    "I2C Timeout",
    "ToF Sensor Fail",
    "PWM Init Fail",
    "UART Buffer Overflow",
    "Invalid Mode",
    "Invalid Parameter"
};

void system_health_init(void) {
    memset(&health_data, 0, sizeof(health_data));
    memset(&perf_data, 0, sizeof(perf_data));
    last_error = ERROR_NONE;
    error_count = 0;
    last_uptime_update = xTaskGetTickCount();

    // Initialize performance tracking
    perf_data.min_loop_time_us = 0xFFFFFFFF;

    printf("[System] Health monitoring initialized\r\n");
}

void system_health_update(void) {
    uint32_t now = xTaskGetTickCount();

    // Update uptime (every second)
    if (now - last_uptime_update >= pdMS_TO_TICKS(1000)) {
        health_data.uptime_seconds++;
        last_uptime_update = now;
    }

    // Update heap info
    health_data.free_heap_bytes = xPortGetFreeHeapSize();
    if (health_data.free_heap_bytes < health_data.min_free_heap_bytes ||
        health_data.min_free_heap_bytes == 0) {
        health_data.min_free_heap_bytes = health_data.free_heap_bytes;
    }

    // Update task stack high water marks (simplified - in real system you'd track each task)
    // This is a simplified version - you'd typically get this from each task
    for (int i = 0; i < 5; i++) {
        // In a real implementation, you'd call uxTaskGetStackHighWaterMark() for each task
        health_data.task_stack_high_water[i] = 128; // Placeholder
    }
}

void system_health_print_report(void) {
    printf("\r\n=== SYSTEM HEALTH REPORT ===\r\n");
    printf("Uptime: %lu seconds (%lu:%02lu:%02lu)\r\n",
           health_data.uptime_seconds,
           health_data.uptime_seconds / 3600,
           (health_data.uptime_seconds % 3600) / 60,
           health_data.uptime_seconds % 60);

    printf("Memory: %lu bytes free (min: %lu)\r\n",
           health_data.free_heap_bytes, health_data.min_free_heap_bytes);

    printf("Activity Counters:\r\n");
    printf("  LED Renderer calls: %lu\r\n", health_data.led_renderer_calls);
    printf("  Fade steps taken: %lu\r\n", health_data.fade_steps_taken);
    printf("  Mode changes: %lu\r\n", health_data.mode_changes);
    printf("  UART commands: %lu\r\n", health_data.uart_commands_processed);
    printf("  ToF readings: %lu\r\n", health_data.tof_readings);
    printf("  Auto mode cycles: %lu\r\n", health_data.auto_mode_cycles);

    if (last_error != ERROR_NONE) {
        printf("Last Error: %s (count: %lu)\r\n",
               system_error_get_string(last_error), error_count);
    }

    printf("============================\r\n");
}

system_health_t* system_health_get_data(void) {
    return &health_data;
}

void system_error_handler(system_error_t error, const char* file, int line) {
    last_error = error;
    error_count++;

    printf("[ERROR] %s at %s:%d\r\n", system_error_get_string(error), file, line);

    // For critical errors, we might want to reset or enter safe mode
    if (error == ERROR_MALLOC_FAILED || error == ERROR_STACK_OVERFLOW) {
        printf("[CRITICAL] System may be unstable, consider reset\r\n");
        // In production, you might trigger a watchdog reset here
    }
}

void system_error_reset_recovery(void) {
    last_error = ERROR_NONE;
    error_count = 0;
    printf("[System] Error state cleared\r\n");
}

system_error_t system_error_get_last(void) {
    return last_error;
}

const char* system_error_get_string(system_error_t error) {
    if (error < sizeof(error_strings) / sizeof(error_strings[0])) {
        return error_strings[error];
    }
    return "Unknown Error";
}

void performance_metrics_init(void) {
    memset(&perf_data, 0, sizeof(perf_data));
    perf_data.min_loop_time_us = 0xFFFFFFFF;
    printf("[System] Performance monitoring initialized\r\n");
}

void performance_metrics_update(void) {
    // This would be called at the end of each main loop iteration
    uint32_t loop_time = xTaskGetTickCount() - loop_start_time;
    total_loop_time += loop_time;
    loop_count++;

    if (loop_time > perf_data.max_loop_time_us) {
        perf_data.max_loop_time_us = loop_time;
    }
    if (loop_time < perf_data.min_loop_time_us) {
        perf_data.min_loop_time_us = loop_time;
    }

    // Update averages every 100 cycles
    if (loop_count % 100 == 0) {
        perf_data.led_renderer_avg_time_us = total_loop_time / loop_count;
        total_loop_time = 0;
        loop_count = 0;
    }
}

void performance_metrics_print_report(void) {
    printf("\r\n=== PERFORMANCE METRICS ===\r\n");
    printf("Loop timing (ms): avg=%lu, min=%lu, max=%lu\r\n",
           perf_data.led_renderer_avg_time_us,
           perf_data.min_loop_time_us,
           perf_data.max_loop_time_us);
    printf("Total cycles: %lu\r\n", perf_data.total_cycles);
    printf("===========================\r\n");
}

performance_metrics_t* performance_metrics_get_data(void) {
    return &perf_data;
}

void task_monitor_begin(const char* task_name) {
    // In a real implementation, you'd track individual task execution times
    // This is a simplified version
    loop_start_time = xTaskGetTickCount();
}

void task_monitor_end(const char* task_name) {
    // Track task execution time
    uint32_t exec_time = xTaskGetTickCount() - loop_start_time;

    // Find task index and update
    for (int i = 0; i < 5; i++) {
        if (strcmp(task_name, task_names[i]) == 0) {
            task_execution_times[i] = exec_time;
            break;
        }
    }
}

// Helper functions for other modules to call
void system_health_increment_led_calls(void) {
    health_data.led_renderer_calls++;
}

void system_health_increment_fade_steps(void) {
    health_data.fade_steps_taken++;
}

void system_health_increment_mode_changes(void) {
    health_data.mode_changes++;
}

void system_health_increment_uart_commands(void) {
    health_data.uart_commands_processed++;
}

void system_health_increment_tof_readings(void) {
    health_data.tof_readings++;
}

void system_health_increment_auto_cycles(void) {
    health_data.auto_mode_cycles++;
}
