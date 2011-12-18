ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = \
	gcc_extract_insn_test

AM_CPPFLAGS = \
	-I$(top_srcdir)/include \
	-I$(top_builddir)/include
#	$(some_CFLAGS)

EXTRA_DIST = \
	autogen.sh

MAINTAINERCLEANFILES = \
	aclocal.m4 \
	config.guess \
	config.h.in \
	config.sub \
	configure \
	depcomp \
	install-sh \
	ltmain.sh \
	m4/libtool.m4 \
	m4/lt~obsolete.m4 \
	m4/ltoptions.m4 \
	m4/ltsugar.m4 \
	m4/ltversion.m4 \
	missing \
	Makefile.in

#
# binary
#
gcc_extract_insn_test_SOURCES = \
	gcc_extract_insn_test.c

#gcc_extract_insn_test_LDADD = \
#	$(some_LIBS)

