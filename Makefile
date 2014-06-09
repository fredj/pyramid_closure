CLOSURE_FILES := depswriter.py source.py treescan.py
LIBS := closure-library ol3 ngeo

.PHONY: update-closure-files
update-closure-files: .artefacts/closure-library fetch-closure-library $(addprefix pyramid_closure/closure/, $(CLOSURE_FILES))

.artefacts/closure-library:
	git clone git@github.com:google/closure-library.git .artefacts/closure-library

.PHONY: fetch-closure-library
fetch-closure-library:
	(cd .artefacts/closure-library; git fetch origin; git merge --ff-only origin/master)

pyramid_closure/closure/%.py: .artefacts/closure-library/closure/bin/build/%.py
	cp $< $@

.PHONY: get-libs
get-libs: $(addprefix pyramid_closure/static/lib/, $(LIBS))

pyramid_closure/static/lib/ol3:
	git clone git@github.com:openlayers/ol3 $@
	
pyramid_closure/static/lib/ngeo:
	git clone git@github.com:camptocamp/ngeo $@

pyramid_closure/static/lib/closure-library:
	git clone git@github.com:google/closure-library $@
