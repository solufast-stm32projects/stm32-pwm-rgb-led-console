# STM32 PWM RGB LED Console

A fun, FreeRTOS-powered RGB LED controller for STM32U5xx boards, controllable via UART console commands. Designed for learning, hacking, and home lighting fun—no STM32CubeIDE required!

## Features
- Control RGB LED color via UART commands
- Automatic color cycling (cyclic/rainbow or random)
- Predefined patterns: rainbow, fire, police, party
- Smooth fade/transition effects
- Adjustable brightness
- "Surprise me" mode for random fun
- FreeRTOS-based multitasking
- Modular, hackable codebase

## Project Evolution
This project is a living, learning journey! Here’s how it’s grown:

- **v1.0.0**: Bare-metal STM32, simple polling loop, UART commands for RGB LED control.
- **v2.0.0**: FreeRTOS integration—true multitasking, modular code, robust error handling.
- **v2.0.1**: Added auto mode, patterns (rainbow, fire, police, party), fade effects, brightness, "surprise me" mode, and a major modular refactor. All pattern/auto intervals are now user-configurable. Documentation and codebase polished for sharing.

I hope you enjoy hacking and extending it as much as I did building it!

## Hardware Requirements
- STM32U585xx (or compatible) development board
- RGB LED connected to TIM2 PWM outputs (PA0, PA1, PA2)
- UART1 (PA9/PA10) for console
- USB-to-serial adapter (for PC connection)

## Build & Flash Instructions
1. **Clone the repo:**
   ```sh
   git clone <the-repo-url>
   cd stm32-pwm-rgb-led-console
   ```
2. **Build:**
   ```sh
   make
   ```
3. **Flash:**
   ```sh
   make flash
   ```
   (Requires STM32_Programmer_CLI or OpenOCD)

## UART Console Command Reference
| Command                | Description                                 |
|------------------------|---------------------------------------------|
| `r=128`                | Set red channel (0-255)                     |
| `g=64`                 | Set green channel (0-255)                   |
| `b=255`                | Set blue channel (0-255)                    |
| `auto=on` / `auto=off` | Enable/disable automatic color mode         |
| `auto=mode=cyclic`     | Cyclic (rainbow) auto mode                  |
| `auto=mode=random`     | Random color auto mode                      |
| `auto=interval=NNN`    | Set auto/pattern interval in ms             |
| `fade=on` / `fade=off` | Enable/disable smooth color transitions     |
| `fade=speed=NNN`       | Set fade speed (ms per step)                |
| `pattern=rainbow`      | Rainbow color pattern                      |
| `pattern=fire`         | Fireplace flicker pattern                   |
| `pattern=police`       | Police lights pattern                       |
| `pattern=party`        | Party/random pattern                        |
| `pattern=off`          | Disable pattern, return to auto/manual      |
| `brightness=NNN`       | Set global brightness (0-255)               |
| `status`               | Print current settings/status               |
| `surprise`             | Random fun mode                             |

## Example Usage
- Set LED to purple: `r=128 g=0 b=128`
- Enable rainbow pattern: `pattern=rainbow`
- Set fast party mode: `pattern=party auto=interval=30 fade=on fade=speed=5`
- Lower brightness: `brightness=64`
- Get current status: `status`
- Try something wild: `surprise`

## Credits
- Project by Solomon Negussie TESEMA (solomon.negussie.tesema@gmail.com)
- Built with STM32 HAL, FreeRTOS, and lots of curiosity!

---

**Have fun, hack away, and light up your world!**
