# -*-makefile-*-
#
# Copyright (C) 2010 by Stephan Linz <linz@li-pro.net>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DEVNODES) += devnodes

#
# Paths and names
#
DEVNODES_VERSION	:= 20100912

# ----------------------------------------------------------------------------
# Collect
# ----------------------------------------------------------------------------

DEVNODES_PUBLIC=	-group=0	-mode=0666
DEVNODES_PRIVATE=	-group=0	-mode=0600
DEVNODES_SYSTEM=	-group=0	-mode=0660
DEVNODES_KMEM=		-group=3	-mode=0640
DEVNODES_TTY=		-group=4	-mode=0666
DEVNODES_CONS=		-group=4	-mode=0600
DEVNODES_DIALOUT=	-group=16	-mode=0660
DEVNODES_DIP=		-group=17	-mode=0660
DEVNODES_MOUSE=		-group=0	-mode=0660
DEVNODES_PRINTER=	-group=9	-mode=0660
DEVNODES_FLOPPY=	-group=7	-mode=0660
DEVNODES_DISK=		-group=8	-mode=0660
DEVNODES_SCSI=		-group=0	-mode=0600
DEVNODES_CDROM=		-group=15	-mode=0660
DEVNODES_TAPE=		-group=18	-mode=0660
DEVNODES_AUDIO=		-group=11	-mode=0660
DEVNODES_VIDEO=		-group=12	-mode=0660
DEVNODES_IBCS2=		-group=0	-mode=0666
DEVNODES_SCANNER=	-group=0	-mode=0666
DEVNODES_CODA=		-group=0	-mode=0600
DEVNODES_IPSEC=		-group=0	-mode=0200
DEVNODES_READABLE=	-group=0	-mode=0444
DEVNODES_CRYPTO=	-group=19	-mode=0666
DEVNODES_PTY=		-group=4	-mode=0620
DEVNODES_TUN=		-group=0	-mode=0700


ifneq ($(PTXCONF_DEVNODES),)
DEVNODES_DEVICES	+= \
	$(DEVNODES_KMEM)	c,1,1,/dev/mem		c,1,2,/dev/kmem		\
	$(DEVNODES_TTY)		c,4,0,/dev/tty0		c,4,1,/dev/tty1		\
				c,4,2,/dev/tty2		c,4,3,/dev/tty3		\
	$(DEVNODES_TTY)		c,5,0,/dev/tty

ifneq ($(PTXCONF_DEVNODES_POOR_ENTROPY),)
DEVNODES_DEVICES	+= \
	$(DEVNODES_READABLE)	c,1,9,/dev/urandom	c,1,9,/dev/random
else
DEVNODES_DEVICES	+= \
	$(DEVNODES_READABLE)	c,1,9,/dev/urandom	c,1,8,/dev/random
endif

endif # PTXCONF_DEVNODES

ifneq ($(PTXCONF_DEVNODES_SERIAL),)
DEVNODES_DEVICES	+= $(DEVNODES_DIALOUT)					\
	c,4,64,/dev/ttyS0	c,4,65,/dev/ttyS1	c,4,66,/dev/ttyS2	\
	c,4,67,/dev/ttyS3	c,4,68,/dev/ttyS4	c,4,69,/dev/ttyS5	\
	c,4,70,/dev/ttyS6	c,4,71,/dev/ttyS7				\
	c,5,64,/dev/cua0	c,5,65,/dev/cua1	c,5,66,/dev/cua2	\
	c,5,67,/dev/cua3	c,5,68,/dev/cua4	c,5,69,/dev/cua5	\
	c,5,70,/dev/cua6	c,5,71,/dev/cua7
endif

ifneq ($(PTXCONF_DEVNODES_SERIAL_XILINX_UARTLITE),)
DEVNODES_DEVICES	+= $(DEVNODES_DIALOUT)					\
	c,204,187,/dev/ttyUL0	c,204,188,/dev/ttyUL1	c,204,189,/dev/ttyUL2	\
	c,204,190,/dev/ttyUL3
endif

ifneq ($(PTXCONF_DEVNODES_UNIX98_PTYS),)
DEVNODES_DEVICES	+= $(DEVNODES_TTY)		c,5,2,/dev/ptmx
endif

