#!/bin/bash

# Run all files in notebooks directory, stop on error
for script in notebooks/*; do

    # If it is a directory, skip it
    if [ -d "$script" ]; then
        continue
    # If it is the terminal notebook, skip it
    elif [[ $script == *terminal.ipynb ]]; then
        continue
    fi

    # Print script name on start
    echo -e "\nRunning $script..."
    
    # Run based on whether it is notebook or R script
    if [[ $script == *.ipynb ]]; then
        jupyter nbconvert --execute --to notebook --inplace "$script"
    elif [[ $script == *.R ]]; then
        Rscript "$script"
    fi

    # Stop if error, otherwise print success
    if [ $? -ne 0 ]; then
        echo -e "\nError running $script, stopping execution."
        exit 1
    else
        echo -e "\nSuccessfully ran $script"
    fi

done

# Open terminal for user
exec /bin/bash

