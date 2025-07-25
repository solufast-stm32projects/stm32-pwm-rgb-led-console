/**
 * @file           : main.c
 * @brief          : Main program body
 */
#include "stm32u5xx_hal.h"
#include "main.h"
#include "stdio.h"
#include <stdint.h>
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
#include "i2c.h"

#include "auto_mode.h"
#include "tof_control.h"
#include "pwm_control.h"
#include "uart_console.h"
#include "led_renderer.h"
#include "system_health.h"


// Forward declaration for busy_wait_ms
static void busy_wait_ms(uint32_t ms);

//
// Private variables
//
TIM_HandleTypeDef htim2;
UART_HandleTypeDef huart1;
I2C_HandleTypeDef hi2c1;
I2C_HandleTypeDef hi2c2;
//
// Private function prototypes
//
void SystemClock_Config(void);
static void SystemPower_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM2_Init(void);
static void MX_USART1_UART_Init(void);
static void MX_I2C2_Init(void);
static void MX_I2C1_Init(void);

// FreeRTOS task prototypes
void UartConsoleTask(void *argument);
void LedPwmTask(void *argument);
void HeartbeatTask(void *argument);
void StartToFTaskAfterDelay(void *argument);
void StartLedRenderer(void *argument);
void SystemHealthTask(void *argument);

int __io_putchar(int ch)
{
    HAL_UART_Transmit(&huart1, (uint8_t*)&ch, 1, HAL_MAX_DELAY);
    return ch;
}

// Override HAL_InitTick for FreeRTOS compatibility
HAL_StatusTypeDef HAL_InitTick(uint32_t TickPriority)
{
    // For FreeRTOS, we don't configure SysTick here
    // FreeRTOS will configure it in vTaskStartScheduler()
    return HAL_OK;
}

// Assert function for FreeRTOS
void vAssertCalled(const char *file, int line)
{
    // Enhanced assertion handling with system health
    system_error_handler(ERROR_STACK_OVERFLOW, file, line);

    // Simple LED indication of assertion failure
    HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);

    // Infinite loop - should never reach here if FreeRTOS is working
    while (1) {
        HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);
        //for(volatile int i = 0; i < 1000000; i++);
    }
}

