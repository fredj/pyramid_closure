CLOSURE_TOOLS_FILES := depswriter.py source.py treescan.py
CLOSURE_UTIL_PATH := openlayers/node_modules/closure-util
CLOSURE_LIBRARY_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getLibraryPath())')
CLOSURE_COMPILER_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getCompilerPath())')

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Main targets:"
	@echo
	@echo "- install            Install the project locally"
	@echo "- clean              Remove generated files"
	@echo "- cleanall           Remove all the build artefacts"
	@echo "- serve              Run the development server (pserve)"
	@echo "- closure-tools      Update the closure build tools"
	@echo

.PHONY: clean
clean:
	rm -f .artefacts/node_modules.timestamp
	rm -f development.ini

.PHONY: cleanall
cleanall: clean
	rm -rf .artefacts
	rm -rf node_modules

.PHONY: closure-tools
closure-tools: .artefacts/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_TOOLS_FILES))

.PHONY: install
install: .artefacts/node_modules.timestamp

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
