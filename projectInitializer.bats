# ------------------------------------
# Static code test
# ------------------------------------

@test "shellcheck return 0 (static code check)" {
        run shellcheck ./projectInitializer.sh
        [ "$status" -eq 0 ]
}

# ------------------------------------
# Integration tests
# ------------------------------------

@test "return 1 if one of the three arguments is missing" {
    run ./projectInitializer.sh meinProjekt python
    [ "$status" -eq 1 ]
    [ "$output" == "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" ]
    run ./projectInitializer.sh meinProjekt /temp
    [ "$status" -eq 1 ]
    [ "$output" == "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" ]
    run ./projectInitializer.sh python /temp
    [ "$status" -eq 1 ]
    [ "$output" == "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" ]
}

@test "return 1 if the third param isn't a valid path" {
    run ./projectInitializer.sh meinProjekt python /some/made/up/path
    [ "$status" -eq 1 ]
    [ "$output" == "Error: /some/made/up/path is not a valid directory" ]
    run ./projectInitializer.sh meinProjekt python /
    [ "$status" -eq 1 ]
    [ "$output" == "Error: / is not a writable directory" ]
}

@test "return 1 if the second param isn't a valid project type" {
    [ -d "./testDict" ] && rm -r "./testDict"
    mkdir ./testDict
    run ./projectInitializer.sh meinProjekt assembly ./testDict
    [ "$status" -eq 1 ]
    [ "$output" == "Error: assembly is not a valid project type" ]
}

@test "return 0 if no additional action was performed" {
    run bash -c 'echo -e "no\nno" | ./projectInitializer.sh testProject python ./testDict/'
    [ -d "./testDict/testProject" ]
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository not initialized" ]]
    [[ "${lines[*]}" =~ "Setup skipped" ]]
    [[ "${lines[*]}" =~ "Project initialized successfully" ]]
}

@test "return 0 if the code was executed correctly and git repo initialized with remote but without venv" {
    run bash -c 'echo -e "yes\nyes\nhttps://github.com/username/repo.git\nno" | ./projectInitializer.sh meinProjekt python ./testDict'
    [ -d "./testDict/meinProjekt" ]
    [ -d "./testDict/meinProjekt/.git" ]
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
}

@test "return 0 if the code was executed correctly and git repo initialized without remote and without venv" {
    run bash -c 'echo -e "yes\nno\nno" | ./projectInitializer.sh meinJavaProjekt java ./testDict'
    [ -d "./testDict/meinJavaProjekt" ]
    [ -d "./testDict/meinJavaProjekt/.git" ]
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
}

@test "return 0 if the code was executed correctly and a venv but no git repo got initialized" {
    run bash -c 'echo -e "no\nyes" | ./projectInitializer.sh testProject python ./testDict/'
    [ -d "./testDict/testProject/venv" ]
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Success: Project testProject created in ./testDict/" ]
    [ "${lines[1]}" = "Git repository not initialized" ]
    [ "${lines[2]}" = "Setting up virtual environment..." ]
    [ "${lines[3]}" = "This may take a while, especially if you are running it in a sub system" ]
    [ "${lines[-1]}" = "Project initialized successfully" ]
}

@test "return 0 if the code was executed correctly and a venv and a git repo got without remote got initialized" {
    [ -d "./testDict" ] && rm -r "./testDict"
    mkdir ./testDict
    run bash -c 'echo -e "yes\nno\nyes" | ./projectInitializer.sh testProject python ./testDict'
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
    [[ "${lines[*]}" =~ "Setting up virtual environment..." ]]
    [[ "${lines[*]}" =~ "This may take a while, especially if you are running it in a sub system" ]]
    [ "${lines[-2]}" = "Setup completed" ]
    [ "${lines[-1]}" = "Project initialized successfully" ]
}

@test "return 0 if the code was executed correctly and a venv and a git repo got with remote got initialized" {
    [ -d "./testDict" ] && rm -r "./testDict"
    mkdir ./testDict
    run bash -c 'echo -e "yes\nyes\nhttps://github.com/username/repo.git\nyes" | ./projectInitializer.sh testProject python ./testDict'
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Success: Project testProject created in ./testDict" ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
    [[ "${lines[*]}" =~ "Setting up virtual environment..." ]]
    [[ "${lines[*]}" =~ "This may take a while, especially if you are running it in a sub system" ]]
    [ "${lines[-2]}" = "Setup completed" ]
    [ "${lines[-1]}" = "Project initialized successfully" ]
}

@test "return 0 and helppage if -h is provided as any param" {
    run ./projectInitializer.sh -h
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" ]
    [ "${lines[1]}" = "Description: This script initializes a project by copying a template to the specified project path and setting up necessary configurations." ]
    [ "${lines[2]}" = "Options:" ]
    [ "${lines[3]}" = "  -h, --help    Show this help page" ]
    [ "${lines[4]}" = "Examples:" ]
    [ "${lines[5]}" = "  projectInitializer.sh my_project python /path/to/project" ]
    [ "${lines[6]}" = "  projectInitializer.sh -h" ]
}

@test "return 0 and helppage if --help is provided as any param" {
    run ./projectInitializer.sh --help
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Usage: projectInitializer.sh <project_name> <project_type> <project_path>" ]
    [ "${lines[1]}" = "Description: This script initializes a project by copying a template to the specified project path and setting up necessary configurations." ]
    [ "${lines[2]}" = "Options:" ]
    [ "${lines[3]}" = "  -h, --help    Show this help page" ]
    [ "${lines[4]}" = "Examples:" ]
    [ "${lines[5]}" = "  projectInitializer.sh my_project python /path/to/project" ]
    [ "${lines[6]}" = "  projectInitializer.sh -h" ]
}

# ------------------------------------
# Unit tests
# ------------------------------------

source ./projectInitializer.sh

@test "Check if arguments are valid" {
    [ -d "./testDict" ] && rm -r "./testDict"
    mkdir ./testDict
    run check_args my_project python ./testDict
    [ "$status" -eq 0 ]
}

@test "Check if project path is a valid directory" {
    run check_args "my_project" "python" "/path/to/nonexistent_directory"
    [ "$status" -ne 0 ]
}

@test "Check if project type is valid" {
    run check_args "my_project" "invalid_type" "./testDict"
    [ "$status" -ne 0 ]
}

@test "Copy template for Java project" {
    run copy_template "my_project" "java" "./testDict"
    [ "$status" -eq 0 ]
    [ -d "./testDict/my_project" ]
    [ -f "./testDict/my_project/pom.xml" ]
    [ -d "./testDict/my_project/src" ]
}

@test "Copy template for Python project" {
    run copy_template "my_project" "python" "./testDict"
    [ "$status" -eq 0 ]
    [ -d "./testDict/my_project" ]
    [ -d "./testDict/my_project/api" ]
    [ -f "./testDict/my_project/requirements.txt" ]
}

@test "Initialize git repository" {
    run init_git "my_project" "python" "./testDict" "test"
    [ "$status" -eq 0 ]
    [ -d "./testDict/my_project/.git" ]
}

@test "Setup Python virtual environment" {
  run setup_python "my_project" "python" "./testDict"
  [ "$status" -eq 0 ]
  [ -d "./testDict/my_project/venv" ]
}