// Simple heartbeat task
void HeartbeatTask(void *argument)
{
    while (1) {
        HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

// UART console task to process incoming commands
void UartConsoleTask(void *argument) {
    while (1) {
        uart_console_process();  // non-blocking parser
        vTaskDelay(pdMS_TO_TICKS(10));
    }
}

// LED PWM task to control LED brightness using PWM
void LedPwmTask(void *argument) {
    while (1) {
        if (auto_mode_get_enabled()) {
            auto_mode_process();
            system_health_increment_auto_cycles();
        } else {
            pwm_control_process();
        }
        vTaskDelay(pdMS_TO_TICKS(10));
    }
}

void StartToFTaskAfterDelay(void *argument) {
  vTaskDelay(pdMS_TO_TICKS(50));
  if (xTaskCreate(tof_control_task, "ToF", 256, NULL, 2, NULL) != pdPASS) {
      printf("[ERROR] Failed to create ToF task!\r\n");
      system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
  } else {
      printf("[ToF] Task created.\r\n");
  }
  vTaskDelete(NULL);
}

void StartLedRenderer(void *argument) {
  while(1) {
    led_renderer_task();
    vTaskDelay(pdMS_TO_TICKS(10));
  }
}

// System health monitoring task
void SystemHealthTask(void *argument) {
    while(1) {
        system_health_update();
        performance_metrics_update();
        vTaskDelay(pdMS_TO_TICKS(1000)); // Update every second
    }
}

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* Configure the System Power and System Clock */
  SystemPower_Config();
  SystemClock_Config();
  SystemCoreClockUpdate();

  /* Initialize essential peripherals */
  MX_GPIO_Init();
  MX_TIM2_Init();
  MX_USART1_UART_Init();
  MX_I2C1_Init();
  MX_I2C2_Init();

  // GPIO_PinState state = HAL_GPIO_ReadPin(Mems_VL53_xshut_GPIO_Port, Mems_VL53_xshut_Pin);
  // printf("PH1 (Mems_VL53_xshut) state after init: %s\r\n", state == GPIO_PIN_SET ? "HIGH" : "LOW");


  /* Scan I2C2 bus for devices and print ID reg */
  // i2c2_scan_and_read_id();
  // test_lps22hh_whoami();

  /* Initialize PWM and UART console modules */
  pwm_init();
  uart_console_init();
  auto_mode_init();

  /* Initialize system health monitoring */
  system_health_init();
  performance_metrics_init();

  /* Initialize ToF control */
  bool tof_ok = tof_control_init();
  if (tof_ok) {
      printf("ToF sensor ready.\r\n");
  } else {
      printf("ToF sensor init failed! ToF task not started.\r\n");
      system_error_handler(ERROR_TOF_SENSOR_FAIL, __FILE__, __LINE__);
  }

  led_renderer_init();


  // auto_mode_load_settings(); // Uncomment to test saving at boot

  /* Create FreeRTOS tasks */
  printf("Creating FreeRTOS tasks...\n");

  // Create heartbeat task (lowest priority)

  if (xTaskCreate(HeartbeatTask, "Heartbeat", 128, NULL, 1, NULL) != pdPASS) {
    printf("[ERROR] Failed to create Heartbeat task!\r\n");
    system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
  }
  printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());


  // Create UART console task (medium priority)
  if (xTaskCreate(UartConsoleTask, "UartConsole", 256, NULL, 2, NULL) != pdPASS) {
    printf("[ERROR] Failed to create UartConsoleTask task!\r\n");
    system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
  }
  printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());

  // Create LED PWM task (medium priority)

  if (xTaskCreate(LedPwmTask, "LedPwm", 128, NULL, 2, NULL) != pdPASS) {
        printf("[ERROR] Failed to create  UART console task!\r\n");
        system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
  }
  printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());


    // Create RGB-LED control/renderer task
    if (xTaskCreate(StartLedRenderer, "LEDControl", 256, NULL, 2, NULL) != pdPASS) {
        printf("[ERROR] Failed to create LED renderer task!\r\n");
        system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
    }
    printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());

    // Create system health monitoring task
    if (xTaskCreate(SystemHealthTask, "SystemHealth", 256, NULL, 1, NULL) != pdPASS) {
        printf("[ERROR] Failed to create system health task!\r\n");
        system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
    }
    printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());


  // Create ToF task after delay if init succeeded
  if (tof_ok) {
    if (xTaskCreate(StartToFTaskAfterDelay, "ToFDelay", 256, NULL, 2, NULL) != pdPASS) {
        printf("[ERROR] Failed to create ToF task!\r\n");
        system_error_handler(ERROR_MALLOC_FAILED, __FILE__, __LINE__);
    }
  }
  printf("Free heap: %u bytes\n", xPortGetFreeHeapSize());


 // test_lps22hh_whoami();

  printf("Starting scheduler...\n");
  vTaskStartScheduler();

  // If you reach here, something went wrong!
  printf("Scheduler exited unexpectedly!\n");
  /* We should never reach here */
  while (1) {
    // Fail-safe loop
    printf("[ERROR] Scheduler exited, blinking LED.\n");
    HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);
    for(volatile int i = 0; i < 10000000; i++);
  }
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  if (HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI48|RCC_OSCILLATORTYPE_HSI
                              |RCC_OSCILLATORTYPE_MSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSI48State = RCC_HSI48_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.MSIState = RCC_MSI_ON;
  RCC_OscInitStruct.MSICalibrationValue = RCC_MSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.MSIClockRange = RCC_MSIRANGE_4;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_MSI;
  RCC_OscInitStruct.PLL.PLLMBOOST = RCC_PLLMBOOST_DIV1;
  RCC_OscInitStruct.PLL.PLLM = 1;
  RCC_OscInitStruct.PLL.PLLN = 80;
  RCC_OscInitStruct.PLL.PLLP = 2;
  RCC_OscInitStruct.PLL.PLLQ = 2;
  RCC_OscInitStruct.PLL.PLLR = 2;
  RCC_OscInitStruct.PLL.PLLRGE = RCC_PLLVCIRANGE_0;
  RCC_OscInitStruct.PLL.PLLFRACN = 0;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2
                              |RCC_CLOCKTYPE_PCLK3;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB3CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_4) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief Power Configuration
  * @retval None
  */
