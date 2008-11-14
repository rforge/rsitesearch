all: clean build/rsitesearch.xpi

build/rsitesearch.xpi:
	Rscript --vanilla build.R
clean:
	rm -f `find . -name "*~"`
	rm -fr build/*
	rm -fr dist/*
	mkdir build/chrome/
