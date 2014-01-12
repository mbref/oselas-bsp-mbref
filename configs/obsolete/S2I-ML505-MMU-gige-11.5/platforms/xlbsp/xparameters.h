/*
 * (C) Copyright 2007-2009 Michal Simek
 * Michal SIMEK <monstr@monstr.eu>
 *
 * (C) Copyright 2010-2014 Li-Pro.Net
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
 * CAUTION:  This file is automatically generated by libgen.
 * Version:  Xilinx EDK 11.5 EDK_LS5.70
 * Today is: Sunday, the 12 of January, 2014; 15:08:09
 *
 * Description: U-Boot Configurations
 *
 * Generate by uboot-v4.02.a
 * Project description at http://www.monstr.eu/
 */

/* Project name */
#define XILINX_BOARD_NAME	"cpu"

/* Microblaze is microblaze_0 */
#define XILINX_USE_MSR_INSTR                     1
#define XILINX_PVR                               2
#define XILINX_FSL_NUMBER                        0
#define XILINX_USE_ICACHE                        1
#define XILINX_USE_DCACHE                        1
#define XILINX_DCACHE_BYTE_SIZE                  16384

/* Interrupt controller is xps_intc_0 */
#define XILINX_INTC_BASEADDR                     0x8AFF0000
#define XILINX_INTC_NUM_INTR_INPUTS              4
/* xps_ether_0_IP2INTC_Irpt */
/* xps_uart_0_IP2INTC_Irpt */
/* xps_sysace_0_SysACE_IRQ */
/* xps_timer_0_Interrupt */

/* System (Timer) Clock Frequency */
#define XILINX_CLOCK_FREQ                        125000000

/* Timer is xps_timer_0 */
#define XILINX_TIMER_BASEADDR                    0x8AEF0000
#define XILINX_TIMER_IRQ                         0

/* System memory is mpmc_0 */
#define XILINX_RAM_START                         0x20000000
#define XILINX_RAM_SIZE                          0x08000000

/* NOR Flash memory is xps_mch_emc_0 */
#define XILINX_FLASH_START                       0xae000000
#define XILINX_FLASH_SIZE                        0x02000000

/* Uart controller UART16550 0 is xps_uart_0 */
#define XILINX_UART16550                        
#define XILINX_UART16550_BASEADDR                0x89ff0000
#define XILINX_UART16550_CLOCK_HZ                125000000

/* I2C controller not defined */

/* SPI controller not defined */

/* GPIO controller is xps_gpio_0 */
#define XILINX_GPIO_BASEADDR                     0x80FF0000

/* Sysace CF controller is xps_sysace_0 */
#define XILINX_SYSACE_BASEADDR                   0x83600000
#define XILINX_SYSACE_MEM_WIDTH                  16

/* Ethernet MAC controller S2IMAC is xps_ether_0 (prh0) */
#define S2IMAC                                  
#define S2IMAC_BASEADDR                          0x88F00000

