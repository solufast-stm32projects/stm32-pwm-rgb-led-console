#ifndef AUTO_MODE_H
#define AUTO_MODE_H

#include <stdint.h>
#include <stdbool.h>

// Auto mode types
typedef enum {
    AUTO_MODE_CYCLIC = 0,
    AUTO_MODE_RANDOM = 1
} auto_mode_type_t;

// Pattern types
typedef enum {
    PATTERN_OFF = 0,
    PATTERN_RAINBOW,
    PATTERN_FIRE,
    PATTERN_POLICE,
    PATTERN_PARTY
} auto_pattern_t;

// Auto mode settings
typedef struct {
    bool enabled;
    auto_mode_type_t mode;
    uint32_t interval_ms; // For cyclic mode
    bool fade_enabled;
    uint32_t fade_speed_ms; // ms per fade step
    auto_pattern_t pattern;
    uint8_t brightness; // 0-255
    uint8_t last_r, last_g, last_b;
} auto_mode_settings_t;

// API
void auto_mode_init(void);
void auto_mode_set_enabled(bool enable);
bool auto_mode_get_enabled(void);
void auto_mode_set_mode(auto_mode_type_t mode);
auto_mode_type_t auto_mode_get_mode(void);
void auto_mode_set_interval(uint32_t ms);
uint32_t auto_mode_get_interval(void);
void auto_mode_process(void);
void auto_mode_set_fade_enabled(bool enable);
bool auto_mode_get_fade_enabled(void);
void auto_mode_set_fade_speed(uint32_t ms);
uint32_t auto_mode_get_fade_speed(void);
void auto_mode_set_pattern(auto_pattern_t pattern);
auto_pattern_t auto_mode_get_pattern(void);
void auto_mode_set_brightness(uint8_t val);
uint8_t auto_mode_get_brightness(void);

#endif // AUTO_MODE_H 