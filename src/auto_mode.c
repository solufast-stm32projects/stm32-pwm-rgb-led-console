#include <stdint.h>
#include <stdbool.h>
#include "auto_mode.h"
#include "pwm_control.h"
#include <stdlib.h>
#include <time.h>
#include "stm32u5xx_hal.h"
#include <stdio.h>
#include <string.h>

// Internal state
static auto_mode_settings_t auto_mode_settings = {
    .enabled = false,
    .mode = AUTO_MODE_CYCLIC,
    .interval_ms = 500,
    .fade_enabled = false,
    .fade_speed_ms = 20,
    .pattern = PATTERN_OFF,
    .brightness = 255, // Default brightness
    .last_r = 255,
    .last_g = 0,
    .last_b = 0
};

// Color state for cyclic mode
static uint8_t r = 255, g = 0, b = 0;
static uint8_t phase = 0;
static uint32_t last_tick = 0;
static uint8_t cur_r = 255, cur_g = 0, cur_b = 0;
static uint8_t tgt_r = 255, tgt_g = 0, tgt_b = 0;

// Helper: get current tick (ms)
static uint32_t get_tick(void) {
    // Use FreeRTOS tick count
    extern uint32_t xTaskGetTickCount(void);
    return xTaskGetTickCount();
}

static void set_target_color(uint8_t rr, uint8_t gg, uint8_t bb);

void auto_mode_init(void) {
    auto_mode_settings.enabled = false;
    auto_mode_settings.mode = AUTO_MODE_CYCLIC;
    auto_mode_settings.interval_ms = 500;
    auto_mode_settings.fade_enabled = false;
    auto_mode_settings.fade_speed_ms = 20;
    r = 255; g = 0; b = 0; phase = 0; last_tick = 0;
    cur_r = tgt_r = 255; cur_g = tgt_g = 0; cur_b = tgt_b = 0;
    srand((unsigned int)get_tick());
}

void auto_mode_set_enabled(bool enable) {
    auto_mode_settings.enabled = enable;
}

bool auto_mode_get_enabled(void) {
    return auto_mode_settings.enabled;
}

void auto_mode_set_mode(auto_mode_type_t mode) {
    auto_mode_settings.mode = mode;
}

auto_mode_type_t auto_mode_get_mode(void) {
    return auto_mode_settings.mode;
}

void auto_mode_set_interval(uint32_t ms) {
    auto_mode_settings.interval_ms = ms;
}

uint32_t auto_mode_get_interval(void) {
    return auto_mode_settings.interval_ms;
}

void auto_mode_set_fade_enabled(bool enable) {
    auto_mode_settings.fade_enabled = enable;
}
bool auto_mode_get_fade_enabled(void) {
    return auto_mode_settings.fade_enabled;
}
void auto_mode_set_fade_speed(uint32_t ms) {
    auto_mode_settings.fade_speed_ms = ms;
}
uint32_t auto_mode_get_fade_speed(void) {
    return auto_mode_settings.fade_speed_ms;
}

void auto_mode_set_pattern(auto_pattern_t pattern) {
    auto_mode_settings.pattern = pattern;
}
auto_pattern_t auto_mode_get_pattern(void) {
    return auto_mode_settings.pattern;
}

void auto_mode_set_brightness(uint8_t val) {
    auto_mode_settings.brightness = val;
}
uint8_t auto_mode_get_brightness(void) {
    return auto_mode_settings.brightness;
}
// --- Brightness scaling helper ---
static uint8_t scale_brightness(uint8_t val) {
    return (uint16_t)val * auto_mode_settings.brightness / 255;
}
// --- Override PWM set functions to apply brightness ---
static void pwm_set_scaled(uint8_t r, uint8_t g, uint8_t b) {
    pwm_set_red(scale_brightness(r));
    pwm_set_green(scale_brightness(g));
    pwm_set_blue(scale_brightness(b));
}