static void SystemPower_Config(void)
{
  HAL_PWREx_EnableVddIO2();

  /*
   * Switch to SMPS regulator instead of LDO
   */
  if (HAL_PWREx_ConfigSupply(PWR_SMPS_SUPPLY) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{
  TIM_MasterConfigTypeDef sMasterConfig = {0};
  TIM_OC_InitTypeDef sConfigOC = {0};

  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 79;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 255;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_PWM_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 128;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim2, &sConfigOC, TIM_CHANNEL_1) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_PWM_ConfigChannel(&htim2, &sConfigOC, TIM_CHANNEL_2) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_PWM_ConfigChannel(&htim2, &sConfigOC, TIM_CHANNEL_3) != HAL_OK)
  {
    Error_Handler();
  }
  HAL_TIM_MspPostInit(&htim2);
}

/**
  * @brief USART1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART1_UART_Init(void)
{
  huart1.Instance = USART1;
  huart1.Init.BaudRate = 115200;
  huart1.Init.WordLength = UART_WORDLENGTH_8B;
  huart1.Init.StopBits = UART_STOPBITS_1;
  huart1.Init.Parity = UART_PARITY_NONE;
  huart1.Init.Mode = UART_MODE_TX_RX;
  huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart1.Init.OverSampling = UART_OVERSAMPLING_16;
  huart1.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
  huart1.Init.ClockPrescaler = UART_PRESCALER_DIV1;
  huart1.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  if (HAL_UART_Init(&huart1) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_UARTEx_SetTxFifoThreshold(&huart1, UART_TXFIFO_THRESHOLD_1_8) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_UARTEx_SetRxFifoThreshold(&huart1, UART_RXFIFO_THRESHOLD_1_8) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_UARTEx_DisableFifoMode(&huart1) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
  static void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    // Enable GPIO clocks
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOG_CLK_ENABLE();
    __HAL_RCC_GPIOH_CLK_ENABLE();

    // --- USER Button ---
    GPIO_InitStruct.Pin = USER_Button_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(USER_Button_GPIO_Port, &GPIO_InitStruct);

    // --- Onboard GREEN LED (PH7) ---
    GPIO_InitStruct.Pin = LED_GREEN_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOH, &GPIO_InitStruct);
    HAL_GPIO_WritePin(GPIOH, LED_GREEN_Pin, GPIO_PIN_RESET);

    // --- PWM LED pins (PA0, PA1, PA2) ---
    GPIO_InitStruct.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_2;
    GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    GPIO_InitStruct.Alternate = GPIO_AF1_TIM2;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    // --- STMod+ Mode Select: PH13 HIGH to enable GPIO instead of SPI1 ---
    GPIO_InitStruct.Pin = GPIO_PIN_13;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOH, &GPIO_InitStruct);
    HAL_GPIO_WritePin(GPIOH, GPIO_PIN_13, GPIO_PIN_SET); // Enable GPIO mode

    // --- VL53L5CX GPIOs ---
    // PH1 = LPn_C (Low Power shutdown / XSHUT)
    GPIO_InitStruct.Pin = Mems_VL53_xshut_Pin;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;  // Must be output
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(Mems_VL53_xshut_GPIO_Port, &GPIO_InitStruct);

    // --- VL53L5CX Power-up Sequence for B-U585I-IOT02A ---
    // Use only XSHUT (shutdown) pin: Mems_VL53_xshut_Pin (PH1)
    // Set XSHUT LOW (sensor in shutdown)
    HAL_GPIO_WritePin(Mems_VL53_xshut_GPIO_Port, Mems_VL53_xshut_Pin, GPIO_PIN_RESET);
    busy_wait_ms(10);

    // Set XSHUT HIGH (sensor boots up)
    HAL_GPIO_WritePin(Mems_VL53_xshut_GPIO_Port, Mems_VL53_xshut_Pin, GPIO_PIN_SET);
    busy_wait_ms(500); // Wait for sensor to boot

    // --- I2C2 pins (PH4 = SCL, PH5 = SDA) ---
    GPIO_InitStruct.Pin = GPIO_PIN_4 | GPIO_PIN_5;
    GPIO_InitStruct.Mode = GPIO_MODE_AF_OD;         // Open-drain for I2C
    GPIO_InitStruct.Pull = GPIO_PULLUP;             // Pull-up required for I2C
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    GPIO_InitStruct.Alternate = GPIO_AF4_I2C2;      // AF4 for I2C2 on PH4/PH5
    HAL_GPIO_Init(GPIOH, &GPIO_InitStruct);
}


/**
  * @brief I2C1 Initialization Function
  * @param None
  * @retval None
  */
  static void MX_I2C1_Init(void)
  {

    /* USER CODE BEGIN I2C1_Init 0 */

    /* USER CODE END I2C1_Init 0 */

    /* USER CODE BEGIN I2C1_Init 1 */

    /* USER CODE END I2C1_Init 1 */
    hi2c1.Instance = I2C1;
    hi2c1.Init.Timing = 0x30909DEC;
    hi2c1.Init.OwnAddress1 = 0;
    hi2c1.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
    hi2c1.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
    hi2c1.Init.OwnAddress2 = 0;
    hi2c1.Init.OwnAddress2Masks = I2C_OA2_NOMASK;
    hi2c1.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
    hi2c1.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
    if (HAL_I2C_Init(&hi2c1) != HAL_OK)
    {
      Error_Handler();
    }

    /** Configure Analogue filter
    */
    if (HAL_I2CEx_ConfigAnalogFilter(&hi2c1, I2C_ANALOGFILTER_ENABLE) != HAL_OK)
    {
      Error_Handler();
    }

    /** Configure Digital filter
    */
    if (HAL_I2CEx_ConfigDigitalFilter(&hi2c1, 0) != HAL_OK)
    {
      Error_Handler();
    }
    /* USER CODE BEGIN I2C1_Init 2 */

    /* USER CODE END I2C1_Init 2 */

  }

