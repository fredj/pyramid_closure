CLOSURE_TOOLS_FILES := depswriter.py source.py treescan.py

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Main targets:"
	@echo
	@echo "- install            Install the project locally"
	@echo "- cleanall           Remove all the build artefacts"
	@echo "- closure-tools      Update the closure build tools"
	@echo

.PHONY: cleanall
cleanall:
	rm -rf .build

.PHONY: closure-tools
closure-tools: .build/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_TOOLS_FILES))

.PHONY: install
install: install-dev-egg

.PHONY: install-dev-egg
install-dev-egg: .build/venv/lib/python2.7/site-packages/pyramid-closure.egg-link

pyramid_closure/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

.build/venv:
	mkdir -p $(dir $@)
	virtualenv --no-site-packages $@

.build/venv/lib/python2.7/site-packages/pyramid-closure.egg-link: .build/venv setup.py
	.build/venv/bin/python setup.py develop
