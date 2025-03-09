# ds1_nhanes

Authors: Silas Decker, Jeannine Valcour, Liliana Bettolo, Tessa Lawler, Christopher Donovan

## Introduction

This is some stuff

## On Working Directories

Chris has been only somewhat successfully trying to manage this project so that it works in the Colab environment and also runs locally if it is pulled from GitHub. Currently using the magic function `%cd` in notebooks to persistenly change directory to the shared Drive. Currently not clear whether the mounting of Google Drive will work for everyone, so we will have to chat and troubleshoot if it does not.

## File Structure

Folders

- Folders should have a `.info` file with info about what is contained there (to do)
- `data` contains raw data, cleaned data, and other miscellany like FPED crosswalks to link USDA food codes to food groups. Raw data should be only `.xpt` files still warm from NHANES. If we save anything else as `.csv` or some such, it should go in cleaned.
- `notebooks` should have `.ipynb` files and contain the main workflow for the project
- The `ds1_nhanes` folder is the package directory which will eventually contain modules with functions to use throughout the project.
- The `outputs` folder should contain graphs and tables ready to throw into Overleaf. 

Others

- The `.gitignore` tells git what not to track.
- The `requirements.txt` file is a log of all the libraries that are used in the project. This can be used to recreate a virtual environment for reproducibility.

## License

<div style="display: flex; align-items: center;">
  <a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html#license-text">
    <img alt="GPLv3 License" style="border-width:0; margin-right: 10px;" src="https://www.gnu.org/graphics/gplv3-or-later-sm.png" />
  </a>
  <span>
    The code is licensed under the 
    <a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html#license-text">GNU General Public License v3</a>.
  </span>
</div>

NHANES datasets are made available to the public with attribution by the [Centers for Disease Control](https://wwwn.cdc.gov/nchs/nhanes/Default.aspx), but are not covered by any license apparently.

## Changelog

- Major changes go here