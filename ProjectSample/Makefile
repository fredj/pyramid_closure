SITE_PACKAGES = $(shell .build/venv/bin/python -c "import distutils; print(distutils.sysconfig.get_python_lib())" 2> /dev/null)
CLOSURE_UTIL_PATH := ol/node_modules/closure-util
CLOSURE_LIBRARY_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getLibraryPath())' 2> /dev/null)
CLOSURE_COMPILER_PATH = $(shell node -e 'process.stdout.write(require("$(CLOSURE_UTIL_PATH)").getCompilerPath())' 2> /dev/null)
OL_JS_FILES = $(shell find node_modules/ol/src/ol -type f -name '*.js' 2> /dev/null)
NGEO_JS_FILES = $(shell find node_modules/ngeo/src -type f -name '*.js' 2> /dev/null)
APP_JS_FILES = $(shell find projectsample/static/js -type f -name '*.js')

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Main targets:"
	@echo
	@echo "- install            Install and build the project"
	@echo "- clean              Remove generated files"
	@echo "- cleanall           Remove all the build artefacts"
	@echo "- serve              Run the development server (pserve)"
	@echo

.PHONY: build
build: projectsample/static/build/build.js projectsample/static/build/build.css projectsample/static/build/build-debug.css

.PHONY: clean
clean:
	rm -f .build/node_modules.timestamp
	rm -f development.ini
	rm -f production.ini
	rm -rf projectsample/static/build

.PHONY: cleanall
cleanall: clean
	rm -rf .build
	rm -rf node_modules

.PHONY: install
install: build install-dev-egg .build/node_modules.timestamp

.PHONY: install-dev-egg
install-dev-egg: $(SITE_PACKAGES)/ProjectSample.egg-link

.PHONY: serve
serve: install build development.ini
	.build/venv/bin/pserve --reload development.ini

projectsample/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

projectsample/static/build/build.js: build.json $(OL_JS_FILES) $(NGEO_JS_FILES) $(APP_JS_FILES) .build/externs/angular-1.3.js .build/node_modules.timestamp
	mkdir -p $(dir $@)
	node tasks/build.js $< $@

projectsample/static/build/build.css: less/projectsample.less .build/node_modules.timestamp
	mkdir -p $(dir $@)
	./node_modules/.bin/lessc --clean-css $< > $@

projectsample/static/build/build-debug.css: less/projectsample.less .build/node_modules.timestamp
	mkdir -p $(dir $@)
	./node_modules/.bin/lessc $< > $@

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

$(SITE PACKAGES)/ProjectSample.egg-link: .build/venv setup.py
	(cd .. && ./ProjectSample/.build/venv/bin/python setup.py develop)
	.build/venv/bin/python setup.py develop

development.ini: development.ini.in
	sed 's|__CLOSURE_LIBRARY_PATH__|$(CLOSURE_LIBRARY_PATH)|' $< > $@

production.ini: production.ini.in
	sed 's|__CLOSURE_LIBRARY_PATH__|$(CLOSURE_LIBRARY_PATH)|' $< > $@
