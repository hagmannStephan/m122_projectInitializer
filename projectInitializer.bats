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