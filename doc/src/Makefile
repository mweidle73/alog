DESTDIR ?= ..
STYLE   ?= alog.css

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

all: $(DESTDIR)/alog.css $(DESTDIR)/alog-arch.png $(DST_FILES)

README: ../../README
	cp $< $@

CHANGELOG: ../../CHANGELOG
	cp $< $@

$(DESTDIR)/alog-arch.png: arch/alog-arch.png
	cp $< $@

$(DESTDIR)/alog.css: alog.css
	cp $< $@

$(DESTDIR)/%.html: README CHANGELOG
	asciidoc $(ASCIIDOC_OPTS) $* > $@

clean:
	rm -f CHANGELOG README
	rm -f $(DESTDIR)/*.html
	rm -f $(DESTDIR)/alog.css
	rm -f $(DESTDIR)/alog-arch.png
