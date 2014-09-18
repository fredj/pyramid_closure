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

.PHONY: buildjs
buildjs: pyramid_closure/static/build/build.js

.PHONY: clean
clean:
	rm -f .build/node_modules.timestamp
	rm -f development.ini

.PHONY: cleanall
cleanall: clean
	rm -rf .build
	rm -rf node_modules

.PHONY: closure-tools
closure-tools: .build/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_TOOLS_FILES))

.PHONY: install
install: install-dev-egg .build/node_modules.timestamp

.PHONY: install-dev-egg
install-dev-egg: .build/venv
	.build/venv/bin/python setup.py develop

.PHONY: serve
serve: install development.ini
	.build/venv/bin/pserve --reload development.ini

pyramid_closure/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

pyramid_closure/static/build/build.js: build.json .build/externs/angular-1.3.js
	node tasks/build.js $< $@

.build/externs/angular-1.3.js:
	mkdir -p $(dir $@)
	wget -O $@ https://raw.githubusercontent.com/google/closure-compiler/master/contrib/externs/angular-1.3.js
	touch $@

.build/node_modules.timestamp:
	mkdir -p $(dir $@)
	npm install
	touch $@

.build/venv:
	mkdir -p $(dir $@)
	virtualenv --no-site-packages .build/venv

development.ini: development.ini.in
	sed 's|{{CLOSURE_LIBRARY_PATH}}|$(CLOSURE_LIBRARY_PATH)|' $< > $@
