# -*-makefile-*-
#
# overlay ${PTXDIST_TOPDIR}/rules/post/install.make
#
# Copyright (C) 2005, 2006, 2007 Robert Schwebel <r.schwebel@pengutronix.de>
#               2008, 2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#               2013 Stephan Linz <linz@li-pro.net>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# install_copy_toolchain_lib
#
# $1: xpkg label
# $2: source
# $3: destination
# $4: strip (y|n)	default is to strip
#
install_copy_toolchain_lib =								\
	XPKG=$(subst _,-,$(strip $(1)));						\
	LIB="$(strip $2)";								\
	DST="$(strip $3)";								\
	STRIP="$(strip $4)";								\
	test "$${DST}" != "" && DST="-d $${DST}";					\
	$(call install_check, install_copy_toolchain_lib);				\
	${CROSS_ENV_CC} $(CROSS_ENV_CFLAGS) $(CROSS_ENV_STRIP) PKGDIR="$(PKGDIR)"	\
		$(PTXDIST_WORKSPACE)/scripts/install_copy_toolchain.sh			\
			-p "$${XPKG}" -l "$${LIB}" $${DST} -s "$${STRIP}"

#
# install_copy_toolchain_dl
#
# $1: xpkg label
# $2: strip (y|n)	default is to strip
#
install_copy_toolchain_dl =								\
	XPKG=$(subst _,-,$(strip $(1)));						\
	STRIP="$(strip $2)";								\
	$(call install_check, install_copy_toolchain_dl);				\
	${CROSS_ENV_CC} $(CROSS_ENV_CFLAGS) $(CROSS_ENV_STRIP) PKGDIR="$(PKGDIR)"	\
		$(PTXDIST_WORKSPACE)/scripts/install_copy_toolchain.sh			\
			-p "$${XPKG}" -l LINKER -s "$${STRIP}"

#
# install_copy_toolchain_usr
#
# $1: xpkg label
# $2: source
# $3: destination
# $4: strip (y|n)	default is to strip
#
install_copy_toolchain_usr =								\
	XPKG=$(subst _,-,$(strip $(1)));						\
	LIB="$(strip $2)";								\
	DST="$(strip $3)";								\
	STRIP="$(strip $4)";								\
	test "$${DST}" != "" && DST="-d $${DST}";					\
	$(call install_check, install_copy_toolchain_other);				\
	${CROSS_ENV_CC} $(CROSS_ENV_CFLAGS) $(CROSS_ENV_STRIP) PKGDIR="$(PKGDIR)"	\
		$(PTXDIST_WORKSPACE)/scripts/install_copy_toolchain.sh			\
			-p "$${XPKG}" -u "$${LIB}" $${DST} -s "$${STRIP}"
