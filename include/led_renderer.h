#ifndef LED_RENDERER_H
#define LED_RENDERER_H

#include <stdint.h>

typedef enum {
    LED_MODE_TOF,        // Brightness from ToF, color fixed or manual
    LED_MODE_AUTO,       // Full control from auto_mode
    LED_MODE_HYBRID      // Color from auto_mode, brightness from ToF
} led_render_mode_t;

void led_renderer_init(void);
void led_renderer_set_mode(led_render_mode_t mode);
void led_renderer_update_color(uint8_t r, uint8_t g, uint8_t b);  // Feed desired RGB
void led_renderer_task(void); // Call periodically (e.g., from a FreeRTOS task)
void led_renderer_force_output(void);  // For instant update if fade is disabled

#endif
