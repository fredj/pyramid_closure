CLOSURE_TOOLS_FILES := depswriter.py source.py treescan.py
CLOSURE_UTIL_PATH := openlayers/node_modules/closure-util
CLOSURE_LIBRARY_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getLibraryPath())')
CLOSURE_COMPILER_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getCompilerPath())')
OL_JS_FILES = $(shell find node_modules/openlayers/src/ol -type f -name '*.js')
NGEO_JS_FILES = $(shell find node_modules/ngeo/src -type f -name '*.js')
APP_JS_FILES = $(shell find pyramid_closure/static/js -type f -name '*.js')

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Main targets:"
	@echo
	@echo "- build              Build the client-side  code"
	@echo "- install            Install the project locally"
	@echo "- clean              Remove generated files"
	@echo "- cleanall           Remove all the build artefacts"
	@echo "- serve              Run the development server (pserve)"
	@echo "- closure-tools      Update the closure build tools"
	@echo

.PHONY: build
build: pyramid_closure/static/build/build.js pyramid_closure/static/build/build.css

.PHONY: clean
clean:
	rm -f .build/node_modules.timestamp
	rm -f development.ini
	rm -f production.ini
	rm -rf pyramid_closure/static/build

.PHONY: cleanall
cleanall: clean
	rm -rf .build
	rm -rf node_modules

.PHONY: closure-tools
closure-tools: .build/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_TOOLS_FILES))

.PHONY: install
install: install-dev-egg .build/node_modules.timestamp

.PHONY: install-dev-egg
install-dev-egg: .build/venv/lib/python2.7/site-packages/pyramid-closure.egg-link

.PHONY: serve
serve: install build development.ini
	.build/venv/bin/pserve --reload development.ini

pyramid_closure/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

pyramid_closure/static/build/build.js: build.json .build/externs/angular-1.3.js $(OL_JS_FILES) $(NGEO_JS_FILES) $(APP_JS_FILES)
	mkdir -p $(dir $@)
	node tasks/build.js $< $@

pyramid_closure/static/build/build.css: node_modules/openlayers/css/ol.css .build/node_modules.timestamp
	mkdir -p $(dir $@)
	./node_modules/.bin/cleancss $< > $@

.build/externs/angular-1.3.js:
	mkdir -p $(dir $@)
	wget -O $@ https://raw.githubusercontent.com/google/closure-compiler/master/contrib/externs/angular-1.3.js
	touch $@

.build/node_modules.timestamp: package.json
	mkdir -p $(dir $@)
	npm install
	touch $@

.build/venv:
	mkdir -p $(dir $@)
	virtualenv --no-site-packages $@

.build/venv/lib/python2.7/site-packages/pyramid-closure.egg-link: .build/venv setup.py
	.build/venv/bin/python setup.py develop

development.ini: development.ini.in
	sed 's|__CLOSURE_LIBRARY_PATH__|$(CLOSURE_LIBRARY_PATH)|' $< > $@

production.ini: production.ini.in
	sed 's|__CLOSURE_LIBRARY_PATH__|$(CLOSURE_LIBRARY_PATH)|' $< > $@
