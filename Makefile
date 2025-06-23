
# Auto-generated Makefile for STM32 project
# =========================================

TARGET  = stm32_pwm_console
CPU     = cortex-m33
FPU     = fpv5-sp-d16
FLOAT_ABI = hard

# Toolchain
CC      = arm-none-eabi-gcc
AS      = arm-none-eabi-gcc
CP      = arm-none-eabi-objcopy
SZ      = arm-none-eabi-size

# Build directory
BUILD_DIR = build

# C flags
CFLAGS  = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
CFLAGS += -Wall -g -Og -std=c11 -ffunction-sections -fdata-sections -MMD -MP -mcmse
CFLAGS += -DUSE_HAL_DRIVER \
          -DSTM32U585xx \
          -DUSE_FULL_LL_DRIVER
CFLAGS += -Iinclude \
          -Icube/Core/Inc \
          -Icube/Drivers/STM32U5xx_HAL_Driver/Inc \
          -Icube/Drivers/STM32U5xx_HAL_Driver/Inc/Legacy \
          -Icube/Drivers/CMSIS/Include \
          -Icube/Drivers/CMSIS/Device/ST/STM32U5xx/Include \
          -Icube/Drivers/CMSIS/Device/ST/STM32U5xx/Include/Templates

# Assembler flags
ASFLAGS = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
ASFLAGS += -x assembler-with-cpp

# Linker flags
LDFLAGS = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
LDFLAGS += -Tlinker/STM32U585xx_FLASH.ld -Wl,--gc-sections -specs=nano.specs -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# Libraries
LIBS = -lc -lm
LDFLAGS += $(LIBS)

# Sources
CSRCS = \
  cube/Core/Src/stm32u5xx_hal_msp.c \
  cube/Core/Src/syscalls.c \
  cube/Core/Src/sysmem.c \
  cube/Core/Src/system_stm32u5xx.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_adc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_adc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_comp.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cordic.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cortex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_crc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_crc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cryp.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cryp_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dac.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dac_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dcache.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dcmi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma2d.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dsi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_exti.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_fdcan.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_fmac.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gfxmmu.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gfxtim.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gpio.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gpu2d.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gtzc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hash.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hash_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hcd.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_icache.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_irda.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_iwdg.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_jpeg.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_lptim.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ltdc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ltdc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mdf.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mmc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mmc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_nand.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_nor.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_opamp.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_opamp_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ospi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_otfdec.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pcd.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pcd_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pka.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pssi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ramcfg.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rng.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rng_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rtc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rtc_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sai.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sai_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sd.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sd_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sdio.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smartcard.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smartcard_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smbus.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smbus_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_spi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_spi_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sram.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tsc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_uart.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_uart_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_usart.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_usart_ex.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_wwdg.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_xspi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_adc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_comp.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_cordic.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_crc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_crs.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dac.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dlyb.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dma.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dma2d.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_exti.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_fmac.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_fmc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_gpio.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_i2c.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_icache.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lpgpio.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lptim.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lpuart.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_opamp.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_pka.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_pwr.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rcc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rng.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rtc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_sdmmc.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_spi.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_tim.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_ucpd.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_usart.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_usb.c \
  cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_utils.c \
  src/main.c \
  src/pwm_control.c \
  src/stm32u5xx_it.c \
  src/uart_console.c

ASRCS = \
  cube/Drivers/CMSIS/Device/ST/STM32U5xx/Source/Templates/gcc/startup_stm32u585xx.s

