#include "i2c.h"
#include "stm32u5xx_hal.h"
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"

extern I2C_HandleTypeDef hi2c2;

void i2c2_scan_and_read_id(void) {
    printf("I2C2 scan (7-bit): ");
    for (uint8_t addr = 1; addr < 127; addr++) {
        if (HAL_I2C_IsDeviceReady(&hi2c2, addr << 1, 1, 10) == HAL_OK) {
            printf("0x%02X (8-bit: 0x%02X) ", addr, addr << 1);
            // Try to read 0x010F (VL53L5CX ID)
            uint8_t id_bytes[2] = {0};
            HAL_StatusTypeDef res = HAL_I2C_Mem_Read(&hi2c2, addr << 1, 0x010F, I2C_MEMADD_SIZE_16BIT, id_bytes, 2, 100);
            if (res == HAL_OK) {
                uint16_t id = (id_bytes[0] << 8) | id_bytes[1];
                printf("ID: 0x%04X ", id);
            } else {
                printf("ID: -- ");
            }
        }
    }
} 

void test_lps22hh_whoami(void) {
    uint8_t whoami = 0;
    HAL_StatusTypeDef res = HAL_I2C_Mem_Read(&hi2c2, 0x5D << 1, 0x0F, I2C_MEMADD_SIZE_8BIT, &whoami, 1, 100);
    if (res == HAL_OK) {
        printf("LPS22HH WHO_AM_I: 0x%02X\r\n", whoami);
    } else {
        printf("LPS22HH I2C read error: %d\r\n", res);
    }
}
