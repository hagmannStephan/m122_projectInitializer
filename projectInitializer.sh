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
}


check_args $1 $2 $3