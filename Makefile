.ONESHELL:
SHELL = /bin/bash
.PHONY: help clean environment kernel teardown post-render dev

YML = $(wildcard notebooks/**/*.yml)
REQ := $(basename $(notdir $(YML)))
NB != find chapters -name "*.quarto_ipynb" -o  -name "*.ipynb" -not -path \
	"*/.jupyter_cache/*"

CONDA_ENV != conda info --base
CONDA_ACTIVATE := source $(CONDA_ENV)/etc/profile.d/conda.sh ; \
	conda activate ; conda activate
CONDA_ENV_DIR := $(foreach i,$(REQ),$(CONDA_ENV)/envs/$(i))
KERNEL_DIR != $(CONDA_ACTIVATE) eo-datascience; jupyter --data-dir
KERNEL_DIR := $(foreach i,$(REQ),$(KERNEL_DIR)/kernels/$(i))

help:
	@echo "Makefile for setting up environment, kernel, and rendering  book"
	@echo ""
	@echo "Usage:"
	@echo "  make environment  - Create Conda environments"
	@echo "  make kernel       - Create Conda environments and Jupyter kernels"
	@echo "  make post-render  - Post-render Quarto book"
	@echo "  make preview      - Preview Jupyter Book"
	@echo "  "
	@echo "  make teardown     - Remove Conda environments and Jupyter kernels"
	@echo "  make clean        - Removes ipynb_checkpoints and quarto \
		temporary files"
	@echo "  make help         - Display this help message"

$(CONDA_ENV)/envs/eo-datascience:
	- conda update -n base -c conda-forge conda -y
	conda env create --file environment.yml

$(CONDA_ENV_DIR):
	$(foreach f, $(YML), conda env create --file $(f); )

environment: $(CONDA_ENV_DIR)
	@echo -e "conda environments are ready."

$(KERNEL_DIR):
	$(foreach f, $(REQ), \
		$(CONDA_ACTIVATE) $(f); \
		python -m ipykernel install --user --name $(f) --display-name $(f); \
		conda deactivate; )

kernel: $(CONDA_ENV)/envs/eo-datascience $(CONDA_ENV_DIR) $(KERNEL_DIR)
	@echo -e "jupyter kernels are ready."

post-render:
	$(foreach f, $(NB), \
		mv $(f) "$(subst chapters,notebooks,$(subst .quarto_ipynb,.ipynb,$(f)))"; )
	cp ./Makefile ./notebooks/
	cp -r ./chapters/images ./notebooks

preview: $(CONDA_ENV)/envs/eo-datascience $(CONDA_ENV_DIR) $(KERNEL_DIR)
	$(CONDA_ACTIVATE) eo-datascience
	- mkdir -p _preview/notebooks
	python -m pip install .
	cp ./chapters/references.bib ./_preview/notebooks/
	cp -r ./chapters/images ./_preview/notebooks
	wget https://raw.githubusercontent.com/TUW-GEO/eo-datascience-cookbook/refs/heads/main/README.md -nc -P ./_preview
	wget https://raw.githubusercontent.com/TUW-GEO/eo-datascience-cookbook/refs/heads/main/_config.yml -nc -P ./_preview
	wget https://raw.githubusercontent.com/TUW-GEO/eo-datascience-cookbook/refs/heads/main/notebooks/how-to-cite.md -nc -P ./_preview/notebooks
	render_sfinx_toc ./_preview
	clean_nb ./notebooks ./_preview/notebooks
	jupyter-book build ./_preview
	jupyter-book build ./_preview

clean:
	rm --force --recursive .ipynb_checkpoints/ **/.ipynb_checkpoints/ _book/ \
		_freeze/ .quarto/ _preview/ ./pytest_cache ./**/**/**/.jupyter_cache \
		./**/**/.jupyter_cache

teardown:
	conda remove -n eo-datascience --all -y
	$(foreach f, $(REQ), \
		$(CONDA_ACTIVATE) $(f); \
		jupyter kernelspec uninstall -y $(f); \
		conda deactivate; \
		conda remove -n $(f) --all -y ; \
		conda deactivate; )