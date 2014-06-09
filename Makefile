CLOSURE_FILES := depswriter.py source.py treescan.py

.PHONY: update-closure-files
update-closure-files: .artefacts/closure-library fetch-closure-library $(addprefix pyramid_closure/closure/, $(CLOSURE_FILES))

.artefacts/closure-library:
	git clone git@github.com:google/closure-library.git .artefacts/closure-library

.PHONY: fetch-closure-library
fetch-closure-library:
	(cd .artefacts/closure-library; git fetch origin; git merge --ff-only origin/master)

pyramid_closure/closure/%.py: .artefacts/closure-library/closure/bin/build/%.py
	cp $< $@
	
