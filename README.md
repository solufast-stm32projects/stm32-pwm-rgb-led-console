# STM32 PWM RGB LED Console

A fun, FreeRTOS-powered RGB LED controller for STM32U5xx boards, controllable via UART console commands. Designed for learning, hacking, and home lighting fun—no STM32CubeIDE required!

## Features
- Control RGB LED color via UART commands
- **ToF sensor integration for proximity-based brightness control**
- Automatic color cycling (cyclic/rainbow or random)
- Predefined patterns: rainbow, fire, police, party
- Smooth fade/transition effects
- Adjustable brightness (manual or proximity-based)
- "Surprise me" mode for random fun
- **System health monitoring** - Industry-standard embedded system diagnostics
- FreeRTOS-based multitasking
- Modular, hackable codebase with centralized LED control

## Project Evolution
This project is a living, learning journey! Here's how it's grown:

- **v1.0.0**: Bare-metal STM32, simple polling loop, UART commands for RGB LED control.
- **v2.0.0**: FreeRTOS integration—true multitasking, modular code, robust error handling.
- **v2.0.1**: Added auto mode, patterns (rainbow, fire, police, party), fade effects, brightness, "surprise me" mode, and a major modular refactor. All pattern/auto intervals are now user-configurable. Documentation and codebase polished for sharing.
- **v3.0.0**: **ToF sensor integration!** Proximity-based brightness control, centralized LED PWM handling in `led_renderer.c`, and major architectural improvements for better modularity and maintainability.

I hope you enjoy hacking and extending it as much as I did building it!

## Hardware Requirements
- STM32U585xx (B-U585I-IOT02A ) (or compatible) development board
- RGB LED connected to TIM2 PWM outputs (PA0, PA1, PA2)
- UART1 (PA9/PA10) for console
- USB-to-serial adapter (for PC connection)
- **ToF (Time-of-Flight) sensor** for proximity-based brightness control (VL53L5CX ToF sensor already built in on B-U585I-IOT02A board!)

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
| Command                | Description                                       |
|------------------------|---------------------------------------------------|
| `r=128`                | Set red channel (0-255)                           |
| `g=64`                 | Set green channel (0-255)                         |
| `b=255`                | Set blue channel (0-255)                          |
| `auto=on` / `auto=off` | Enable/disable automatic color mode               |
| `auto=mode=cyclic`     | Cyclic (rainbow) auto mode                        |
| `auto=mode=random`     | Random color auto mode                            |
| `auto=interval=NNN`    | Set auto/pattern interval in ms                   |
| `fade=on` / `fade=off` | Enable/disable smooth color transitions           |
| `fade=speed=NNN`       | Set fade speed (ms per step)                      |
| `pattern=rainbow`      | Rainbow color pattern                             |
| `pattern=fire`         | Fireplace flicker pattern                         |
| `pattern=police`       | Police lights pattern                             |
| `pattern=party`        | Party/random pattern                              |
| `pattern=off`          | Disable pattern, return to auto/manual            |
| `brightness=NNN`       | Set global brightness (0-255)                     |
| `status`               | Print current settings/status                     |
| `surprise`             | Random fun mode                                   |
| `tof=on` / `tof=off`   | Enable/disable proximity-based color mode (ToF)   |
| `tof=status`           | Print ToF mode status and last measured distance  |
| `health`               | Display system health metrics and diagnostics     |
| `performance`          | Show real-time performance statistics             |
| `reset`                | Reset system health counters                      |

## Example Usage
- Set LED to purple: `r=128 g=0 b=128`
- Enable rainbow pattern: `pattern=rainbow`
- Set fast party mode: `pattern=party auto=interval=30 fade=on fade=speed=5`
- Lower brightness: `brightness=64`
- Get current status: `status`
- Try something wild: `surprise`
- **Enable proximity-based brightness: `tof=on`**
- **Check ToF sensor status: `tof=status`**
- **Interactive lighting: `tof=on pattern=rainbow` (rainbow that responds to proximity!)**
- **Monitor system health: `health`**
- **Check performance: `performance`**
- **Reset counters: `reset`**

## System Health Monitoring
This project includes a comprehensive system health monitoring system that demonstrates industry-standard embedded system diagnostics practices:

- **Task Statistics**: Monitor FreeRTOS task execution times, stack usage, and CPU utilization
- **Memory Monitoring**: Track heap usage and memory allocation patterns
- **Performance Metrics**: Real-time performance counters and timing analysis
- **Error Tracking**: System error counters and diagnostic information
- **Uptime Monitoring**: System uptime and operational statistics

This feature serves as an excellent learning tool for understanding how professional embedded systems implement monitoring and diagnostics. It's particularly valuable for students and developers learning embedded systems best practices.

## Credits
- Project by Solomon Negussie TESEMA (solomon.negussie.tesema@gmail.com)
- Built with STM32 HAL, FreeRTOS, and lots of curiosity!

---

**Have fun, hack away, and light up your world!**
