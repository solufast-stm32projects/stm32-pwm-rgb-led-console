#ifndef SYSTEM_HEALTH_H
#define SYSTEM_HEALTH_H

#include <stdint.h>
#include <stdbool.h>

// System health monitoring structure
typedef struct {
    uint32_t uptime_seconds;
    uint32_t free_heap_bytes;
    uint32_t min_free_heap_bytes;
    uint8_t cpu_usage_percent;
    uint32_t task_stack_high_water[5]; // For each task
    uint32_t led_renderer_calls;
    uint32_t fade_steps_taken;
    uint32_t mode_changes;
    uint32_t uart_commands_processed;
    uint32_t tof_readings;
    uint32_t auto_mode_cycles;
} system_health_t;

// Error handling
typedef enum {
    ERROR_NONE = 0,
    ERROR_MALLOC_FAILED,
    ERROR_STACK_OVERFLOW,
    ERROR_I2C_TIMEOUT,
    ERROR_TOF_SENSOR_FAIL,
    ERROR_PWM_INIT_FAIL,
    ERROR_UART_BUFFER_OVERFLOW,
    ERROR_INVALID_MODE,
    ERROR_INVALID_PARAMETER
} system_error_t;

// Performance metrics
typedef struct {
    uint32_t led_renderer_avg_time_us;
    uint32_t tof_sensor_avg_time_us;
    uint32_t uart_processing_avg_time_us;
    uint32_t auto_mode_avg_time_us;
    uint32_t total_cycles;
    uint32_t max_loop_time_us;
    uint32_t min_loop_time_us;
} performance_metrics_t;

// Public API
void system_health_init(void);
void system_health_update(void);
void system_health_print_report(void);
system_health_t* system_health_get_data(void);

// Error handling
void system_error_handler(system_error_t error, const char* file, int line);
void system_error_reset_recovery(void);
system_error_t system_error_get_last(void);
const char* system_error_get_string(system_error_t error);

// Performance monitoring
void performance_metrics_init(void);
void performance_metrics_update(void);
void performance_metrics_print_report(void);
performance_metrics_t* performance_metrics_get_data(void);

// Task monitoring helpers
void task_monitor_begin(const char* task_name);
void task_monitor_end(const char* task_name);

// Macro for easy error handling
#define SYSTEM_ERROR_CHECK(condition, error_code) \
    do { \
        if (!(condition)) { \
            system_error_handler(error_code, __FILE__, __LINE__); \
        } \
    } while(0)

#endif // SYSTEM_HEALTH_H
