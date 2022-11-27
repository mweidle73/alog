# Makefile snippet intended for inclusion by ../Makefile.

# There are two variants of the architecture diagram.
# * alog-arch.svg is generated from alog-arch.graphml, assuming a
#   non-free graphml editor and/or converter.
# * alog-arch-dfsg.svg can be modified with free tools like inkscape.
DIAGRAM := alog-arch.svg

build-doc:
	rm -fr doc/html
	mkdir doc/html

	scour -i doc/arch/$(DIAGRAM) \
	  -o doc/html/alog-arch.svg \
	  --enable-comment-stripping \
	  --enable-id-stripping \
	  --enable-viewboxing \
	  --indent=none \
	  --shorten-ids

	asciidoctor doc/index -o doc/html/index.html

clean: clean-doc
clean-doc:
	rm -fr doc/html