# Object files with explicit paths
OBJS = $(BUILD_DIR)/stm32u5xx_hal_msp.o \
  $(BUILD_DIR)/syscalls.o \
  $(BUILD_DIR)/sysmem.o \
  $(BUILD_DIR)/system_stm32u5xx.o \
  $(BUILD_DIR)/stm32u5xx_hal.o \
  $(BUILD_DIR)/stm32u5xx_hal_adc.o \
  $(BUILD_DIR)/stm32u5xx_hal_adc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_comp.o \
  $(BUILD_DIR)/stm32u5xx_hal_cordic.o \
  $(BUILD_DIR)/stm32u5xx_hal_cortex.o \
  $(BUILD_DIR)/stm32u5xx_hal_crc.o \
  $(BUILD_DIR)/stm32u5xx_hal_crc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_cryp.o \
  $(BUILD_DIR)/stm32u5xx_hal_cryp_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_dac.o \
  $(BUILD_DIR)/stm32u5xx_hal_dac_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_dcache.o \
  $(BUILD_DIR)/stm32u5xx_hal_dcmi.o \
  $(BUILD_DIR)/stm32u5xx_hal_dma.o \
  $(BUILD_DIR)/stm32u5xx_hal_dma2d.o \
  $(BUILD_DIR)/stm32u5xx_hal_dma_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_dsi.o \
  $(BUILD_DIR)/stm32u5xx_hal_exti.o \
  $(BUILD_DIR)/stm32u5xx_hal_fdcan.o \
  $(BUILD_DIR)/stm32u5xx_hal_flash.o \
  $(BUILD_DIR)/stm32u5xx_hal_flash_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_fmac.o \
  $(BUILD_DIR)/stm32u5xx_hal_gfxmmu.o \
  $(BUILD_DIR)/stm32u5xx_hal_gfxtim.o \
  $(BUILD_DIR)/stm32u5xx_hal_gpio.o \
  $(BUILD_DIR)/stm32u5xx_hal_gpu2d.o \
  $(BUILD_DIR)/stm32u5xx_hal_gtzc.o \
  $(BUILD_DIR)/stm32u5xx_hal_hash.o \
  $(BUILD_DIR)/stm32u5xx_hal_hash_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_hcd.o \
  $(BUILD_DIR)/stm32u5xx_hal_i2c.o \
  $(BUILD_DIR)/stm32u5xx_hal_i2c_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_icache.o \
  $(BUILD_DIR)/stm32u5xx_hal_irda.o \
  $(BUILD_DIR)/stm32u5xx_hal_iwdg.o \
  $(BUILD_DIR)/stm32u5xx_hal_jpeg.o \
  $(BUILD_DIR)/stm32u5xx_hal_lptim.o \
  $(BUILD_DIR)/stm32u5xx_hal_ltdc.o \
  $(BUILD_DIR)/stm32u5xx_hal_ltdc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_mdf.o \
  $(BUILD_DIR)/stm32u5xx_hal_mmc.o \
  $(BUILD_DIR)/stm32u5xx_hal_mmc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_nand.o \
  $(BUILD_DIR)/stm32u5xx_hal_nor.o \
  $(BUILD_DIR)/stm32u5xx_hal_opamp.o \
  $(BUILD_DIR)/stm32u5xx_hal_opamp_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_ospi.o \
  $(BUILD_DIR)/stm32u5xx_hal_otfdec.o \
  $(BUILD_DIR)/stm32u5xx_hal_pcd.o \
  $(BUILD_DIR)/stm32u5xx_hal_pcd_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_pka.o \
  $(BUILD_DIR)/stm32u5xx_hal_pssi.o \
  $(BUILD_DIR)/stm32u5xx_hal_pwr.o \
  $(BUILD_DIR)/stm32u5xx_hal_pwr_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_ramcfg.o \
  $(BUILD_DIR)/stm32u5xx_hal_rcc.o \
  $(BUILD_DIR)/stm32u5xx_hal_rcc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_rng.o \
  $(BUILD_DIR)/stm32u5xx_hal_rng_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_rtc.o \
  $(BUILD_DIR)/stm32u5xx_hal_rtc_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_sai.o \
  $(BUILD_DIR)/stm32u5xx_hal_sai_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_sd.o \
  $(BUILD_DIR)/stm32u5xx_hal_sd_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_sdio.o \
  $(BUILD_DIR)/stm32u5xx_hal_smartcard.o \
  $(BUILD_DIR)/stm32u5xx_hal_smartcard_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_smbus.o \
  $(BUILD_DIR)/stm32u5xx_hal_smbus_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_spi.o \
  $(BUILD_DIR)/stm32u5xx_hal_spi_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_sram.o \
  $(BUILD_DIR)/stm32u5xx_hal_tim.o \
  $(BUILD_DIR)/stm32u5xx_hal_tim_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_tsc.o \
  $(BUILD_DIR)/stm32u5xx_hal_uart.o \
  $(BUILD_DIR)/stm32u5xx_hal_uart_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_usart.o \
  $(BUILD_DIR)/stm32u5xx_hal_usart_ex.o \
  $(BUILD_DIR)/stm32u5xx_hal_wwdg.o \
  $(BUILD_DIR)/stm32u5xx_hal_xspi.o \
  $(BUILD_DIR)/stm32u5xx_ll_adc.o \
  $(BUILD_DIR)/stm32u5xx_ll_comp.o \
  $(BUILD_DIR)/stm32u5xx_ll_cordic.o \
  $(BUILD_DIR)/stm32u5xx_ll_crc.o \
  $(BUILD_DIR)/stm32u5xx_ll_crs.o \
  $(BUILD_DIR)/stm32u5xx_ll_dac.o \
  $(BUILD_DIR)/stm32u5xx_ll_dlyb.o \
  $(BUILD_DIR)/stm32u5xx_ll_dma.o \
  $(BUILD_DIR)/stm32u5xx_ll_dma2d.o \
  $(BUILD_DIR)/stm32u5xx_ll_exti.o \
  $(BUILD_DIR)/stm32u5xx_ll_fmac.o \
  $(BUILD_DIR)/stm32u5xx_ll_fmc.o \
  $(BUILD_DIR)/stm32u5xx_ll_gpio.o \
  $(BUILD_DIR)/stm32u5xx_ll_i2c.o \
  $(BUILD_DIR)/stm32u5xx_ll_icache.o \
  $(BUILD_DIR)/stm32u5xx_ll_lpgpio.o \
  $(BUILD_DIR)/stm32u5xx_ll_lptim.o \
  $(BUILD_DIR)/stm32u5xx_ll_lpuart.o \
  $(BUILD_DIR)/stm32u5xx_ll_opamp.o \
  $(BUILD_DIR)/stm32u5xx_ll_pka.o \
  $(BUILD_DIR)/stm32u5xx_ll_pwr.o \
  $(BUILD_DIR)/stm32u5xx_ll_rcc.o \
  $(BUILD_DIR)/stm32u5xx_ll_rng.o \
  $(BUILD_DIR)/stm32u5xx_ll_rtc.o \
  $(BUILD_DIR)/stm32u5xx_ll_sdmmc.o \
  $(BUILD_DIR)/stm32u5xx_ll_spi.o \
  $(BUILD_DIR)/stm32u5xx_ll_tim.o \
  $(BUILD_DIR)/stm32u5xx_ll_ucpd.o \
  $(BUILD_DIR)/stm32u5xx_ll_usart.o \
  $(BUILD_DIR)/stm32u5xx_ll_usb.o \
  $(BUILD_DIR)/stm32u5xx_ll_utils.o \
  $(BUILD_DIR)/main.o \
  $(BUILD_DIR)/pwm_control.o \
  $(BUILD_DIR)/stm32u5xx_it.o \
  $(BUILD_DIR)/uart_console.o
