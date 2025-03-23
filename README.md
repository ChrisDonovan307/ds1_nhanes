_Last updated: March 14th, 2025_

# ds1_nhanes

Authors: Silas Decker, Jeannine Valcour, Liliana Bettolo, Tessa Lawler, Christopher Donovan

## Introduction

Herein lies the repository for 'Dietary Patterns in the U.S. and Associated Health and
Environmental Impact: A Cluster Analysis', a project for CSYS 5870: Data Science 1. 

## File Structure

Folders

- The `data/` directory contains raw data, cleaned data, and other miscellany like FPED crosswalks to link USDA food codes to food groups. Raw data should be only `.xpt` files still warm from the CDC. We should also include cleaned datasets saved as `.csv` files, along with a `.info` file that contains provenance and metadata for datasets in each folder. 
- `notebooks/` should have `.ipynb` files and contain the main workflow for the project. 
- `ds1_nhanes/` is the package directory which will contain modules with functions to use throughout the project. They will be imported and called from notebooks.
- The `outputs/` folder should contain graphs and tables ready to throw into Overleaf. 

Loose Files

- The `.gitignore` file tells git what not to track.
- The `requirements.txt` file is a log of all the libraries that are used in the project. 
- The `README.md` is a markdown that produces the html version shown on the repo. This will be rendered and included as a `.pdf` to make it easier to access on Drive as well.
- The text of the license is included in `LICENSE.md`. 

## Running the Project

This project is set up such that it can be on either Google Colab or cloned and run locally with relative ease.

### Colab

The top of each notebook should contain a cell where the Google Drive is mounted to the notebook. Once mounted, this should provide access to the `ds1_nhanes` directory which contains the project and datasets. Note that this will only work if the `ds1_nhanes` directory is at the top of your MyDrive folder. If it is not, create a shortcut for it there. 

The default working directory when opening a notebook is the same directory in which the notebook is located. This is not actually what we want. We want it to be the root of the project directory. So, once the drive is mounted, the next cell should use `os.chdir()` to set the working directory to the `ds1_nhnanes` folder. Then the notebook should be ready to run.

### Local

For local use, we will clone the repository from GitHub and reproduce a virtual environment with libraries used in the project. The first code chunk should set the working drive to the root directory with a local path.

To run the project locally:

#### 1. Clone Git Repository

```
git clone https://github.com/ChrisDonovan307/ds1_nhanes.git
```

#### 2. Create a Virtual Environment

```
python -m venv .venv
```

#### 3. Activate Environment

For Mac/Linux, activate the environment using:

```
source .venv/bin/activate
```

For Windows Commmand Prompt, activate the environment using:

```
source .venv/Scripts/activate
```

For Windows PowerShell, activate the environment using:

```
.venv\Scripts\Activate.ps1
```

#### 4. Install Packages

Install package versions as specified in the `requirements.txt` file with:

```
pip install -r requirements.txt
```

#### 5. Run a Shell or Something

Might make sense to run a shell that runs the `.ipynb` scripts in order?

#### 6. But Really

The plan is to eventually deploy the analysis in a Docker container unless we suddenly decide it isn't worth the trouble in about a month. 

## Data and Licensing

<div style="display: flex; align-items: center;">
  <a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html#license-text">
    <img alt="GPLv3 License" style="border-width:0; margin-right: 10px;" src="https://www.gnu.org/graphics/gplv3-or-later-sm.png" />
  </a>
  <span>
    The code in this project is licensed under the 
    <a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html#license-text">GNU General Public License v3</a>.
  </span>
</div>
<br>

NHANES datasets are made available to the public with attribution by the [Centers for Disease Control](https://wwwn.cdc.gov/nchs/nhanes/Default.aspx), but are not covered by any license apparently.

The [Food Patterns Equivalents Database (FPED)](https://www.ars.usda.gov/northeast-area/beltsville-md-bhnrc/beltsville-human-nutrition-research-center/food-surveys-research-group/docs/fndds-download-databases/) is made available by the USDA apparently without any license or explanation. Which is fucked up because that means it is basically copyrighted. But this is obviously meant to be available to the public. Can anyone find a license for this?

Carbon emissions and cumulative energy demand for food consumption patterns were derived from the [dataFIELD database](https://css.umich.edu/page/datafield) at the Center for Sustainable Systems at the University of Michigan. It is released with a publication from [Heller et al. (2018)](https://iopscience.iop.org/article/10.1088/1748-9326/aab0ac#erlaab0acfn2). However, the data are also lacking any license that I can find. 

## Changelog

**2025-03-11:** Built project structure in Colab, linked Colab with GitHub, and shared all repositories with team members.