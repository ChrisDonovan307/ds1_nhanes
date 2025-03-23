#!/bin/bash

run() {
    for notebook in notebooks/*; do
        echo "Running $notebook..."
        jupyter nbconvert --execute --to notebook --inplace "$notebook"
        if [ $? -ne 0 ]; then
            echo "Error running $notebook, stopping execution."
            return 1
        fi
    done
}