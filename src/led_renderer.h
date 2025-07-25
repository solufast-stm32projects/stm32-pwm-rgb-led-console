#ifndef LED_RENDERER_H
#define LED_RENDERER_H
#include <stdint.h>
#include <stdbool.h>

typedef enum {
    LED_MODE_MANUAL = 0,
    LED_MODE_AUTO = 1,
    LED_MODE_TOF = 2,
    LED_MODE_HYBRID = 3
} led_render_mode_t;

void led_renderer_init(void);
void led_renderer_set_mode(led_render_mode_t mode);
void led_renderer_update_color(uint8_t r, uint8_t g, uint8_t b);
void led_renderer_task(void);
void led_renderer_force_output(void);

// Fade control APIs
void led_renderer_set_fade_enabled(bool enable);
bool led_renderer_get_fade_enabled(void);
void led_renderer_set_fade_speed(uint32_t ms);
uint32_t led_renderer_get_fade_speed(void);

#endif // LED_RENDERER_H
