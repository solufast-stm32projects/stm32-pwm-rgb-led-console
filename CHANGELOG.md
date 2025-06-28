# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-12-19

### Added
- **FreeRTOS Integration**: Complete real-time operating system support
- **Multi-Task Architecture**: Three independent tasks with proper priorities
  - HeartbeatTask (Priority 1): System monitoring and LED heartbeat
  - UartConsoleTask (Priority 2): UART command processing
  - LedPwmTask (Priority 2): PWM control and effects processing
- **Advanced UART Console**: Interrupt-driven command processing with ring buffer
- **Modular PWM Control**: Separate PWM control module with bounds checking
- **Configuration Management**: YAML-based FreeRTOS configuration with automatic header generation
- **Enhanced Error Handling**: Comprehensive error hooks and assertions
- **Real-Time Performance**: Deterministic timing with FreeRTOS scheduler
- **Memory Management**: Dynamic memory allocation with heap_4
- **Interrupt Handling**: Proper FreeRTOS interrupt integration

### Changed
- **Build System**: Enhanced to support FreeRTOS compilation
- **Project Structure**: Reorganized to separate FreeRTOS tasks and modules
- **Documentation**: Completely updated README.md for FreeRTOS version
- **Configuration**: Moved from hardcoded FreeRTOS settings to YAML configuration

### Fixed
- **Interrupt Priority**: Corrected STM32U5 interrupt priority configuration (8-bit vs 3-bit)
- **SysTick Configuration**: Fixed HAL SysTick conflict with FreeRTOS
- **Vector Table**: Resolved duplicate interrupt handler definitions
- **Assertion Handling**: Added proper vAssertCalled function declaration

### Technical Details
- **CPU Clock**: 160 MHz
- **FreeRTOS Tick Rate**: 1000 Hz
- **Max Priorities**: 5
- **Heap Size**: 8 KB
- **Stack Overflow Detection**: Enabled
- **Interrupt Priorities**: Optimized for STM32U5 (8-bit priority system)

## [1.0.0] - 2024-12-18

### Added
- **Bare Metal Implementation**: Simple polling-based approach
- **Basic UART Console**: Simple command processing
- **Direct PWM Control**: Basic PWM functionality for RGB LED
- **IDE-Independent Build**: Custom build system with config.yaml
- **Open-Source Debugging**: OpenOCD and GDB support
- **Modular Code**: Clean separation between application logic and drivers

### Technical Details
- **CPU Clock**: 160 MHz
- **PWM Frequency**: ~625 kHz (160MHz / 256)
- **UART Baud Rate**: 115200
- **Build System**: Python-based Makefile generation
