#ifndef UART_CONSOLE_H
#define UART_CONSOLE_H

#include <stdint.h>
#include <stdbool.h>

void uart_console_init(void);
void uart_console_process(void);

#endif // UART_CONSOLE_H
