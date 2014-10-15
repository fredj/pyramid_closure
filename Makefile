SITE_PACKAGES = $(shell .build/venv/bin/python -c "import distutils; print(distutils.sysconfig.get_python_lib())" 2> /dev/null)
CLOSURE_TOOLS_FILES := depswriter.py source.py treescan.py

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Main targets:"
	@echo
	@echo "- install            Install the project locally"
	@echo "- check              Perform a number of checks on the code"
	@echo "- cleanall           Remove all the build artefacts"
	@echo "- closure-tools      Update the closure build tools"
	@echo "- flake8             Run flake8 checker on the Python code"
	@echo

.PHONY: check
check: flake8

.PHONY: cleanall
cleanall:
	rm -rf .build

.PHONY: closure-tools
closure-tools: .build/node_modules.timestamp $(addprefix pyramid_closure/closure/, $(CLOSURE_TOOLS_FILES))

.PHONY: flake8
flake8: .build/venv/bin/flake8
	.build/venv/bin/flake8 --exclude pyramid_closure/closure pyramid_closure

.PHONY: install
install: install-dev-egg

.PHONY: install-dev-egg
install-dev-egg: $(SITE_PACKAGES)/pyramid-closure.egg-link

pyramid_closure/closure/%.py: $(CLOSURE_LIBRARY_PATH)/closure/bin/build/%.py
	cp $< $@

.build/venv:
	mkdir -p $(dir $@)
	virtualenv --no-site-packages $@

.build/venv/bin/flake8: .build/venv
	.build/venv/bin/pip install -r dev-requirements.txt > /dev/null 2>&1
	touch $@

$(SITE_PACKAGES)/pyramid-closure.egg-link: .build/venv setup.py
	.build/venv/bin/pip install -r requirements.txt
