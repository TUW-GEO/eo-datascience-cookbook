.ONESHELL:
SHELL = /bin/bash
.PHONY: help clean environment kernel teardown post-render data

YML = $(wildcard notebooks/*.yml)
QMD = $(wildcard chapters/*.qmd)
REQ = $(basename $(notdir $(YML)))
BASENAME = $(CURDIR)

CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate
CONDA_ENV_DIR := $(foreach i,$(REQ),$(shell conda info --base)/envs/$(i))
KERNEL_DIR := $(foreach i,$(REQ),$(shell jupyter --data-dir)/kernels/$(i))

help:
	@echo "Makefile for setting up environment, kernel, and pulling notebooks"
	@echo ""
	@echo "Usage:"
	@echo "  make environment  - Create Conda environments"
	@echo "  make kernel       - Create Conda environments and Jupyter kernels"
	@echo "  "
	@echo "  make teardown     - Remove Conda environments and Jupyter kernels"
	@echo "  make clean        - Removes ipynb_checkpoints"
	@echo "  make help         - Display this help message"

clean:
	rm --force --recursive .ipynb_checkpoints/ **/.ipynb_checkpoints/ _book/ \
		_freeze/ .quarto/

teardown:
	$(foreach f, $(REQ), \
		$(CONDA_ACTIVATE) $(f); \
		jupyter kernelspec uninstall -y $(f); \
		conda deactivate; \
		conda remove -n $(f) --all -y ; \
		conda deactivate; )

$(CONDA_ENV_DIR): $(YML)
	- conda update -n base -c conda-forge conda -y
	$(foreach f, $^, conda env create --file $(f); )

environment: $(CONDA_ENV_DIR)
	@echo -e "conda environments are ready."

$(KERNEL_DIR): $(CONDA_ENV_DIR)
	- pip install --upgrade pip
	pip install jupyter
	$(foreach f, $(REQ), \
		$(CONDA_ACTIVATE) $(f); \
		python -m ipykernel install --user --name $(f) --display-name $(f); \
		conda deactivate; )

kernel: $(KERNEL_DIR)
	@echo -e "conda jupyter kernel is ready."

post-render:
	- mv chapters/*.ipynb notebooks/ >/dev/null 2>&1
	- for f in chapters/*.quarto_ipynb ; do mv -- "$f" "${f%.quarto_ipynb}.ipynb"  >/dev/null 2>&1; done
	cp Makefile notebooks/

data:
	wget -q -P ./data https://cloud.geo.tuwien.ac.at/s/AezWMFwmFQJsKyr/download/floodmap.zip
	cd data && unzip -n floodmap.zip && rm floodmap.zip