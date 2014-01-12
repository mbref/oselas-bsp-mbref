#
# (C) Copyright 2007-2009 Michal Simek
# Michal SIMEK <monstr@monstr.eu>
#
# (C) Copyright 2010-2014 Li-Pro.Net
# Stephan Linz <linz@li-pro.net>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#
# CAUTION:  This file is automatically generated by libgen.
# Version:  Xilinx EDK 13.2 EDK_O.61xd
# Today is: Samstag, the 11 of Januar, 2014; 06:05:03
#
# Description: U-Boot Configurations
#
# Generate by uboot-v4.02.a
# Project description at http://www.monstr.eu/
#

# Platform compiler flags
PLATFORM_CPPFLAGS += -mxl-pattern-compare
PLATFORM_CPPFLAGS += -mxl-barrel-shift
PLATFORM_CPPFLAGS += -mno-xl-soft-mul
PLATFORM_CPPFLAGS += -mcpu=v8.20.a

# Automatic U-Boot position at 0x27e00000
CONFIG_SYS_TEXT_BASE = 0x27e00000

# I2C controller not defined

# SPI controller not defined

# Sysace CF controller not defined

