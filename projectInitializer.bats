@test "shellcheck return 0 (static code check)" {
        run shellcheck ./projectInitializer.sh
        [ "$status" -eq 0 ]
}

@test "retun 1 if one of the three arguments is missing" {
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

@test "retun 1 if the third param isn't a valid path" {
    run ./projectInitializer.sh meinProjekt python /some/made/up/path
    [ "$status" -eq 1 ]
    [ "$output" == "Error: /some/made/up/path is not a valid directory" ]
    run ./projectInitializer.sh meinProjekt python /
    [ "$status" -eq 1 ]
    [ "$output" == "Error: / is not a writable directory" ]
}

@test "retun 1 if the second param isn't a valid project type" {
    run ./projectInitializer.sh meinProjekt assembly ./testDict
    [ "$status" -eq 1 ]
    [ "$output" == "Error: assembly is not a valid project type" ]
}

@test "retun 0 if the code was executed correctly" {
    run ./projectInitializer.sh meinProjekt python ./testDict
    [ "$status" -eq 0 ]
    [ -d "./testDict/meinProjekt" ]
    run ./projectInitializer.sh meinProjekt java ./testDict
    [ "$status" -eq 0 ]
    [ -d "./testDict/meinProjekt" ]
}