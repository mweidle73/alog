DESTDIR   ?= html
STYLEPATH ?= .

ASCIIDOC_OPTS = \
	--backend=xhtml11 \
	-a stylesdir=$(STYLEPATH) \
	-a linkcss \
	-a disable-javascript \
	-a badges \
	-o -

SRC_DOCS = \
	index \
	CHANGELOG \
	README

DST_FILES = $(addsuffix .html,$(addprefix $(DESTDIR)/,$(SRC_DOCS)))

all: $(DESTDIR)/asciidoc.css $(DESTDIR)/alog-arch.png $(DST_FILES)

README: ../README
	cp $< $@

CHANGELOG: ../CHANGELOG
	cp $< $@

$(DESTDIR)/alog-arch.png: arch/alog-arch.png
	cp $< $@

$(DESTDIR)/asciidoc.css: asciidoc.css
	cp $< $@

$(DESTDIR)/%.html: README CHANGELOG
	asciidoc $(ASCIIDOC_OPTS) $* > $@

clean:
	rm -f CHANGELOG README
	rm -f $(DESTDIR)/*.html
	rm -f $(DESTDIR)/*.css
	rm -f $(DESTDIR)/alog-arch.png