ifneq ($(PTXCONF_DEVNODES_LEGACY_PTYS),)
DEVNODES_DEVICES_PTY_16	+= $(DEVNODES_PTY)					\
	c,2,0,/dev/ptyp0	c,2,1,/dev/ptyp1	c,2,2,/dev/ptyp2	\
	c,2,3,/dev/ptyp3	c,2,4,/dev/ptyp4	c,2,5,/dev/ptyp5	\
	c,2,6,/dev/ptyp6	c,2,7,/dev/ptyp7	c,2,8,/dev/ptyp8	\
	c,2,9,/dev/ptyp9	c,2,10,/dev/ptypa	c,2,11,/dev/ptypb	\
	c,2,12,/dev/ptypc	c,2,13,/dev/ptypd	c,2,14,/dev/ptype	\
	c,2,15,/dev/ptypf							\
	c,3,0,/dev/ttyp0	c,3,1,/dev/ttyp1	c,3,2,/dev/ttyp2	\
	c,3,3,/dev/ttyp3	c,3,4,/dev/ttyp4	c,3,5,/dev/ttyp5	\
	c,3,6,/dev/ttyp6	c,3,7,/dev/ttyp7	c,3,8,/dev/ttyp8	\
	c,3,9,/dev/ttyp9	c,3,10,/dev/ttypa	c,3,11,/dev/ttypb	\
	c,3,12,/dev/ttypc	c,3,13,/dev/ttypd	c,3,14,/dev/ttype	\
	c,3,15,/dev/ttypf

DEVNODES_DEVICES_PTY_32	+= $(DEVNODES_DEVICES_PTY_16)				\
	c,2,16,/dev/ptyq0	c,2,17,/dev/ptyq1	c,2,18,/dev/ptyq2	\
	c,2,19,/dev/ptyq3	c,2,20,/dev/ptyq4	c,2,21,/dev/ptyq5	\
	c,2,22,/dev/ptyq6	c,2,23,/dev/ptyq7	c,2,24,/dev/ptyq8	\
	c,2,25,/dev/ptyq9	c,2,26,/dev/ptyqa	c,2,27,/dev/ptyqb	\
	c,2,28,/dev/ptyqc	c,2,29,/dev/ptyqd	c,2,30,/dev/ptyqe	\
	c,2,31,/dev/ptyqf							\
	c,3,16,/dev/ttyq0	c,3,17,/dev/ttyq1	c,3,18,/dev/ttyq2	\
	c,3,19,/dev/ttyq3	c,3,20,/dev/ttyq4	c,3,21,/dev/ttyq5	\
	c,3,22,/dev/ttyq6	c,3,23,/dev/ttyq7	c,3,24,/dev/ttyq8	\
	c,3,25,/dev/ttyq9	c,3,26,/dev/ttyqa	c,3,27,/dev/ttyqb	\
	c,3,28,/dev/ttyqc	c,3,29,/dev/ttyqd	c,3,30,/dev/ttyqe	\
	c,3,31,/dev/ttyqf

DEVNODES_DEVICES_PTY_64	+= $(DEVNODES_DEVICES_PTY_32)				\
	c,2,32,/dev/ptyr0	c,2,33,/dev/ptyr1	c,2,34,/dev/ptyr2	\
	c,2,35,/dev/ptyr3	c,2,36,/dev/ptyr4	c,2,37,/dev/ptyr5	\
	c,2,38,/dev/ptyr6	c,2,39,/dev/ptyr7	c,2,40,/dev/ptyr8	\
	c,2,41,/dev/ptyr9	c,2,42,/dev/ptyra	c,2,43,/dev/ptyrb	\
	c,2,44,/dev/ptyrc	c,2,45,/dev/ptyrd	c,2,46,/dev/ptyre	\
	c,2,47,/dev/ptyrf							\
	c,2,48,/dev/ptys0	c,2,49,/dev/ptys1	c,2,50,/dev/ptys2	\
	c,2,51,/dev/ptys3	c,2,52,/dev/ptys4	c,2,53,/dev/ptys5	\
	c,2,54,/dev/ptys6	c,2,55,/dev/ptys7	c,2,56,/dev/ptys8	\
	c,2,57,/dev/ptys9	c,2,58,/dev/ptysa	c,2,59,/dev/ptysb	\
	c,2,60,/dev/ptysc	c,2,61,/dev/ptysd	c,2,62,/dev/ptyse	\
	c,2,63,/dev/ptysf							\
	c,3,32,/dev/ttyr0	c,3,33,/dev/ttyr1	c,3,34,/dev/ttyr2	\
	c,3,35,/dev/ttyr3	c,3,36,/dev/ttyr4	c,3,37,/dev/ttyr5	\
	c,3,38,/dev/ttyr6	c,3,39,/dev/ttyr7	c,3,40,/dev/ttyr8	\
	c,3,41,/dev/ttyr9	c,3,42,/dev/ttyra	c,3,43,/dev/ttyrb	\
	c,3,44,/dev/ttyrc	c,3,45,/dev/ttyrd	c,3,46,/dev/ttyre	\
	c,3,47,/dev/ttyrf							\
	c,3,48,/dev/ttys0	c,3,49,/dev/ttys1	c,3,50,/dev/ttys2	\
	c,3,51,/dev/ttys3	c,3,52,/dev/ttys4	c,3,53,/dev/ttys5	\
	c,3,54,/dev/ttys6	c,3,55,/dev/ttys7	c,3,56,/dev/ttys8	\
	c,3,57,/dev/ttys9	c,3,58,/dev/ttysa	c,3,59,/dev/ttysb	\
	c,3,60,/dev/ttysc	c,3,61,/dev/ttysd	c,3,62,/dev/ttyse	\
	c,3,63,/dev/ttysf

