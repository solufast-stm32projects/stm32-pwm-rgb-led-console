#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include "tof_control.h"
#include "main.h"
#include "pwm_control.h"
#include <stdio.h>
#include <string.h>
#include "FreeRTOS.h"
#include "task.h"
#include "stm32u5xx_hal.h"
#include "vl53l5cx_api.h" // For VL53L5CX_Configuration, VL53L5CX_ResultsData, etc.
#include "auto_mode.h"
#include "led_renderer.h"

// --- Constants for VL53L5CX ---
#define TOF_I2C_ADDR         0x29          // 7-bit I2C address
#define TOF_TASK_DELAY_MS    50            // Sensor polling interval
#define MAX_VALID_DISTANCE   8190          // VL53L5CX returns 8190+ when invalid

// --- Distance → Brightness Mapping Parameters ---
#define MIN_DIST_MM          100           // Closer than this = max brightness
#define MAX_DIST_MM          600           // Farther than this = off
#define DIST_FILTER_ALPHA    0.35f         // EWMA filter smoothing: higher = faster

#define RISE_ALPHA 0.7f    // Fast rise
#define FALL_ALPHA 0.2f    // Slower fall

// --- Internal State ---
static bool tof_enabled = false;
static bool tof_init_ok = false;
static uint16_t last_distance = 0;
static float filtered_distance = 0.0f;
static uint8_t current_brightness = 255;

// --- Sensor Handle ---
static VL53L5CX_Configuration tof_dev;
extern I2C_HandleTypeDef hi2c2;

// --- Pre-RTOS Busy Wait (used during init) ---
static void busy_wait_ms(uint32_t ms) {
    volatile uint32_t count = ms * 8000; // ~8k cycles/ms @160MHz
    while (count--) __NOP();
}

// --- Gamma-corrected brightness mapping ---
// Why gamma? Human vision perceives brightness non-linearly.
// This makes brightness *appear* smoother to our eyes.
static uint8_t map_distance_to_brightness(uint16_t distance) {
    if (distance <= MIN_DIST_MM) return 255; // Closest = full brightness
    if (distance >= MAX_DIST_MM) return 0;   // Far away = off

    float normalized = (float)(MAX_DIST_MM - distance) / (MAX_DIST_MM - MIN_DIST_MM); // [0..1]
    float gamma = 2.2f;  // Standard perceptual gamma curve
    float corrected = powf(normalized, gamma);  // Apply curve
    return (uint8_t)(corrected * 255.0f);
}

// --- Get Center Zone Index ---
// The VL53L5CX reports a grid of zones (usually 8×8 = 64 zones).
// We choose the zone closest to center for simplicity.
static uint8_t get_center_zone(uint8_t resolution) {
    if (resolution == 64) return 27; // Zone (3,3) in 8x8 grid
    if (resolution == 16) return 5;  // Zone (1,1) in 4x4 grid
    return 0;                        // Fallback
}

// --- Public API ---
bool tof_control_init(void) {
    memset(&tof_dev, 0, sizeof(tof_dev));
    tof_dev.platform.address = TOF_I2C_ADDR;

    printf("[ToF] Booting VL53L5CX...\r\n");
    busy_wait_ms(500); // Allow sensor time to power up

    // Check if sensor is alive
    uint8_t is_alive = 0;
    if (vl53l5cx_is_alive(&tof_dev, &is_alive) != 0 || !is_alive) {
        printf("[ToF] Sensor not detected!\r\n");
        tof_init_ok = false;
        return false;
    }

    // Initialize the sensor
    printf("[ToF] Sensor detected, initializing...\r\n");
    if (vl53l5cx_init(&tof_dev) != 0) {
        printf("[ToF] Init failed\r\n");
        tof_init_ok = false;
        return false;
    }

    // Set ranging frequency to 2Hz (you can increase for faster updates)
    vl53l5cx_set_ranging_frequency_hz(&tof_dev, 20);

    // Set to continuous mode
    vl53l5cx_set_ranging_mode(&tof_dev, VL53L5CX_RANGING_MODE_CONTINUOUS);

    // Start ranging
    if (vl53l5cx_start_ranging(&tof_dev) != 0) {
        printf("[ToF] Start ranging failed\r\n");
        tof_init_ok = false;
        return false;
    }

    printf("[ToF] VL53L5CX ready.\r\n");
    tof_init_ok = true;
    return true;
}

void tof_control_enable(bool enable) {
    tof_enabled = enable;
    if (enable) {
        led_renderer_set_mode(LED_MODE_TOF);
    } else {
        led_renderer_set_mode(LED_MODE_MANUAL); // or LED_MODE_AUTO if auto_mode_get_enabled()
    }
}

bool tof_control_is_enabled(void) {
    return tof_enabled;
}

uint16_t tof_control_get_distance(void) {
    return last_distance;
}

void tof_control_set_brightness(uint8_t val) {
    current_brightness = val;
}

uint8_t tof_control_get_brightness(void) {
    return current_brightness;
}


// --- Main FreeRTOS Task ---
static VL53L5CX_ResultsData results;
void tof_control_task(void *argument) {
    uint8_t is_ready = 0;
    uint8_t resolution = 0;
    uint16_t last_printed = 0;
    (void)argument;

    if (!tof_init_ok) {
        printf("[ToF] Task aborted: sensor not initialized.\r\n");
        vTaskDelete(NULL);
    }

    for (;;) {
        if (tof_enabled) {
            // Check if new data is ready
            if (vl53l5cx_check_data_ready(&tof_dev, &is_ready) == 0 && is_ready) {
                // Get resolution (e.g., 64 for 8x8)
                if (vl53l5cx_get_resolution(&tof_dev, &resolution) != 0) continue;

                // Read latest ranging data
                if (vl53l5cx_get_ranging_data(&tof_dev, &results) == 0) {
                    // Extract center zone distance
                    uint8_t zone = get_center_zone(resolution);
                    uint16_t dist_mm = results.distance_mm[zone * VL53L5CX_NB_TARGET_PER_ZONE];

                    // Adjust alpha depending on movement direction
                    float alpha = (dist_mm < filtered_distance) ? RISE_ALPHA : FALL_ALPHA;

                    // Check validity (VL53L5CX returns 8190+ if no valid measurement)
                    if (dist_mm > 0 && dist_mm < MAX_VALID_DISTANCE) {
                        // Apply exponential smoothing filter
                        if (filtered_distance == 0.0f) {
                            filtered_distance = dist_mm; // Initialize filter
                        } else {
                            //filtered_distance = DIST_FILTER_ALPHA * dist_mm + (1.0f - DIST_FILTER_ALPHA) * filtered_distance;
                            filtered_distance = alpha * dist_mm + (1.0f - alpha) * filtered_distance;
                        }

                        last_distance = (uint16_t)filtered_distance;
                        uint8_t brightness = map_distance_to_brightness(last_distance);
                        tof_control_set_brightness(brightness);  // Store for renderer to use


                        // Optional: Only print if distance changes notably
                        if (abs((int)last_distance - (int)last_printed) > 40) {
                            printf("[ToF] Distance: %4d mm → Brightness: %3d\r\n", last_distance, brightness);
                            last_printed = last_distance;
                        }
                    } else {
                        // No valid target: turn off LEDs
                        tof_control_set_brightness(0);

                    }
                }
            }
        } else {
            // Sensor is disabled: turn off LEDs
            tof_control_set_brightness(0);
        }

        // Wait a bit before checking again
        vTaskDelay(pdMS_TO_TICKS(TOF_TASK_DELAY_MS));
    }
}
