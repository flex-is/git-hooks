# Changelog

## Unreleased
-   Make dist includes only `.sh` files
-   Added automatic source header comments
-   Added automatic dist header comment
-   Added git check for whitespace errors
-   Added git function to get name of the current branch
-   Added git function to check if current branch is in list of provided names
-   Customized relative path to source git hooks. default `scripts\git\hooks`
-   Allow each hook file to choose executable shell

## 0.1.0 - 2023-03-26
### Added
-   Shared hooks

### Changed
-   Makefile `dist` target

## 0.0.2 - 2023-03-22
### Added
-   Build workflow to validate generated distributable files
-   Readme badge to the latest release
-   Readme badge to display build status

### Changed
-   Set explicit file order when generating distributable files
-   Removed `function` keyword from shell functions
-   Updated install instructions

## 0.0.1 - 2023-03-22
### Added
-   MakeFile recipe to generate distributables
-   Functions:
    -   Common message output format
    -   Determine whether commit is a merge commit
    -   PHP analyse
    -   PHP CS fixer