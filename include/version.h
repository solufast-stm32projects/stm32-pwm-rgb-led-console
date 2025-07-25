/**
 * @file version.h
 * @brief Application version definitions
 * @author Solomon Negussie TESEMA
 * @date 2024-12-23
 */

#ifndef VERSION_H
#define VERSION_H

/* Application version information */
#define APP_VERSION_MAJOR        3
#define APP_VERSION_MINOR        0
#define APP_VERSION_PATCH        0
#define APP_VERSION_STRING       "3.0.0"

/* Version description */
#define APP_VERSION_DESCRIPTION  "ToF Sensor Integration & Architectural Improvements"

/* Build information */
#define APP_BUILD_DATE          __DATE__
#define APP_BUILD_TIME          __TIME__

/* Feature flags */
#define FEATURE_TOF_SENSOR      1
#define FEATURE_CENTRALIZED_LED 1
#define FEATURE_FREERTOS        1

#endif /* VERSION_H */
