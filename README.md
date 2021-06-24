[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mlund/template-for-supporting-information/HEAD)

# template-for-supporting-information

Template for Notebooks for Supporting Information and Zenodo Deposition.

## Layout

Description of the directory layout.

- `.zenodo.json` This contains metedata for the Zenodo deposition. When you on github make a new
  _Release_, this can trigger a Zenodo build. To learn more about the available datafields, see
  [here](https://developers.zenodo.org/?python#depositions).
- `README.md` This is the file you're viewing right now. You may want to edit the **Binder** badge above to match your repository.
- `environment.yml` Defines the required Python packages using conda. It's a good idea to try to set specific versions of your
  dependencies as their behavior may change in the future.
  The environment is currently called `my_environment` and you'll likely want to rename it to something less generic.

## Requirements

To run the Notebooks online, click on the _Launch Binder_ logo above. Alternatively, if you want to run on your own computer,
install python using e.g. [Miniconda](https://conda.io/miniconda.html) or [Anaconda](https://docs.conda.io))
and make sure all required packages are loaded by issuing the following terminal commands

``` bash
    conda env create -f environment.yml
    source activate my_environment
    jupyter-notebook
```
