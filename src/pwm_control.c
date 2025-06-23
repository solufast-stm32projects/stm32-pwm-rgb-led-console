#include "pwm_control.h"
#include "main.h"  // for htimX

// You'll adapt the below based on actual timers/channels from CubeMX

extern TIM_HandleTypeDef htim2;

#define MAX_PWM 255

void pwm_init(void) {
    HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1); // R
    HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2); // G
    HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_3); // B

    // Set initial duty cycle to 50% for all channels
    __HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_1, htim2.Init.Period / 2); // Red
    __HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_2, htim2.Init.Period / 2); // Green
    __HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_3, htim2.Init.Period / 2); // Blue


}

static void set_pwm(TIM_HandleTypeDef *htim, uint32_t channel, uint8_t val) {
    __HAL_TIM_SET_COMPARE(htim, channel, val);
}

void pwm_set_red(uint8_t val) {
    set_pwm(&htim2, TIM_CHANNEL_1, val);
}
void pwm_set_green(uint8_t val) {
    set_pwm(&htim2, TIM_CHANNEL_2, val);
}
void pwm_set_blue(uint8_t val) {
    set_pwm(&htim2, TIM_CHANNEL_3, val);
}
