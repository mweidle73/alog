# Makefile snippet intended for inclusion by ../Makefile.

build-doc:
	rm -fr doc/html
	mkdir doc/html

	scour -i doc/arch/alog-arch.svg \
	  -o doc/html/alog-arch.svg \
	  --enable-comment-stripping \
	  --enable-id-stripping \
	  --enable-viewboxing \
	  --indent=none \
	  --shorten-ids

	cp -a --reflink=auto doc/fonts doc/html

	asciidoctor doc/index -o doc/html/index.html

clean: clean-doc
clean-doc:
	rm -fr doc/html
