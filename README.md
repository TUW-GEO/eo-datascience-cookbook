<img src="tuw-geo-logo.png" alt="tuw-geo-logo" width="300"/>

# Earth Observation Datascience Cookbook

[![nightly-build](https://github.com/ProjectPythia/cookbook-template/actions/workflows/nightly-build.yaml/badge.svg)](https://github.com/ProjectPythia/cookbook-template/actions/workflows/nightly-build.yaml)
[![Binder](https://binder.projectpythia.org/badge_logo.svg)](https://binder.projectpythia.org/v2/gh/ProjectPythia/cookbook-template/main?labpath=notebooks)
[![DOI](https://zenodo.org/badge/475509405.svg)](https://zenodo.org/badge/latestdoi/475509405)

This Project Pythia Cookbook covers a range of earth observation example employing the Pangeo philosophy.

## Motivation

The motivation behind this book is to provide some examples of Pangeo-based workflows applied to realistic examples in earth observation.

## Authors

[Martin Schobben](https://github.com/MartinSchobben), [Nikolas Pikall](https://github.com/npikall)

### Contributors

<a href="https://github.com/TUW-GEO/eo-datascience-cookbook/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=TUW-GEO/eo-datascience-cookbook" />
</a>

## Structure

This book comprises a set of real life examples.

### Classification

This section offers an overview of ...

## Running the Notebooks

You can either run the notebook using [Binder](https://binder.eo-datascience-cookbook.org/) or on your local machine.

### Running on Binder

The simplest way to interact with a Jupyter Notebook is through
[Binder](https://binder.eo-datascience-cookbook.org/), which enables the execution of a
[Jupyter Book](https://jupyterbook.org) in the cloud. The details of how this works are not
important for now. All you need to know is how to launch a Pythia
Cookbooks chapter via Binder. Simply navigate your mouse to
the top right corner of the book chapter you are viewing and click
on the rocket ship icon, (see figure below), and be sure to select
“launch Binder”. After a moment you should be presented with a
notebook that you can interact with. I.e. you’ll be able to execute
and even change the example programs. You’ll see that the code cells
have no output at first, until you execute them by pressing
{kbd}`Shift`\+{kbd}`Enter`. Complete details on how to interact with
a live Jupyter notebook are described in [Getting Started with
Jupyter](https://foundations.projectpythia.org/foundations/getting-started-jupyter.html).

### Running on Your Own Machine

If you are interested in running this material locally on your computer, you will need to follow this workflow:

(Replace "cookbook-example" with the title of your cookbooks)

1. Clone the `https://github.com/TUW-GEO/eo-datascience-cookbook` repository:

   ```bash
    git clone https://github.com/TUW-GEO/eo-datascience-cookbook
   ```

1. Move into the `eo-datascience-cookbook` directory
   ```bash
   cd eo-datascience-cookbook
   ```
1. Create and activate your conda environment from the `environment.yml` file
   ```bash
   conda env create -f environment.yml
   conda activate eo-datascience-cookbook
   ```
1. Move into the `notebooks` directory and start up Jupyterlab
   ```bash
   cd notebooks/
   jupyter lab
   ```