ifneq ($(PTXCONF_DEVNODES_LEGACY_PTYS_64),)
DEVNODES_DEVICES	+= $(DEVNODES_DEVICES_PTY_64)
else
ifneq ($(PTXCONF_DEVNODES_LEGACY_PTYS_32),)
DEVNODES_DEVICES	+= $(DEVNODES_DEVICES_PTY_32)
else
ifneq ($(PTXCONF_DEVNODES_LEGACY_PTYS_16),)
DEVNODES_DEVICES	+= $(DEVNODES_DEVICES_PTY_16)
else
$(error devnodes: wrong configuration)
endif
endif
endif

endif

ifneq ($(PTXCONF_DEVNODES_I2C),)
DEVNODES_DEVICES	+= $(DEVNODES_SYSTEM)					\
	c,89,0,/dev/i2c-0	c,89,1,/dev/i2c-1	c,89,2,/dev/i2c-2	\
	c,89,3,/dev/i2c-3	c,89,4,/dev/i2c-4	c,89,5,/dev/i2c-5	\
	c,89,6,/dev/i2c-6	c,89,7,/dev/i2c-7
endif

ifneq ($(PTXCONF_DEVNODES_USB_ACM),)
DEVNODES_DEVICES	+= $(DEVNODES_TTY)					\
	c,166,0,/dev/ttyACM0	c,166,1,/dev/ttyACM1	c,166,2,/dev/ttyACM2	\
	c,166,3,/dev/ttyACM3							\
	c,167,0,/dev/cuacm0	c,167,1,/dev/cuacm1	c,167,2,/dev/cuacm2	\
	c,167,3,/dev/cuacm3
endif

ifneq ($(PTXCONF_DEVNODES_USB_SERIAL),)
DEVNODES_DEVICES	+= $(DEVNODES_TTY)					\
	c,188,0,/dev/ttyUSB0	c,188,1,/dev/ttyUSB1	c,188,2,/dev/ttyUSB2	\
	c,188,3,/dev/ttyUSB3							\
	c,189,0,/dev/cuusb0	c,189,1,/dev/cuusb1	c,189,2,/dev/cuusb2	\
	c,189,3,/dev/cuusb3
endif

ifneq ($(PTXCONF_DEVNODES_USB_PRINTER),)
DEVNODES_DEVICES	+= $(DEVNODES_PRINTER)					\
	c,180,0,/dev/usblp0	c,180,1,/dev/usblp1	c,180,2,/dev/usblp2	\
	c,180,3,/dev/usblp3	c,180,4,/dev/usblp4	c,180,5,/dev/usblp5	\
	c,180,6,/dev/usblp6	c,180,7,/dev/usblp7	c,180,8,/dev/usblp8	\
	c,180,9,/dev/usblp9	c,180,10,/dev/usblp10	c,180,11,/dev/usblp11	\
	c,180,12,/dev/usblp12	c,180,13,/dev/usblp13	c,180,14,/dev/usblp14	\
	c,180,15,/dev/usblp15