/**
  * @brief I2C2 Initialization Function
  * @param None
  * @retval None
  */
  static void MX_I2C2_Init(void)
  {

    /* USER CODE BEGIN I2C2_Init 0 */

    /* USER CODE END I2C2_Init 0 */

    /* USER CODE BEGIN I2C2_Init 1 */

    /* USER CODE END I2C2_Init 1 */
    hi2c2.Instance = I2C2;
    //hi2c2.Init.Timing = 0x30A0A7FB; // 100 kHz timing for STM32U5 @ 80MHz
    hi2c2.Init.Timing = 0x10C0ECFF; // 400kHz for STM32U5
    hi2c2.Init.OwnAddress1 = 0;
    hi2c2.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
    hi2c2.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
    hi2c2.Init.OwnAddress2 = 0;
    hi2c2.Init.OwnAddress2Masks = I2C_OA2_NOMASK;
    hi2c2.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
    hi2c2.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
    if (HAL_I2C_Init(&hi2c2) != HAL_OK)
    {
      Error_Handler();
    }

    /** Configure Analogue filter
    */
    if (HAL_I2CEx_ConfigAnalogFilter(&hi2c2, I2C_ANALOGFILTER_ENABLE) != HAL_OK)
    {
      Error_Handler();
    }

    /** Configure Digital filter
    */
    if (HAL_I2CEx_ConfigDigitalFilter(&hi2c2, 0) != HAL_OK)
    {
      Error_Handler();
    }
    /* USER CODE BEGIN I2C2_Init 2 */

    /* USER CODE END I2C2_Init 2 */

  }

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

void vApplicationMallocFailedHook(void) {
    printf("[FATAL] Malloc failed!\r\n");
    __disable_irq();
    while (1) {
        HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);
        busy_wait_ms(200);
    }
}

void vApplicationStackOverflowHook(TaskHandle_t xTask, char *pcTaskName) {
    printf("[FATAL] Stack overflow in task: %s\r\n", pcTaskName);
    __disable_irq();
    while (1) {
        HAL_GPIO_TogglePin(GPIOH, GPIO_PIN_7);
        busy_wait_ms(200);
    }
}


// Simple busy-wait delay for pre-RTOS use
static void busy_wait_ms(uint32_t ms) {
    volatile uint32_t count = ms * 8000; // ~8k cycles per ms at 160MHz
    while (count--) __NOP();
}


