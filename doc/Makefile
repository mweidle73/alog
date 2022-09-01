DESTDIR ?= html

all: $(DESTDIR)/index.html

$(DESTDIR)/alog-arch.svg: arch/alog-arch.svg
	scour -i $< -o $@ \
	  --enable-comment-stripping \
	  --enable-id-stripping \
	  --enable-viewboxing \
	  --indent=none \
	  --shorten-ids

$(DESTDIR)/index.html: $(DESTDIR)/fonts
$(DESTDIR)/index.html: $(DESTDIR)/alog-arch.svg
$(DESTDIR)/index.html: index ../README css/styles.css | $(DESTDIR)
	asciidoctor $< -o $@

$(DESTDIR)/fonts: fonts | $(DESTDIR)
	cp -R $< $@

$(DESTDIR):
	mkdir -p $@

clean:
	rm -rf $(DESTDIR)
