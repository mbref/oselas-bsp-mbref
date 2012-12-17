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
 * Today is: Sunday, the 16 of December, 2012; 23:57:00
 *
 * Description: U-Boot Configurations
 *
 * Generate by uboot-v4.02.a
 * Project description at http://www.monstr.eu/
 */

/* Project name */
#define XILINX_BOARD_NAME	"Xilinx-ML605-AXI-full-13.4"

/* Microblaze is microblaze_0 */
#define XILINX_USE_MSR_INSTR                     1
#define XILINX_PVR                               2
#define XILINX_FSL_NUMBER                        0
#define XILINX_USE_ICACHE                        1
#define XILINX_USE_DCACHE                        1
#define XILINX_DCACHE_BYTE_SIZE                  16384

/* Interrupt controller is axi_intc_0 */
#define XILINX_INTC_BASEADDR                     0x8aff0000
#define XILINX_INTC_NUM_INTR_INPUTS              8
/* axi_iic_0_IIC2INTC_Irpt */
/* axi_uart_0_IP2INTC_Irpt */
/* axi_ether_0_INTERRUPT */
/* fpga_0_axi_sysace_0_SysACE_MPIRQ_pin */
/* axi_sysace_0_SysACE_IRQ */
/* axi_ether_0_dma_mm2s_introut */
/* axi_ether_0_dma_s2mm_introut */
/* axi_timer_0_Interrupt */

/* System (Timer) Clock Frequency */
#define XILINX_CLOCK_FREQ                        50000000

/* Timer is axi_timer_0 */
#define XILINX_TIMER_BASEADDR                    0x8aef0000
#define XILINX_TIMER_IRQ                         0

/* System memory is axi_v6_ddrx_0 */
#define XILINX_RAM_START                         0x20000000
#define XILINX_RAM_SIZE                          0x10000000

/* NOR Flash memory is axi_emc_0 */
#define XILINX_FLASH_START                       0xae000000
#define XILINX_FLASH_SIZE                        0x02000000

/* Uart controller UART16550 0 is axi_uart_0 */
#define XILINX_UART16550                        
#define XILINX_UART16550_BASEADDR                0x89ff0000
#define XILINX_UART16550_CLOCK_HZ                50000000

/* I2C controller is axi_iic_0 */
#define XILINX_IIC_0_BASEADDR                    0x80ef0000
#define XILINX_IIC_0_FREQ                        100000
#define XILINX_IIC_0_BIT                         0

/* SPI controller not defined */

/* GPIO controller is axi_gpio_3 */
#define XILINX_GPIO_BASEADDR                     0x80fc0000

/* Sysace CF controller is axi_sysace_0 */
#define XILINX_SYSACE_BASEADDR                   0x83600000
#define XILINX_SYSACE_MEM_WIDTH                  8

/* Ethernet MAC controller AXIEMAC is axi_ether_0 */
#define XILINX_AXIEMAC                          
#define XILINX_AXIEMAC_BASEADDR                  0x88f00000
#define XILINX_AXIDMA_BASEADDR                   0x8adf0000

