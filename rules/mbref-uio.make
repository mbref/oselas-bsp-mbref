# -*-makefile-*-
#
# Copyright (C) 2011 by Stephan Linz
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_MBREF_UIO) += mbref-uio

#
# Paths and names and versions
#
MBREF_UIO_VERSION	:= trunk
MBREF_UIO		:= mbref-uio-$(MBREF_UIO_VERSION)
MBREF_UIO_SRCDIR	:= $(PTXDIST_WORKSPACE)/local_src/$(MBREF_UIO)
MBREF_UIO_DIR		:= $(BUILDDIR)/$(MBREF_UIO)
MBREF_UIO_LICENSE	:= GPL

ifdef PTXCONF_MBREF_UIO
$(STATEDIR)/kernel.targetinstall.post: $(STATEDIR)/mbref-uio.targetinstall
endif

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-uio.extract:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-uio.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-uio.compile:
	@$(call targetinfo)
#	# The kernel cannot build an out-of-tree driver out-of-tree :-)
#	# So we make a local copy.
	rm -fr $(MBREF_UIO_DIR)
	cp -a $(MBREF_UIO_SRCDIR) $(MBREF_UIO_DIR)
	$(KERNEL_PATH) $(KERNEL_ENV) $(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(MBREF_UIO_DIR) \
		modules
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-uio.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-uio.targetinstall:
	@$(call targetinfo)
	$(KERNEL_PATH) $(KERNEL_ENV) $(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(MBREF_UIO_DIR) \
		modules_install
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/mbref-uio.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, MBREF_UIO)

# vim: syntax=make
