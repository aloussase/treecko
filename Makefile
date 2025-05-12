build:
	@echo "Building..."
	@elm make src/Main.elm
	@awk '/<\/style>/ {print "  <link href=\"styles.css\" rel=\"stylesheet\"/>"} !/<\/style>/ {print $0}' index.html > tmp.html
	@mv -f tmp.html index.html

.phony: build
