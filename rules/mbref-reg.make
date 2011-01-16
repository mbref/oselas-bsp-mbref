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
PACKAGES-$(PTXCONF_MBREF_REG) += mbref-reg

#
# Paths and names and versions
#
MBREF_REG_VERSION	:= trunk
MBREF_REG		:= mbref-reg-$(MBREF_REG_VERSION)
MBREF_REG_SRCDIR	:= $(PTXDIST_WORKSPACE)/local_src/$(MBREF_REG)
MBREF_REG_DIR		:= $(BUILDDIR)/$(MBREF_REG)
MBREF_REG_LICENSE	:= GPL

ifdef PTXCONF_MBREF_REG
$(STATEDIR)/kernel.targetinstall.post: $(STATEDIR)/mbref-reg.targetinstall
endif

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-reg.extract:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-reg.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-reg.compile:
	@$(call targetinfo)
#	# The kernel cannot build an out-of-tree driver out-of-tree :-)
#	# So we make a local copy.
	rm -fr $(MBREF_REG_DIR)
	cp -a $(MBREF_REG_SRCDIR) $(MBREF_REG_DIR)
	$(KERNEL_PATH) $(KERNEL_ENV) $(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(MBREF_REG_DIR) \
		modules
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-reg.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mbref-reg.targetinstall:
	@$(call targetinfo)
	$(KERNEL_PATH) $(KERNEL_ENV) $(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(MBREF_REG_DIR) \
		modules_install
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/mbref-reg.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, MBREF_REG)

# vim: syntax=make
