#ifndef TOF_CONTROL_H
#define TOF_CONTROL_H

#include <stdint.h>
#include <stdbool.h>

// Initialize the ToF sensor and related resources
bool tof_control_init(void);

// Enable or disable proximity-based color mode
void tof_control_enable(bool enable);

// Returns true if proximity mode is enabled
bool tof_control_is_enabled(void);

// Get the last measured distance (in mm)
uint16_t tof_control_get_distance(void);

// FreeRTOS task function for ToF processing
void tof_control_task(void *argument);

#endif // TOF_CONTROL_H 