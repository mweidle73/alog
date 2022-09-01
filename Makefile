#
#  Copyright (c) 2008-2014,
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

# DESTDIR and PREFIX have their usual meanings.
PREFIX ?= $(HOME)/libraries

MAJOR = 0
MINOR = 6
REVISION = 1
VERSION = $(MAJOR).$(MINOR).$(REVISION)
# Set VERSION to '' for a static library.
ALOG = libalog-$(VERSION)
TARBALL = $(ALOG).tar.bz2

OBJECTDIR = obj
LIBDIR = lib
COVDIR = cov

NUM_CPUS ?= 1

# GNAT_BUILDER_FLAGS, ADAFLAGS, CFLAGS and GNATFLAGS may be overridden in the
# environment or on the command line.
CFLAGS             ?= -W -Wall -Werror -O3
GNAT_BUILDER_FLAGS ?= -R -j$(NUM_CPUS)
GNATFLAGS          ?= ${GNAT_BUILDER_FLAGS}
# GMAKE_OPTS should not be overridden because -p is essential.
GMAKE_OPTS = -g -p ${GNATFLAGS} \
  $(foreach v,ADAFLAGS CFLAGS CPPFLAGS LDFLAGS,"-X$(v)=$($(v))")

# Parameters passed to gprinstall. Can be overriden in the environment or on
# the command line.
GPRINSTALLFLAGS ?= \
  --prefix=$(DESTDIR)$(PREFIX) \
  --no-manifest \
  --exec-subdir=tests \
  --ali-subdir=lib/alog \
  --lib-subdir=lib \
  --project-subdir=lib/gnat \
  --sources-subdir=include/alog

all: build_lib

tests: build_tests
	@$(OBJECTDIR)/test_runner

build_lib:
	@gprbuild $(GMAKE_OPTS) -Palog -XALOG_VERSION="$(VERSION)"

build_tests:
	@gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="tests" -XALOG_VERSION=

build_all: build_lib build_tests

clean:
	@rm -f $(TARBALL)
	@rm -rf $(OBJECTDIR)
	@rm -rf $(LIBDIR)
	@rm -rf $(COVDIR)

dist:
	@echo "Creating release tarball $(TARBALL) ... "
	@git archive --format=tar HEAD --prefix $(ALOG)/ | bzip2 > $(TARBALL)

install: build_lib
	gprinstall -Palog -XALOG_VERSION=$(VERSION) -f -p $(GPRINSTALLFLAGS)

install_tests: build_tests
	gprinstall -Palog_tests -XALOG_BUILD=tests -ALOG_VERSION=
	@cp -vr data $(DESTDIR)$(PREFIX)/tests

cov:
	@mkdir -p $(COVDIR)
	@rm -f $(OBJECTDIR)/cov/*.gcda
	@gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="coverage" -XALOG_VERSION=
	@$(OBJECTDIR)/cov/test_runner || true
	@lcov -c -d $(OBJECTDIR)/cov/ -o $(OBJECTDIR)/cov/alog_tmp.info
	@lcov -e $(OBJECTDIR)/cov/alog_tmp.info "$(CURDIR)/src/*.adb" \
		-o $(OBJECTDIR)/cov/alog.info
	@genhtml --no-branch-coverage $(OBJECTDIR)/cov/alog.info -o $(COVDIR)

prof:
	@rm -f $(OBJECTDIR)/callgrind.*
	gprbuild $(GMAKE_OPTS) -Palog_tests -XALOG_BUILD="profiling" -XALOG_VERSION=
	valgrind -q --tool=callgrind \
		--callgrind-out-file=$(OBJECTDIR)/callgrind.out.%p $(OBJECTDIR)/profiler
	callgrind_annotate $(OBJECTDIR)/callgrind.* > $(OBJECTDIR)/profile.txt

.PHONY: cov

include doc/doc.mk
