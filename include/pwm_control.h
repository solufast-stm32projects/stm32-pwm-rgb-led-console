#ifndef PWM_CONTROL_H
#define PWM_CONTROL_H

#include <stdint.h>

void pwm_init(void);
void pwm_set_red(uint8_t val);
void pwm_set_green(uint8_t val);
void pwm_set_blue(uint8_t val);

#endif
