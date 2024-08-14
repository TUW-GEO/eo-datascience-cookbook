.ONESHELL:
SHELL = /bin/bash
.PHONY: help clean environment kernel post-render data
YML = $(wildcard notebooks/*.yml)
QMD = $(wildcard chapters/*.qmd)
REQ = $(basename $(notdir $(YML)))
CONDA_ENV_DIR := $(foreach i,$(REQ),$(shell conda info --base)/envs/$(i))
KERNEL_DIR := $(foreach i,$(REQ),$(shell jupyter --data-dir)/kernels/$(i))
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

help:
	@echo "make clean"
	@echo " clean all jupyter checkpoints"
	@echo "make environment"
	@echo " create a conda environment"
	@echo "make kernel"
	@echo " make ipykernel based on conda lock file"

clean:
	rm --force --recursive .ipynb_checkpoints/
	for i in $(REQ); do conda remove -n $$i --all -y ; jupyter kernelspec uninstall -y $$i ; done

$(CONDA_ENV_DIR):
	for i in $(YML); do conda env create -f $$i; done

environment: $(CONDA_ENV_DIR)
	@echo -e "conda environments are ready."

$(KERNEL_DIR): $(CONDA_ENV_DIR)
	pip install --upgrade pip
	pip install jupyter
	for i in $(REQ); do $(CONDA_ACTIVATE) $$i ; python -m ipykernel install --user --name $$i --display-name $$i ; conda deactivate; done

kernel: $(KERNEL_DIR)
	@echo -e "conda jupyter kernel is ready."

post-render:
	for i in $(QMD); do quarto convert $$i; done
	- mv chapters/*.ipynb notebooks/ >/dev/null 2>&1
	- for f in chapters/*.quarto_ipynb ; do mv -- "$f" "${f%.quarto_ipynb}.ipynb"  >/dev/null 2>&1; done
	cp Makefile notebooks/

data:
	wget -q -P ./data https://cloud.geo.tuwien.ac.at/s/AezWMFwmFQJsKyr/download/floodmap.zip
	cd data && unzip -n floodmap.zip && rm floodmap.zip