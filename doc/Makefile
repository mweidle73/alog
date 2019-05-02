DESTDIR ?= html

ASCIIDOC_OPTS = \
	-a icons=font \
	-a iconfont-remote! \
	-a stylesdir=css \
	-a stylesheet=styles.css \
	-a sectanchors \
	-o -

all: $(DESTDIR)/index.html

$(DESTDIR)/alog-arch.svg: arch/alog-arch.svg
	cp $< $@

README: ../README
	tail -n +9 $< > $@

$(DESTDIR)/index.html: $(DESTDIR)/fonts $(DESTDIR)/css/font-awesome.css
$(DESTDIR)/index.html: $(DESTDIR)/alog-arch.svg
$(DESTDIR)/index.html: index README css/styles.css
	TZ=UTC asciidoctor $(ASCIIDOC_OPTS) $< > $@

$(DESTDIR)/css/font-awesome.css: css/font-awesome.css
	mkdir -p $(DESTDIR)/css
	cp $< $@

$(DESTDIR)/fonts: fonts
	mkdir -p $(DESTDIR)
	cp -R $< $@

clean:
	rm -rf $(DESTDIR) README
