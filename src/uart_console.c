#include "stm32u5xx_hal.h"
#include "main.h"
#include "uart_console.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

// Assuming UART1
#define UART_HANDLE   huart1
extern UART_HandleTypeDef UART_HANDLE;

// Ring buffer size
#define RX_BUF_LEN 64
static uint8_t rx_buffer[RX_BUF_LEN];
static volatile uint8_t head = 0, tail = 0;

static uint8_t current_byte;

// ---- PWM output functions ----
extern void pwm_set_red(uint8_t value);
extern void pwm_set_green(uint8_t value);
extern void pwm_set_blue(uint8_t value);

// Interrupt callback
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if (huart == &UART_HANDLE) {
        uint8_t next = (head + 1) % RX_BUF_LEN;
        if (next != tail) {
            rx_buffer[head] = current_byte;
            head = next;
        }
        // Restart reception
        HAL_UART_Receive_IT(&UART_HANDLE, &current_byte, 1);
    }
}

// Init
void uart_console_init(void) {
    // Clear buffer
    head = 0;
    tail = 0;

    // Start receiving
    HAL_UART_Receive_IT(&UART_HANDLE, &current_byte, 1);

    // Send welcome message
    printf("RGB LED PWM Control Console Ready\r\n");
    printf("Commands: r=value, g=value, b=value (0-255)\r\n");
    printf("Single: r=128, g=64, b=255\r\n");
    printf("Multi:  r=128 g=64 b=255\r\n");
}

// Parse input
static void process_line(const char *line) {
    char channel;
    int value;
    int r_val = -1, g_val = -1, b_val = -1;
    int parsed_count = 0;

    // Try to parse multiple channel format first: "r=128 g=64 b=255"
    const char *ptr = line;
    while (*ptr) {
        // Skip whitespace
        while (*ptr == ' ' || *ptr == '\t') ptr++;
        if (!*ptr) break;

        // Parse channel=value
        if (sscanf(ptr, "%c=%d", &channel, &value) == 2) {
            if (value < 0) value = 0;
            if (value > 255) value = 255;

            switch (channel) {
                case 'r':
                    r_val = value;
                    parsed_count++;
                    break;
                case 'g':
                    g_val = value;
                    parsed_count++;
                    break;
                case 'b':
                    b_val = value;
                    parsed_count++;
                    break;
                default:
                    printf("Invalid channel: %c\r\n", channel);
                    return;
            }

            // Move pointer past the parsed part
            while (*ptr && *ptr != ' ' && *ptr != '\t') ptr++;
        } else {
            // If we can't parse channel=value, try single channel format
            break;
        }
    }

    // If we parsed multiple channels, apply them all
    if (parsed_count > 1) {
        if (r_val >= 0) {
            pwm_set_red(r_val);
            printf("Red set to %d\r\n", r_val);
        }
        if (g_val >= 0) {
            pwm_set_green(g_val);
            printf("Green set to %d\r\n", g_val);
        }
        if (b_val >= 0) {
            pwm_set_blue(b_val);
            printf("Blue set to %d\r\n", b_val);
        }
        return;
    }

    // Fallback to single channel parsing for backward compatibility
    if (sscanf(line, "%c=%d", &channel, &value) == 2) {
        if (value < 0) value = 0;
        if (value > 255) value = 255;

        switch (channel) {
            case 'r':
                pwm_set_red(value);
                printf("Red set to %d\r\n", value);
                break;
            case 'g':
                pwm_set_green(value);
                printf("Green set to %d\r\n", value);
                break;
            case 'b':
                pwm_set_blue(value);
                printf("Blue set to %d\r\n", value);
                break;
            default:
                printf("Invalid channel: %c\r\n", channel);
                break;
        }
    } else {
        printf("Invalid format. Use: channel=value (e.g., r=128) or r=128 g=64 b=255\r\n");
    }
}

void uart_console_process(void) {
    static char line[32];
    static uint8_t pos = 0;

    while (tail != head) {
        char c = rx_buffer[tail];
        tail = (tail + 1) % RX_BUF_LEN;

        if (c == '\r' || c == '\n') {
            if (pos > 0) {
                line[pos] = 0;
                process_line(line);
                pos = 0;
            }
        } else if (pos < sizeof(line) - 1) {
            line[pos++] = c;
        } else {
            // Buffer overflow, reset
            pos = 0;
            printf("Line too long, ignored\r\n");
        }
    }
}

