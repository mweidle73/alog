DESTDIR ?= ..
STYLE   ?= alog.css

PREPARE := $(shell cp ../../README ../../CHANGELOG $(PWD))

ASCIIDOC_OPTS = \
	--backend=xhtml11 \
	-a stylesheet=$(STYLE) \
	-a max-width=1024px \
	-a linkcss \
	-a disable-javascript \
	-a badges \
	-a icons \
	-o -

SRC_DOCS = \
	index \
	CHANGELOG \
	README

DST_FILES  = $(addsuffix .html,$(addprefix $(DESTDIR)/,$(SRC_DOCS)))

all: $(DESTDIR)/alog.css $(DST_FILES) $(DESTDIR)/alog-arch.png

$(DESTDIR)/alog-arch.png: arch/alog-arch.png
	cp $< $@

$(DESTDIR)/alog.css: alog.css
	cp $< $@

$(DESTDIR)/%.html:
	asciidoc $(ASCIIDOC_OPTS) $* > $@

clean:
	rm -f CHANGELOG README
	rm -f $(DESTDIR)/*.html
	rm -f $(DESTDIR)/alog.css
	rm -f $(DESTDIR)/alog-arch.png

PHONY: $(DESTDIR)/%.html
