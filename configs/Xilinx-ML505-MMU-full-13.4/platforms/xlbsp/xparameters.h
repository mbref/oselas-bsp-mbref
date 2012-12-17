/*
 * (C) Copyright 2007-2009 Michal Simek
 * Michal SIMEK <monstr@monstr.eu>
 *
 * (C) Copyright 2010-2012 Li-Pro.Net
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
 * Version:  Xilinx EDK 13.4 EDK_O.87xd
 * Today is: Sunday, the 16 of December, 2012; 19:57:06
 *
 * Description: U-Boot Configurations
 *
 * Generate by uboot-v4.02.a
 * Project description at http://www.monstr.eu/
 */

/* Project name */
#define XILINX_BOARD_NAME	"Xilinx-ML505-MMU-full-13.4"

/* Microblaze is microblaze_0 */
#define XILINX_USE_MSR_INSTR                     1
#define XILINX_PVR                               2
#define XILINX_FSL_NUMBER                        0
#define XILINX_USE_ICACHE                        1
#define XILINX_USE_DCACHE                        1
#define XILINX_DCACHE_BYTE_SIZE                  16384

/* Interrupt controller is xps_intc_0 */
#define XILINX_INTC_BASEADDR                     0x8AFF0000
#define XILINX_INTC_NUM_INTR_INPUTS              11
/* mbref_mio_0_IP2INTC_Irpt */
/* mbref_reg_0_IP2INTC_Irpt */
/* xps_iic_0_IIC2INTC_Irpt */
/* xps_uart_1_IP2INTC_Irpt */
/* xps_uart_0_IP2INTC_Irpt */
/* fpga_0_xps_ether_0_PHY_MII_INT_pin */
/* xps_ether_0_TemacIntc0_Irpt */
/* xps_sysace_0_SysACE_IRQ */
/* mpmc_0_SDMA2_Rx_IntOut */
/* mpmc_0_SDMA2_Tx_IntOut */
/* xps_timer_0_Interrupt */

/* System (Timer) Clock Frequency */
#define XILINX_CLOCK_FREQ                        100000000

/* Timer is xps_timer_0 */
#define XILINX_TIMER_BASEADDR                    0x8AEF0000
#define XILINX_TIMER_IRQ                         0

/* System memory is mpmc_0 */
#define XILINX_RAM_START                         0x20000000
#define XILINX_RAM_SIZE                          0x10000000

/* NOR Flash memory is xps_mch_emc_0 */
#define XILINX_FLASH_START                       0xae000000
#define XILINX_FLASH_SIZE                        0x02000000

/* Uart controller UART16550 0 is xps_uart_0 */
#define XILINX_UART16550                        
#define XILINX_UART16550_BASEADDR                0x89ff0000
#define XILINX_UART16550_CLOCK_HZ                100000000

/* Uart controller UART16550 1 is xps_uart_1 */
#define XILINX_UART16550_BASEADDR1               0x89fe0000

/* I2C controller is xps_iic_0 */
#define XILINX_IIC_0_FREQ                        100000
#define XILINX_IIC_0_BIT                         0
#define XILINX_IIC_0_BASEADDR                    0x80EF0000

/* SPI controller not defined */

/* GPIO controller is xps_gpio_3 */
#define XILINX_GPIO_BASEADDR                     0x80FC0000

/* Sysace CF controller is xps_sysace_0 */
#define XILINX_SYSACE_BASEADDR                   0x83600000
#define XILINX_SYSACE_MEM_WIDTH                  16

/* Ethernet MAC controller LLTEMAC is xps_ether_0 */
#define XILINX_LLTEMAC                          
#define XILINX_LLTEMAC_BASEADDR                  0x88F00000
#define XILINX_LLTEMAC_SDMA_CTRL_BASEADDR        0x8adf0100

