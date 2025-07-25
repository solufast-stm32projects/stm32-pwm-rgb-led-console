# Changelog

## [3.0.0] - 2024-12-23
### Added
- **ToF (Time-of-Flight) sensor integration** for proximity-based brightness control
- New UART commands: `tof=on/off` and `tof=status` for ToF mode control
- Automatic brightness adjustment based on distance from ToF sensor
- **System health monitoring** - Industry-standard embedded system diagnostics
- New diagnostic commands: `health`, `performance`, and `reset` for system monitoring
- Centralized LED PWM control through dedicated `led_renderer.c` module
- Improved project structure with better separation of concerns

### Changed
- **Major architectural improvement**: LED PWM handling now centralized in `led_renderer.c`
- Enhanced modularity: ToF functionality isolated in dedicated module
- Better code organization and maintainability
- Updated documentation to reflect new ToF capabilities and system monitoring features

### Technical Details
- ToF sensor provides real-time distance measurements
- Brightness automatically adjusts based on proximity (closer = brighter)
- Maintains all existing RGB control features while adding proximity awareness
- Seamless integration with existing auto modes and patterns
- **System health monitoring includes**: FreeRTOS task statistics, memory usage tracking, performance metrics, error counters, and uptime monitoring

---

## [2.0.1] - 2024-12-22
### Added
- Auto mode (cyclic/random) for hands-free color cycling
- Predefined patterns: rainbow, fire, police, party
- Smooth fade/transition effects (with configurable speed)
- Adjustable global brightness
- "Surprise me" mode for random fun
- Status query command
- Modular refactor: each pattern and mode in its own function
- All pattern/auto intervals now user-configurable
- Cyclic mode now uses a true HSV color wheel for vibrant transitions
- Documentation polish: new README, changelog, and command reference

### Changed
- Codebase is now more modular, readable, and ready for further hacking

---

## [2.0.0] - 2024-12-19
### Added
- FreeRTOS integration: true multitasking (UART, PWM, heartbeat tasks)
- Advanced UART console for real-time RGB LED control
- Modular PWM control and UART parser
- Modern, script-based build system (no STM32CubeIDE required)
- Error handling, assertion hooks, and robust task structure

### Changed
- Project structure reorganized for RTOS and modularity
- Documentation updated for RTOS version

---

## [1.0.0] - 2024-12-18
### Added
- Bare-metal RGB LED control via PWM and UART
- Simple command parser for setting R/G/B values
- Standalone, no RTOS, polling-based main loop
- IDE-independent build system

---

**See README.md for full feature and usage details.**
