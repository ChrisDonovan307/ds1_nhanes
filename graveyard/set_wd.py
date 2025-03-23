# Dynamically set project root depending on whether it is Colab or local

# This script will live in the notebooks folder so it is accessible 
import os
from pathlib import Path

try:
    # Check if running on Colab
    import google.colab
    print('Colab detected - setting directory to Drive project folder')
    os.chdir('/content/drive/My Drive/ds1_nhanes')
except ImportError:
    # If not, set root directory for local use
    print('Colab not detected - setting directory for local use')
    notebook_dir = Path(os.getcwd())
    os.chdir(notebook_dir.parent)

# Print current working directory
print("Current working directory:", os.getcwd())