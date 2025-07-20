# Changelog

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
