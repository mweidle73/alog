#
#  Copyright (c) 2008-2012,
#  Reto Buerki, Adrian-Ken Rueegsegger
#
#  This file is part of Alog.
#
#  Alog is free software; you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published
#  by the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
#  Alog is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with Alog; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
#  MA  02110-1301  USA
#

PREFIX ?= $(HOME)/libraries
INSTALL = install

MAJOR = 0
MINOR = 4
REVISION = 1
VERSION = $(MAJOR).$(MINOR).$(REVISION)
ALOG = libalog-$(VERSION)
SO_LIBRARY = libalog.so.$(VERSION)
A_LIBRARY = libalog.a
LIBRARY_KIND = dynamic

SOURCEDIR = src
OBJECTDIR = obj
LIBDIR = lib
COVDIR = cov
PROFDIR = prof
ALI_FILES = lib/$(LIBRARY_KIND)/*.ali
GPR_FILE = gnat/alog.gpr

TMPDIR = /tmp
DISTDIR = $(TMPDIR)/$(ALOG)
TARBALL = $(ALOG).tar.bz2
PWD = `pwd`

NUM_CPUS ?= 1

GMAKE_OPTS = -p -R -j$(NUM_CPUS)

CFLAGS ?= -W -Wall -Werror -O3

all: build_lib

tests: build_tests
	@$(OBJECTDIR)/test_runner

build_lib: prepare
	@gprbuild $(GMAKE_OPTS) -Palog -XALOG_VERSION="$(VERSION)" \
		-XLIBRARY_KIND="$(LIBRARY_KIND)" -XCFLAGS="$(CFLAGS)" \
		-XLDFLAGS="$(LDFLAGS)"

build_tests: prepare
	@gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="tests"

build_all: build_lib build_tests

prepare: $(SOURCEDIR)/alog-version.ads
	@mkdir -p $(COVDIR) $(PROFDIR)

$(SOURCEDIR)/alog-version.ads:
	@echo "package Alog.Version is"                 > $@
	@echo "   Version_Number : constant String :=" >> $@
	@echo "      \"$(VERSION)\";"                  >> $@
	@echo "end Alog.Version;"                      >> $@

clean:
	@rm -f alog.specs
	@rm -rf $(OBJECTDIR)/*
	@rm -rf $(LIBDIR)/*
	@rm -rf $(COVDIR)/*
	@rm -rf $(PROFDIR)/*
	$(MAKE) -C doc clean

distclean: clean
	@rm -rf obj
	@rm -rf lib
	@rm -rf cov
	@rm -rf prof
	@rm -f $(SOURCEDIR)/alog-version.ads

dist: distclean $(SOURCEDIR)/alog-version.ads
	@echo -n "Creating release tarball '$(ALOG)' ... "
	@mkdir -p $(DISTDIR)
	@cp -R * $(DISTDIR)
	@tar -C $(TMPDIR) -cjf $(TARBALL) $(ALOG)
	@rm -rf $(DISTDIR)
	@echo "DONE"

install: install_lib install_$(LIBRARY_KIND)

install_lib: build_lib
	@mkdir -p $(PREFIX)/include/alog
	@mkdir -p $(PREFIX)/lib/alog
	@mkdir -p $(PREFIX)/lib/gnat
	$(INSTALL) -m 644 $(SOURCEDIR)/* $(PREFIX)/include/alog
	$(INSTALL) -m 444 $(ALI_FILES) $(PREFIX)/lib/alog
	$(INSTALL) -m 644 $(GPR_FILE) $(PREFIX)/lib/gnat

install_static:
	$(INSTALL) -m 444 $(LIBDIR)/$(LIBRARY_KIND)/$(A_LIBRARY) $(PREFIX)/lib

install_dynamic:
	$(INSTALL) -m 444 $(LIBDIR)/$(LIBRARY_KIND)/$(SO_LIBRARY) $(PREFIX)/lib
	@cd $(PREFIX)/lib && ln -sf $(SO_LIBRARY) libalog.so

install_tests: build_tests
	$(INSTALL) -v -d $(PREFIX)/tests
	$(INSTALL) -m 755 $(OBJECTDIR)/test_runner $(PREFIX)/tests/
	@cp -vr data $(PREFIX)/tests

cov: prepare
	@rm -f $(OBJECTDIR)/cov/*.gcda
	@gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="coverage"
	@$(OBJECTDIR)/cov/test_runner || true
	@lcov -c -d $(OBJECTDIR)/cov/ -o $(OBJECTDIR)/cov/alog_tmp.info
	@lcov -e $(OBJECTDIR)/cov/alog_tmp.info "$(PWD)/src/*.adb" \
		-o $(OBJECTDIR)/cov/alog.info
	@genhtml --no-branch-coverage $(OBJECTDIR)/cov/alog.info -o $(COVDIR)

prof: prepare
	@rm -f $(OBJECTDIR)/callgrind.*
	@gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="profiling"
	@cd $(OBJECTDIR) && valgrind -q --tool=callgrind ./profiler
	@cp $(OBJECTDIR)/callgrind.* $(PROFDIR)
	@callgrind_annotate $(PROFDIR)/callgrind.* > $(PROFDIR)/profiler.txt

doc:
	$(MAKE) -C doc

.PHONY: cov dist doc prof tests build_all install_tests