endif

ifneq ($(PTXCONF_DEVNODES_MTD_CHAR),)
DEVNODES_DEVICES	+= $(DEVNODES_SYSTEM)					\
	c,90,0,/dev/mtd0	c,90,2,/dev/mtd1	c,90,4,/dev/mtd2	\
	c,90,6,/dev/mtd3	c,90,8,/dev/mtd4	c,90,10,/dev/mtd5	\
	c,90,12,/dev/mtd6	c,90,14,/dev/mtd7	c,90,16,/dev/mtd8	\
	c,90,18,/dev/mtd9							\
	c,90,1,/dev/mtdr0	c,90,3,/dev/mtdr1	c,90,5,/dev/mtdr2	\
	c,90,7,/dev/mtdr3	c,90,9,/dev/mtdr4	c,90,11,/dev/mtdr5	\
	c,90,13,/dev/mtdr6	c,90,15,/dev/mtdr7	c,90,17,/dev/mtdr8	\
	c,90,19,/dev/mtdr9
endif

ifneq ($(PTXCONF_DEVNODES_MTD_BLK),)
DEVNODES_DEVICES	+= $(DEVNODES_SYSTEM)					\
	b,31,0,/dev/mtdblock0	b,31,1,/dev/mtdblock1	b,31,2,/dev/mtdblock2	\
	b,31,3,/dev/mtdblock3	b,31,4,/dev/mtdblock4	b,31,5,/dev/mtdblock5	\
	b,31,6,/dev/mtdblock6	b,31,7,/dev/mtdblock7	b,31,8,/dev/mtdblock8	\
	b,31,9,/dev/mtdblock9
endif

ifneq ($(PTXCONF_DEVNODES_UIO),)
DEVNODES_DEVICES	+= $(DEVNODES_SYSTEM)					\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),0,/dev/uio0				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),1,/dev/uio1				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),2,/dev/uio2				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),3,/dev/uio3				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),4,/dev/uio4				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),5,/dev/uio5				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),6,/dev/uio6				\
	c,$(PTXCONF_DEVNODES_UIO_MAJOR),7,/dev/uio7
endif

ifneq ($(PTXCONF_DEVNODES_BLK_IDE),)
DEVNODES_DEVICES	+= $(DEVNODES_DISK)					\
	b,3,0,/dev/hda		b,3,1,/dev/hda1		b,3,2,/dev/hda2		\
	b,3,3,/dev/hda3		b,3,4,/dev/hda4		b,3,5,/dev/hda5		\
	b,3,64,/dev/hdb		b,3,65,/dev/hdb1	b,3,66,/dev/hdb2	\
	b,3,67,/dev/hdb3	b,3,68,/dev/hdb4	b,3,69,/dev/hdb5	\
	b,22,0,/dev/hdc		b,22,1,/dev/hdc1	b,22,2,/dev/hdc2	\
	b,22,3,/dev/hdc3	b,22,4,/dev/hdc4	b,22,5,/dev/hdc5	\
	b,22,64,/dev/hdd	b,22,65,/dev/hdd1	b,22,66,/dev/hdd2	\
	b,22,67,/dev/hdd3	b,22,68,/dev/hdd4	b,22,69,/dev/hdd5
endif

ifneq ($(PTXCONF_DEVNODES_BLK_SD),)
DEVNODES_DEVICES	+= $(DEVNODES_DISK)					\
	b,8,0,/dev/sda		b,8,1,/dev/sda1		b,8,2,/dev/sda2		\
	b,8,3,/dev/sda3		b,8,4,/dev/sda4		b,8,5,/dev/sda5		\
	b,8,16,/dev/sdb		b,8,17,/dev/sdb1	b,8,18,/dev/sdb2	\
	b,8,19,/dev/sdb3	b,8,20,/dev/sdb4	b,8,21,/dev/sdb5	\
	b,8,32,/dev/sdc		b,8,33,/dev/sdc1	b,8,34,/dev/sdc2	\
	b,8,35,/dev/sdc3	b,8,36,/dev/sdc4	b,8,37,/dev/sdc5	\
	b,8,48,/dev/sdd		b,8,49,/dev/sdd1	b,8,50,/dev/sdd2	\
	b,8,51,/dev/sdd3	b,8,52,/dev/sdd4	b,8,53,/dev/sdd5	\
	b,8,64,/dev/sde		b,8,65,/dev/sde1	b,8,66,/dev/sde2	\
	b,8,67,/dev/sde3	b,8,68,/dev/sde4	b,8,69,/dev/sde5	\
	b,8,80,/dev/sdf		b,8,81,/dev/sdf1	b,8,82,/dev/sdf2	\
	b,8,83,/dev/sdf3	b,8,84,/dev/sdf4	b,8,85,/dev/sdf5