AS_OBJS = $(BUILD_DIR)/startup_stm32u585xx.o

all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR)/stm32u5xx_hal_msp.o: cube/Core/Src/stm32u5xx_hal_msp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_msp.lst -o $@ $<

$(BUILD_DIR)/syscalls.o: cube/Core/Src/syscalls.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/syscalls.lst -o $@ $<

$(BUILD_DIR)/sysmem.o: cube/Core/Src/sysmem.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/sysmem.lst -o $@ $<

$(BUILD_DIR)/system_stm32u5xx.o: cube/Core/Src/system_stm32u5xx.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/system_stm32u5xx.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_adc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_adc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_adc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_adc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_adc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_adc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_comp.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_comp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_comp.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_cordic.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cordic.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_cordic.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_cortex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cortex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_cortex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_crc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_crc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_crc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_crc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_crc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_crc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_cryp.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cryp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_cryp.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_cryp_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cryp_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_cryp_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dac.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dac.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dac.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dac_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dac_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dac_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dcache.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dcache.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dcache.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dcmi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dcmi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dcmi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dma.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dma.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dma2d.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma2d.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dma2d.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dma_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dma_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_dsi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dsi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_dsi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_exti.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_exti.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_exti.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_fdcan.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_fdcan.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_fdcan.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_flash.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_flash.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_flash_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_flash_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_fmac.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_fmac.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_fmac.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_gfxmmu.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gfxmmu.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_gfxmmu.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_gfxtim.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gfxtim.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_gfxtim.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_gpio.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gpio.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_gpio.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_gpu2d.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gpu2d.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_gpu2d.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_gtzc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gtzc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_gtzc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_hash.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hash.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_hash.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_hash_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hash_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_hash_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_hcd.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_hcd.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_hcd.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_i2c.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_i2c.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_i2c_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_i2c_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_icache.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_icache.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_icache.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_irda.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_irda.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_irda.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_iwdg.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_iwdg.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_iwdg.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_jpeg.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_jpeg.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_jpeg.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_lptim.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_lptim.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_lptim.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_ltdc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ltdc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_ltdc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_ltdc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ltdc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_ltdc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_mdf.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mdf.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_mdf.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_mmc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mmc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_mmc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_mmc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_mmc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_mmc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_nand.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_nand.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_nand.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_nor.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_nor.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_nor.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_opamp.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_opamp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_opamp.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_opamp_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_opamp_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_opamp_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_ospi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ospi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_ospi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_otfdec.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_otfdec.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_otfdec.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pcd.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pcd.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pcd.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pcd_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pcd_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pcd_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pka.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pka.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pka.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pssi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pssi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pssi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pwr.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pwr.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_pwr_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_pwr_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_ramcfg.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_ramcfg.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_ramcfg.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rcc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rcc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rcc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rcc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rng.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rng.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rng.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rng_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rng_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rng_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rtc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rtc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rtc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_rtc_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rtc_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_rtc_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sai.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sai.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sai.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sai_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sai_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sai_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sd.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sd.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sd.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sd_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sd_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sd_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sdio.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sdio.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sdio.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_smartcard.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smartcard.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_smartcard.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_smartcard_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smartcard_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_smartcard_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_smbus.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smbus.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_smbus.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_smbus_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_smbus_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_smbus_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_spi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_spi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_spi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_spi_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_spi_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_spi_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_sram.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_sram.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_sram.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_tim.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_tim.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_tim_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_tim_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_tsc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tsc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_tsc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_uart.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_uart.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_uart.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_uart_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_uart_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_uart_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_usart.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_usart.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_usart.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_usart_ex.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_usart_ex.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_usart_ex.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_wwdg.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_wwdg.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_wwdg.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_hal_xspi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_xspi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_hal_xspi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_adc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_adc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_adc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_comp.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_comp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_comp.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_cordic.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_cordic.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_cordic.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_crc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_crc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_crc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_crs.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_crs.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_crs.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_dac.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dac.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_dac.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_dlyb.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dlyb.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_dlyb.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_dma.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dma.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_dma.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_dma2d.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_dma2d.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_dma2d.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_exti.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_exti.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_exti.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_fmac.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_fmac.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_fmac.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_fmc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_fmc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_fmc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_gpio.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_gpio.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_gpio.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_i2c.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_i2c.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_i2c.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_icache.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_icache.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_icache.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_lpgpio.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lpgpio.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_lpgpio.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_lptim.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lptim.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_lptim.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_lpuart.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_lpuart.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_lpuart.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_opamp.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_opamp.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_opamp.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_pka.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_pka.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_pka.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_pwr.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_pwr.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_pwr.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_rcc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rcc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_rcc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_rng.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rng.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_rng.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_rtc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_rtc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_rtc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_sdmmc.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_sdmmc.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_sdmmc.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_spi.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_spi.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_spi.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_tim.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_tim.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_tim.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_ucpd.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_ucpd.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_ucpd.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_usart.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_usart.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_usart.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_usb.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_usb.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_usb.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_ll_utils.o: cube/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_utils.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_ll_utils.lst -o $@ $<

