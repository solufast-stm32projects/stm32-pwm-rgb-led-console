#include "led_renderer.h"
#include "pwm_control.h"
#include "auto_mode.h"
#include "tof_control.h"
#include "system_health.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

// --- Internal State ---
static uint8_t cur_r = 0, cur_g = 0, cur_b = 0;
static uint8_t tgt_r = 0, tgt_g = 0, tgt_b = 0;
static led_render_mode_t current_mode = LED_MODE_AUTO;
static bool fade_enabled = true;
static uint32_t fade_speed_ms = 20;

// Optional tick if needed
extern uint32_t xTaskGetTickCount(void);
static uint32_t last_fade_tick = 0;

// --- Init ---
void led_renderer_init(void) {
    cur_r = tgt_r = 0;
    cur_g = tgt_g = 0;
    cur_b = tgt_b = 0;
    current_mode = LED_MODE_AUTO;
    fade_enabled = true;
    fade_speed_ms = 20;
}

// --- Mode Set/Get ---
void led_renderer_set_mode(led_render_mode_t mode) {
    if (mode != current_mode) {
        current_mode = mode;
        system_health_increment_mode_changes();
    }
}

// --- External modules send desired color here ---
void led_renderer_update_color(uint8_t r, uint8_t g, uint8_t b) {
    tgt_r = r;
    tgt_g = g;
    tgt_b = b;
}

// --- Fade Control APIs ---
void led_renderer_set_fade_enabled(bool enable) {
    fade_enabled = enable;
}

bool led_renderer_get_fade_enabled(void) {
    return fade_enabled;
}

void led_renderer_set_fade_speed(uint32_t ms) {
    fade_speed_ms = ms;
}

uint32_t led_renderer_get_fade_speed(void) {
    return fade_speed_ms;
}

// --- Fade Step ---
static bool fade_step(void) {
    bool changed = false;

    // Calculate step size based on distance to target
    // Larger distance = larger step for more perceptible fade
    int step_r = (tgt_r > cur_r) ? 1 : (tgt_r < cur_r) ? -1 : 0;
    int step_g = (tgt_g > cur_g) ? 1 : (tgt_g < cur_g) ? -1 : 0;
    int step_b = (tgt_b > cur_b) ? 1 : (tgt_b < cur_b) ? -1 : 0;

    // Apply larger steps for bigger differences
    int diff_r = abs((int)tgt_r - (int)cur_r);
    int diff_g = abs((int)tgt_g - (int)cur_g);
    int diff_b = abs((int)tgt_b - (int)cur_b);

    if (diff_r > 50) step_r *= 2;  // Fast fade for big differences
    if (diff_g > 50) step_g *= 2;
    if (diff_b > 50) step_b *= 2;

    if (diff_r > 100) step_r *= 2; // Even faster for very big differences
    if (diff_g > 100) step_g *= 2;
    if (diff_b > 100) step_b *= 2;

    // Apply steps
    if (step_r != 0) {
        cur_r = (step_r > 0) ?
            ((cur_r + step_r) > tgt_r ? tgt_r : cur_r + step_r) :
            ((cur_r + step_r) < tgt_r ? tgt_r : cur_r + step_r);
        changed = true;
    }

    if (step_g != 0) {
        cur_g = (step_g > 0) ?
            ((cur_g + step_g) > tgt_g ? tgt_g : cur_g + step_g) :
            ((cur_g + step_g) < tgt_g ? tgt_g : cur_g + step_g);
        changed = true;
    }

    if (step_b != 0) {
        cur_b = (step_b > 0) ?
            ((cur_b + step_b) > tgt_b ? tgt_b : cur_b + step_b) :
            ((cur_b + step_b) < tgt_b ? tgt_b : cur_b + step_b);
        changed = true;
    }

    if (changed) {
        system_health_increment_fade_steps();
    }

    return changed;
}

// --- Brightness Application ---
static uint8_t apply_brightness(uint8_t val, uint8_t brightness) {
    return (uint16_t)val * brightness / 255;
}

// --- Main task (call periodically) ---
void led_renderer_task(void) {
    task_monitor_begin("LEDControl");

    uint32_t now = xTaskGetTickCount();

    // Handle fade logic
    if (fade_enabled) {
        if (now - last_fade_tick >= fade_speed_ms) {
            fade_step();
            last_fade_tick = now;
        }
    } else {
        // No fade: immediately set to target
        if (cur_r != tgt_r || cur_g != tgt_g || cur_b != tgt_b) {
            cur_r = tgt_r;
            cur_g = tgt_g;
            cur_b = tgt_b;
        }
    }

    // Select brightness based on mode
    uint8_t brightness = 255;
    if (current_mode == LED_MODE_TOF || current_mode == LED_MODE_HYBRID) {
        brightness = tof_control_get_brightness();
    } else if (current_mode == LED_MODE_AUTO || current_mode == LED_MODE_MANUAL) {
        brightness = auto_mode_get_brightness();
    }

    // Apply final PWM
    pwm_set_red(apply_brightness(cur_r, brightness));
    pwm_set_green(apply_brightness(cur_g, brightness));
    pwm_set_blue(apply_brightness(cur_b, brightness));

    system_health_increment_led_calls();
    task_monitor_end("LEDControl");
}

// --- Force immediate update (no fade) ---
void led_renderer_force_output(void) {
    cur_r = tgt_r;
    cur_g = tgt_g;
    cur_b = tgt_b;

    uint8_t brightness = 255;
    if (current_mode == LED_MODE_TOF || current_mode == LED_MODE_HYBRID) {
        brightness = tof_control_get_brightness();
    } else if (current_mode == LED_MODE_AUTO || current_mode == LED_MODE_MANUAL) {
        brightness = auto_mode_get_brightness();
    }

    pwm_set_red(apply_brightness(cur_r, brightness));
    pwm_set_green(apply_brightness(cur_g, brightness));
    pwm_set_blue(apply_brightness(cur_b, brightness));
}
