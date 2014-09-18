CLOSURE_FILES := depswriter.py source.py treescan.py
LIBS := closure-library ol3 ngeo
CLOSURE_UTIL_PATH := openlayers/node_modules/closure-util
CLOSURE_LIBRARY_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getLibraryPath())')
CLOSURE_COMPILER_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getCompilerPath())')

.PHONY: closure-tools
closure-tools: .artefacts/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_FILES))

.PHONY: serve
serve: development.ini
	pserve --reload development.ini

pyramid_closure/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

.artefacts/node_modules.timestamp:
	mkdir -p $(dir $@)
	npm install
	touch $@

development.ini: development.ini.in
	sed 's|{{CLOSURE_LIBRARY_PATH}}|$(CLOSURE_LIBRARY_PATH)|' $< > $@