$(BUILD_DIR)/main.o: src/main.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/main.lst -o $@ $<

$(BUILD_DIR)/pwm_control.o: src/pwm_control.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/pwm_control.lst -o $@ $<

$(BUILD_DIR)/stm32u5xx_it.o: src/stm32u5xx_it.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/stm32u5xx_it.lst -o $@ $<

$(BUILD_DIR)/uart_console.o: src/uart_console.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/uart_console.lst -o $@ $<


$(BUILD_DIR)/startup_stm32u585xx.o: cube/Drivers/CMSIS/Device/ST/STM32U5xx/Source/Templates/gcc/startup_stm32u585xx.s Makefile | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) -o $@ $<


$(BUILD_DIR)/$(TARGET).elf: $(OBJS) $(AS_OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	$(SZ) $@

$(BUILD_DIR):
	mkdir -p $@

flash: all
	STM32_Programmer_CLI -c port=SWD -w $(BUILD_DIR)/$(TARGET).elf 0x08000000 -v -rst

debug: all
	@echo "Starting OpenOCD and GDB for debugging..."
	@echo "OpenOCD will run in background. Use 'make debug-gdb' in another terminal to start GDB."
	@echo "Or use VS Code with Cortex-Debug extension."
	openocd -f openocd_stm32u585.cfg &

debug-gdb: all
	@echo "Starting GDB..."
	gdb-multiarch $(BUILD_DIR)/$(TARGET).elf

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all flash debug debug-gdb clean
