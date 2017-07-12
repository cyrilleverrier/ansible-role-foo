SHELL := /bin/bash

.ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
.PWD=$(.ROOT_DIR)


#------ PYTHON ------#
PYTHON_VERSION=2
.PYTHON=python$(PYTHON_VERSION)
.PYTHON_PATH=$(shell which $(.PYTHON))

.PIP_INSTALL=pip install --extra-index-url https://public:WDu3a4-YQMG0dD_Cp-H5ecEKJMqJ4PR4@fabriscale.jfrog.io/fabriscale/api/pypi/pyfabriscale/simple --upgrade 

#.MOLECULE_DEBUG=
.MOLECULE_DEBUG=--debug

MOLECULE_SCENARIO?=default

.PHONY: workaround
workaround: destroy create converge idempotence verify destroy

.PHONY: new-molecule-role
new-molecule-role: .py${PYTHON_VERSION}env/env/bin/python 
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) init scenario --role-name ansible-role-foo --scenario-name $(MOLECULE_SCENARIO) --driver-name vagrant

.PHONY: create
create: .py${PYTHON_VERSION}env/env/bin/python
	- . .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) create
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) create

.PHONY: lint
lint: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule  $(.MOLECULE_DEBUG) lint


.PHONY: converge
converge: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule  $(.MOLECULE_DEBUG) converge

.PHONY: idempotence
idempotence: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate; molecule  $(.MOLECULE_DEBUG) idempotence

.PHONY: verify
verify: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) verify

.PHONY: destroy
destroy: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) destroy

.PHONY: test
test: .py${PYTHON_VERSION}env/env/bin/python
	. .py${PYTHON_VERSION}env/env/bin/activate;  molecule $(.MOLECULE_DEBUG) test

# --------------------------------------------
# Setup of python virtual env and pip cache

.py${PYTHON_VERSION}env/env/bin/python: requirements.txt
	test -d .py${PYTHON_VERSION}env/env || virtualenv -p python${PYTHON_VERSION} .py${PYTHON_VERSION}env/env > /dev/null
	. .py${PYTHON_VERSION}env/env/bin/activate && pip install -Ur requirements.txt
	touch .py${PYTHON_VERSION}env/env/bin/activate

#---------
# Cleanup

.PHONY: clean
clean:
	make destroy
	$(RM) -r __pycache__
	-@find molecule/**/.molecule/  -delete


