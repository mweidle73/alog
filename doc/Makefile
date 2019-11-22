DESTDIR ?= html

all: $(DESTDIR)/index.html

$(DESTDIR)/alog-arch.svg: arch/alog-arch.svg
	cp $< $@

README: ../README
	tail -n +9 $< > $@

$(DESTDIR)/index.html: $(DESTDIR)/fonts
$(DESTDIR)/index.html: $(DESTDIR)/alog-arch.svg
$(DESTDIR)/index.html: index README css/styles.css | $(DESTDIR)
	asciidoctor $< -o $@

$(DESTDIR)/fonts: fonts | $(DESTDIR)
	cp -R $< $@

$(DESTDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR) README