// Helper: next color in cyclic mode (simple RGB wheel)
static void next_cyclic_color(void) {
    switch (phase) {
        case 0: if (g < 255) g++; else phase = 1; break;
        case 1: if (r > 0) r--; else phase = 2; break;
        case 2: if (b < 255) b++; else phase = 3; break;
        case 3: if (g > 0) g--; else phase = 4; break;
        case 4: if (r < 255) r++; else phase = 5; break;
        case 5: if (b > 0) b--; else phase = 0; break;
    }
    set_target_color(r, g, b);
}

// Helper: set random color
static void set_random_color(void) {
    uint8_t rr = rand() % 256;
    uint8_t gg = rand() % 256;
    uint8_t bb = rand() % 256;
    set_target_color(rr, gg, bb);
}

// Helper: set target color (for fade)
static void set_target_color(uint8_t rr, uint8_t gg, uint8_t bb) {
    tgt_r = rr; tgt_g = gg; tgt_b = bb;
    auto_mode_settings.last_r = rr;
    auto_mode_settings.last_g = gg;
    auto_mode_settings.last_b = bb;
}
// Helper: update current color toward target (one step)
static int fade_step(void) {
    int changed = 0;
    if (cur_r < tgt_r) { cur_r++; changed = 1; }
    else if (cur_r > tgt_r) { cur_r--; changed = 1; }
    if (cur_g < tgt_g) { cur_g++; changed = 1; }
    else if (cur_g > tgt_g) { cur_g--; changed = 1; }
    if (cur_b < tgt_b) { cur_b++; changed = 1; }
    else if (cur_b > tgt_b) { cur_b--; changed = 1; }
    pwm_set_scaled(cur_r, cur_g, cur_b);
    return changed;
}

typedef struct {
    uint32_t last_tick;
    int rainbow_hue;
    int police_state;
    // Add more as needed
    uint32_t next_interval;
    uint32_t last_fade;
} auto_pattern_state_t;

static auto_pattern_state_t pattern_state = {0};

static void handle_rainbow_pattern(uint32_t now) {
    if (now - pattern_state.last_tick >= auto_mode_settings.interval_ms) {
        pattern_state.rainbow_hue = (pattern_state.rainbow_hue + 2) % 360;
        float h = pattern_state.rainbow_hue / 60.0f;
        int i = (int)h;
        float f = h - i;
        int v = 255, s = 255;
        int p = (int)(v * (1 - s / 255.0f));
        int q = (int)(v * (1 - f * s / 255.0f));
        int t = (int)(v * (1 - (1 - f) * s / 255.0f));
        uint8_t rr, gg, bb;
        switch (i) {
            case 0: rr = v; gg = t; bb = p; break;
            case 1: rr = q; gg = v; bb = p; break;
            case 2: rr = p; gg = v; bb = t; break;
            case 3: rr = p; gg = q; bb = v; break;
            case 4: rr = t; gg = p; bb = v; break;
            default: rr = v; gg = p; bb = q; break;
        }
        set_target_color(rr, gg, bb);
        pattern_state.last_tick = now;
    }
}

static void handle_fire_pattern(uint32_t now) {
    if (now - pattern_state.last_tick >= auto_mode_settings.interval_ms) {
        int base = 180 + rand() % 75; // base red
        int flicker = rand() % 80;
        uint8_t rr = base;
        uint8_t gg = flicker;
        uint8_t bb = 0;
        set_target_color(rr, gg, bb);
        pattern_state.last_tick = now;
    }
}

static void handle_police_pattern(uint32_t now) {
    if (now - pattern_state.last_tick >= auto_mode_settings.interval_ms) {
        if (pattern_state.police_state == 0) {
            set_target_color(255, 0, 0); // Red
            pattern_state.police_state = 1;
        } else {
            set_target_color(0, 0, 255); // Blue
            pattern_state.police_state = 0;
        }
        pattern_state.last_tick = now;
    }
}

static void handle_party_pattern(uint32_t now) {
    if (now - pattern_state.last_tick >= auto_mode_settings.interval_ms) {
        set_target_color(rand() % 256, rand() % 256, rand() % 256);
        pattern_state.last_tick = now;
    }
}

