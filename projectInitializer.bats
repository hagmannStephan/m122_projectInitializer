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
    rm -r ./testDict
    mkdir ./testDict
    run ./projectInitializer.sh meinProjekt assembly ./testDict
    [ "$status" -eq 1 ]
    [ "$output" == "Error: assembly is not a valid project type" ]
}

@test "return 0 if the code was executed correctly and no git repo initialized" {
    run bash -c 'echo "no" | ./projectInitializer.sh meinProjekt python ./testDict' # The -c flag in bash -c is used to pass a command as a string to be executed by the shell.
    [ -d "./testDict/meinProjekt" ]
    [ "$status" -eq 0 ]
    [ "${lines[1]}" = "Git repository not initialized" ]
}

@test "return 0 if the code was executed correctly and git repo initialized with remote" {
    run bash -c 'echo -e "yes\nyes\nhttps://github.com/username/repo.git" | ./projectInitializer.sh meinProjekt python ./testDict'
    [ -d "./testDict/meinProjekt" ]
    [ -d "./testDict/meinProjekt/.git" ]
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
}

@test "return 0 if the code was executed correctly and git repo initialized without remote" {
    run bash -c 'echo -e "yes\nno" | ./projectInitializer.sh meinJavaProjekt java ./testDict'
    [ -d "./testDict/meinJavaProjekt" ]
    [ -d "./testDict/meinJavaProjekt/.git" ]
    [ "$status" -eq 0 ]
    [[ "${lines[*]}" =~ "Git repository initialized" ]]
}

# ------------------------------------
# Unit tests
# ------------------------------------

# @test "Check if script initializes a Git repository when requested" {
#   run init_git "meinProjekt" "python" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Do you want to initialize a git repository? (yes/no): " ]

#   # Simulate user input "yes"
#   echo "yes" | run init_git "meinProjekt" "python" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Dou you want to add a remote repository? (yes/no): " ]

#   # Simulate user input "yes"
#   echo "yes" | run init_git "meinProjekt" "python" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Enter the URL of the remote repository: " ]

#   # Simulate user input "https://github.com/username/repo.git"
#   echo "https://github.com/username/repo.git" | run init_git "meinProjekt" "python" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Git repository initialized" ]
# }

# @test "Check if script does not initialize a Git repository when not requested" {
#   run init_git "meinJavaProjekt" "java" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Do you want to initialize a git repository? (yes/no): " ]

#   # Simulate user input "no"
#   echo "no" | run init_git "meinJavaProjekt" "java" "./testDict"
#   [ "$status" -eq 0 ]
#   [ "${lines[0]}" = "Git repository not initialized" ]
# }
