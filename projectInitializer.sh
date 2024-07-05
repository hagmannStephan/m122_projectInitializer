#!/bin/bash
set -euo pipefail

project_types=("python" "java")
original_dir=$(pwd)

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
        if [[ "$type" = "$2" ]]; then
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
    if [ "$2" = "python" ]; then
        mkdir -p "$3/$1/api"
        cp templates/python_flask_api/requirements.txt "$3/$1/"
        cp ./templates/python_flask_api/api/index.py "$3/$1/api/"
    elif [ "$2" = "java" ]; then
        cp -r ./templates/java_spring_app "$3/$1"
    fi
    echo "Success: Project $1 created in $3"
}

init_git() {
    # If statment check if a test is currently running
    answer=""
    remote_answer=""
    remote_url=""

    if [ "$#" -eq 4 ]; then
        answer="yes"
        remote_answer="yes"
        remote_url="https://github.com/username/repo.git"
    fi

    if [ "$answer" != "yes" ]; then
        read -r -p "Do you want to initialize a git repository? (yes/no): " answer
    fi

    if [ "$answer" = "yes" ]; then
        cd "$3/$1"
        git init
        git branch -m main
        
        if [ "$remote_answer" != "yes" ]; then
            read -r -p "Do you want to add a remote repository? (yes/no): " remote_answer
        fi

        if [ "$remote_answer" = "yes" ]; then
            if [ "$remote_url" != "https://github.com/username/repo.git" ]; then
                read -r -p "Enter the URL of the remote repository: " remote_url
            fi
            git remote add origin "$remote_url"
        fi
        
        echo "Git repository initialized"
    else
        echo "Git repository not initialized"
    fi
}

setup_python() {
    # Setup a virtual environment for Python
    cd "$original_dir"
    cd "$3/$1"

    echo "Setting up virtual environment..."
    echo "This may take a while, especially if you are running it in a sub system"

    python3 -m venv venv

    echo "Success: Virtual environment created in $3/$1/venv"

    # Detect the correct OS and activate the virtual environment accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # shellcheck disable=SC1091
        source venv/bin/activate
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # shellcheck disable=SC1091
        source venv/bin/activate
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # shellcheck disable=SC1091    
        source venv/Scripts/activate
    elif [[ "$OSTYPE" == "msys" ]]; then
        # shellcheck disable=SC1091
        source venv/Scripts/activate
    elif [[ "$OSTYPE" == "win32" ]]; then
        # shellcheck disable=SC1091
        source venv/Scripts/activate
    else
        echo "Unsupported OS"
        exit 1
    fi

    pip install -r requirements.txt
}

setup_java() {
    cd "$3/$1"

    echo "Installing the reqirements..."

    mvn clean
    mvn install
}

setup_app() {
    # Check if user desires to setup a virtual environment
    read -r -p "Do you want to set up the application? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        if [ "$2" = "python" ]; then
            setup_python "$1" "$2" "$3"
        elif [ "$2" = "java" ]; then
            setup_java "$1" "$2" "$3"
        fi
        echo "Setup completed"
    else
        echo "Setup skipped"
    fi
}

main() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>"
        echo "Description: This script initializes a project by copying a template to the specified project path and setting up necessary configurations."
        echo "Options:"
        echo "  -h, --help    Show this help page"
        echo "Examples:"
        echo "  projectInitializer.sh my_project python /path/to/project"
        echo "  projectInitializer.sh -h"
        exit 0
    fi

    if [ "$#" -ne 3 ]; then
        # Check if there are three provided arguments
        echo "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" >&2
        exit 1
    fi

    check_args "$1" "$2" "$3"   # Check if the provided arguments are valid
    copy_template "$1" "$2" "$3" # Copy the template to the desired desitnation
    init_git "$1" "$2" "$3"      # Initialize a git repository if desired
    setup_app "$1" "$2" "$3"

    echo "Project initialized successfully"
    exit 0
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
