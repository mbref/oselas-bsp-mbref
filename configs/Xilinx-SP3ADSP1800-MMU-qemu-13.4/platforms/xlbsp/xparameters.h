/*
 * This file was manually created.
 *
 * (C) Copyright 2012 Li-Pro.Net
 * Stephan Linz <linz@li-pro.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 * Version:  Xilinx EDK 13.4 ... (details unknown)
 * Today is: Wednesday, the 19 of Dezember, 2012; 16:13:37
 *
 * Description: U-Boot Configurations
 */

/* Project name */
#define XILINX_BOARD_NAME	"Xilinx-SP3ADSP1800-MMU-qemu-13.4"

/* Microblaze is microblaze_0 */
#define XILINX_USE_MSR_INSTR                     1
#define XILINX_PVR                               1
#define XILINX_FSL_NUMBER                        0
#define XILINX_USE_ICACHE                        1
#define XILINX_USE_DCACHE                        1
#define XILINX_DCACHE_BYTE_SIZE                  2048

/* Interrupt controller is xps_intc_0 */
#define XILINX_INTC_BASEADDR                     0x8AFF0000
#define XILINX_INTC_NUM_INTR_INPUTS              4
/* xps_uart_0_Interrupt */
/* xps_gpio_X_Interrupt */
/* xps_ether_0_IP2INTC_Irpt */
/* xps_timer_0_Interrupt */

/* System (Timer) Clock Frequency */
#define XILINX_CLOCK_FREQ                        62500000

/* Timer is xps_timer_0 */
#define XILINX_TIMER_BASEADDR                    0x8AEF0000
#define XILINX_TIMER_IRQ                         0

/* System memory is mpmc_0 */
#define XILINX_RAM_START                         0x20000000
#define XILINX_RAM_SIZE                          0x08000000

/* NOR Flash memory is xps_mch_emc_0 */
#define XILINX_FLASH_START                       0xAF000000
#define XILINX_FLASH_SIZE                        0x01000000

/* Uart controller UARTLITE 0 is xps_uart_0 */
#define XILINX_UARTLITE                         
#define XILINX_UARTLITE_BASEADDR                 0x89FF0000
#define XILINX_UARTLITE_BAUDRATE                 115200

/* Uart controller UARTLITE 1 is mdm_0 */
#define XILINX_UARTLITE_BASEADDR1                0x8FFF0000
#define XILINX_UARTLITE_BAUDRATE1                115200 /* WARNING: set default */

/* I2C controller not defined */

/* SPI controller not defined */

/* GPIO controller is xps_gpio_3 */
#define XILINX_GPIO_BASEADDR                     0x80F00000

/* Sysace CF controller not defined */

/* Ethernet MAC controller EMACLITE is xps_ether_0 */
#define XILINX_EMACLITE                         
#define XILINX_EMACLITE_BASEADDR                 0x88F00000