endif

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.get:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.extract:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.install:
	@$(call targetinfo)

#
# TODO:
# If some of the files are required in root filesystem's build process, install
# these files in the install stage. But use proper variables PTXdist supports
# to install files, instead of fixed paths. The following variables can be
# used:
#
# - $(PTXDIST_SYSROOT_TARGET) points to a directory tree
#   all target relevant libraries and header files are installed to. All
#   packages built for the target are searching in this directory tree for
#   header and library files. These files are for compile time only, not for
#   runtime!
#   Paths:
#    - executables: $(PTXDIST_SYSROOT_TARGET)/bin
#    - header files: $(PTXDIST_SYSROOT_TARGET)/include
#    - libraries: $(PTXDIST_SYSROOT_TARGET)/lib
#
# - $(PTXDIST_SYSROOT_HOST) points to a directory tree all host relevant
#   executables, libraries and header files are installed to. All packages
#   built for the host are searching in this directory tree for executables,
#   header and library files.
#   Paths:
#    - executables: $(PTXDIST_SYSROOT_HOST)/bin
#    - header files: $(PTXDIST_SYSROOT_HOST)/include
#    - libraries: $(PTXDIST_SYSROOT_HOST)/lib
#
# - $(PTXDIST_SYSROOT_CROSS) points to a directory tree all cross relevant
#   executables, libraries and header files are installed to. All packages
#   built for the host to create data for the target are searching in this
#   directory tree for executables, header and library files.
#   Paths:
#    - executables: $(PTXDIST_SYSROOT_CROSS)/bin
#    - header files: $(PTXDIST_SYSROOT_CROSS)/include
#    - libraries: $(PTXDIST_SYSROOT_CROSS)/lib
#
#
# If no compile time files are reqired, skip this stage
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/devnodes.targetinstall:
	@$(call targetinfo)

	@$(call install_init, devnodes)
	@$(call install_fixup,devnodes,PACKAGE,devnodes)
	@$(call install_fixup,devnodes,PRIORITY,optional)
	@$(call install_fixup,devnodes,VERSION,0)
	@$(call install_fixup,devnodes,SECTION,base)
	@$(call install_fixup,devnodes,AUTHOR,"Stephan Linz <linz\@li-pro.net>")
	@$(call install_fixup,devnodes,DEPENDS,)
	@$(call install_fixup,devnodes,DESCRIPTION,missing)

	@$(call install_copy, devnodes, 0, 0, 0755, /dev)

ifneq ($(PTXCONF_DEVNODES_UNIX98_PTYS),)
	@$(call install_copy, devnodes, 0, 0, 0755, /dev/pts)
endif

#
# TODO: Add here all files that should be copied to the target
# Note: Add everything before(!) call to macro install_finish
#
	@for i in -reset $(DEVNODES_DEVICES); do				\
		case "$$i" in							\
		-mode=*)							\
			mode="$$(echo $$i | cut -f2 -d=)"			\
			;;							\
		-group=*)							\
			group="$$(echo $$i | cut -f2 -d=)"			\
			;;							\
		-reset)								\
			mode=0644;						\
			group=0;						\
			;;							\
		*)								\
			type="$$(echo $$i | cut -f1 -d,)"			\
			major="$$(echo $$i | cut -f2 -d,)"			\
			minor="$$(echo $$i | cut -f3 -d,)"			\
			name="$$(echo $$i | cut -f4 -d,)"			\
			$(call install_node, devnodes, 0, $$group, $$mode,	\
				$$type, $$major, $$minor, $$name)		\
			;;							\
		esac;								\
	done


#	@$(call install_copy, devnodes, 0, 0, 0755, $(DEVNODES_DIR)/foobar, /dev/null)

	@$(call install_finish,devnodes)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/devnodes.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, DEVNODES)

# vim: syntax=make
