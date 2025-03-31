#!/bin/bash

# Run all the ipynb files in notebooks folder. Stop if there is an error
for notebook in notebooks/*ipynb; do
    echo -e "\nRunning $notebook..."
    jupyter nbconvert --execute --to notebook --inplace "$notebook"
    if [ $? -ne 0 ]; then
        echo -e "\nError running $notebook, stopping execution."
        exit 1
    fi
        echo -e "\nSuccessfully ran $notebook"
done
