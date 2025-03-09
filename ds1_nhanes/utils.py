def find_project_root():
    """
    Finds the project root directory by searching for a README.md file.

    Starting from the current working directory (which should be the notebook
    directory if it is opened directly), this function moves up the folder 
    structure until it finds a directory that contains a README.md file. It
    then returns this path as a string. If no README.md is found, it returns
    None.

    Returns:
        str or None: The path to the directory containing README.md, or None 
        if no such directory is found.
    """

    # Start from the current directory
    current_dir = os.getcwd()

    # Keep going up until you find README.md
    while not os.path.isfile(os.path.join(current_dir, 'README.md')):
        parent_dir = os.path.dirname(current_dir)  # Get the parent directory
        if parent_dir == current_dir:  # Stop if we've reached the root directory
            print("README.md not found in any parent directories.")
            return None  # Or raise an error or return to current directory
        current_dir = parent_dir  # Move up to the parent directory
    return current_dir


def set_working_directory():
    """
    Detects whether Colab is active and sets working directory accordingly

    If google.colab is in the environment, working directory will be set to
    the df1_nhanes folder in drive. Everyone should have this folder loaded
    into their drive so it will work for them. If google.colab is not in the
    environment, the function will call find_project_root() to find the 
    README.md file and set that directory as the working directory.

    Returns:
        Sets the working directory to the root of the ds1_nhanes folder.    
    """

    try:
        # Check if running on Colab
        import google.colab
        print('Colab detected - setting directory to Drive project folder')
        os.chdir('/content/drive/My Drive/ds1_nhanes')
    except ImportError:
        # If not, set root directory for local use
        print('Colab not detected - setting directory for local use')
        os.chdir(find_project_root())

    # Print current working directory
    print("Current working directory:", os.getcwd())
