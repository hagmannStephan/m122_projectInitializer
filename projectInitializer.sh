#!/bin/bash
set -euo pipefail

project_types=("python" "java")

check_args() {
    # Check if the following is true:
    # $1 => project name
    # $2 => project type
    # $3 => project path

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>"
        exit 1
    fi

    if [ ! -d "$3" ]; then
        echo "Error: $3 is not a valid directory"
        exit 1
    fi

    local valid_type=false
    for type in "${project_types[@]}"; do
        if [[ "$type" == "$2" ]]; then
            valid_type=true
            break
        fi
    done

    if [ "$valid_type" = false ]; then
        echo "Error: $2 is not a valid project type"
        exit 1
    fi
}

copy_template() {
    if [ "$2" == "python" ]; then
        cp -r ./templates/python "$3/$1"
    elif [ "$2" == "java" ]; then
        cp -r ./templates/java "$3/$1"
    fi
}

if [ "$#" -ne 3 ]; then
    # Check if there are three provided arguments
    echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>"
    exit 1
fi


check_args "$1" "$2" "$3"   # Check if the provided arguments are valid
copy_template "$1" "$2" "$3" # Copy the template to the desired desitnation

exit 0