static void handle_auto_mode(uint32_t now) {
    static int hue = 0;
    const int hue_step = 8; // Larger step for more visible color change
    if (auto_mode_settings.mode == AUTO_MODE_CYCLIC) {
        if (now - pattern_state.last_tick >= auto_mode_settings.interval_ms) {
            hue = (hue + hue_step) % 360;
            float h = hue / 60.0f;
            int i = (int)h;
            float f = h - i;
            int v = 255, s = 255;
            int p = (int)(v * (1 - s / 255.0f));
            int q = (int)(v * (1 - f * s / 255.0f));
            int t = (int)(v * (1 - (1 - f) * s / 255.0f));
            uint8_t rr, gg, bb;
            switch (i) {
                case 0: rr = v; gg = t; bb = p; break;
                case 1: rr = q; gg = v; bb = p; break;
                case 2: rr = p; gg = v; bb = t; break;
                case 3: rr = p; gg = q; bb = v; break;
                case 4: rr = t; gg = p; bb = v; break;
                default: rr = v; gg = p; bb = q; break;
            }
            set_target_color(rr, gg, bb);
            pattern_state.last_tick = now;
        }
    } else if (auto_mode_settings.mode == AUTO_MODE_RANDOM) {
        if (now - pattern_state.last_tick >= pattern_state.next_interval) {
            set_target_color(rand() % 256, rand() % 256, rand() % 256);
            pattern_state.next_interval = 50 + (rand() % (500 - 50 + 1));
            pattern_state.last_tick = now;
        }
    }
}

static void handle_fade(uint32_t now) {
    static uint32_t last_fade = 0;
    if (auto_mode_settings.fade_enabled) {
        if (now - last_fade >= auto_mode_settings.fade_speed_ms) {
            fade_step();
            last_fade = now;
        }
    } else {
        if (cur_r != tgt_r || cur_g != tgt_g || cur_b != tgt_b) {
            cur_r = tgt_r; cur_g = tgt_g; cur_b = tgt_b;
            pwm_set_scaled(cur_r, cur_g, cur_b);
        }
    }
}

void auto_mode_process(void) {
    if (!auto_mode_settings.enabled) return;
    uint32_t now = get_tick();
    switch (auto_mode_settings.pattern) {
        case PATTERN_RAINBOW: handle_rainbow_pattern(now); break;
        case PATTERN_FIRE:    handle_fire_pattern(now);    break;
        case PATTERN_POLICE:  handle_police_pattern(now);  break;
        case PATTERN_PARTY:   handle_party_pattern(now);   break;
        case PATTERN_OFF:
        default:
            handle_auto_mode(now);
            break;
    }
    handle_fade(now);
}

// --- Status print ---
void auto_mode_print_status(void) {
    printf("Status:\r\n");
    printf("  Auto: %d\r\n", auto_mode_settings.enabled);
    printf("  Mode: %s\r\n", auto_mode_settings.mode == AUTO_MODE_CYCLIC ? "cyclic" : "random");
    printf("  Pattern: %d\r\n", auto_mode_settings.pattern);
    printf("  Interval: %lu ms\r\n", auto_mode_settings.interval_ms);
    printf("  Fade: %d\r\n", auto_mode_settings.fade_enabled);
    printf("  Fade speed: %lu ms\r\n", auto_mode_settings.fade_speed_ms);
    printf("  Brightness: %u\r\n", auto_mode_settings.brightness);
    printf("  Last color: R=%u G=%u B=%u\r\n", auto_mode_settings.last_r, auto_mode_settings.last_g, auto_mode_settings.last_b);
}
// --- Surprise me ---
void auto_mode_surprise(void) {
    auto_mode_set_enabled(1);
    auto_mode_set_mode(rand() % 2);
    auto_mode_set_pattern(rand() % 5);
    auto_mode_set_fade_enabled(rand() % 2);
    auto_mode_set_fade_speed(5 + rand() % 50);
    auto_mode_set_brightness(64 + rand() % 192);
    set_target_color(rand() % 256, rand() % 256, rand() % 256);
} 