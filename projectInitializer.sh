#!/bin/bash
set -euo pipefail

project_types=("python" "java")

check_args() {
    # Check if the following is true:
    # $1 => project name
    # $2 => project type
    # $3 => project path

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" >&2
        exit 1
    fi

    if [ ! -d "$3" ]; then
        echo "Error: $3 is not a valid directory" >&2
        exit 1
    fi

    if [ ! -w "$3" ]; then
        echo "Error: $3 is not a writable directory" >&2
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
        echo "Error: $2 is not a valid project type" >&2
        exit 1
    fi
}

copy_template() {
    # Copy the template to the desired destination (Solved so complexy because it did not work just with cp -r)
    if [ "$2" == "python" ]; then
        mkdir -p "$3/$1/api"
        cp templates/python_flask_api/requirements.txt "$3/$1/"
        cp ./templates/python_flask_api/api/index.py "$3/$1/api/"
    elif [ "$2" == "java" ]; then
        cp -r ./templates/java_spring_app "$3/$1"
    fi
    echo "Success: Project $1 created in $3"
}

init_git() {
    # Initialize a git repository if desired
    read -r -p "Do you want to initialize a git repository? (yes/no): " answer
    if [ "$answer" == "yes" ]; then
        cd "$3/$1"
        git init
        git branch -m main
        
        read -r -p "Do you want to add a remote repository? (yes/no): " remote_answer
        if [ "$remote_answer" == "yes" ]; then
            read -r -p "Enter the URL of the remote repository: " remote_url
            git remote add origin "$remote_url"
        fi
        
        echo "Git repository initialized"
    else
        echo "Git repository not initialized"
    fi
}

if [ "$#" -ne 3 ]; then
    # Check if there are three provided arguments
    echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" >&2
    exit 1
fi


check_args "$1" "$2" "$3"   # Check if the provided arguments are valid
copy_template "$1" "$2" "$3" # Copy the template to the desired desitnation
init_git "$1" "$2" "$3"      # Initialize a git repository if desired

echo "Project initialized successfully"
exit 0
