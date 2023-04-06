# Changelog

## 0.3.0 - 2023-04-06
### Added
-   New functions:
    -   `php_test` triggers php unit testing tool

## 0.2.0 - 2023-04-05
### Added
-   Validation of header comments inside source files
-   Single header comment in `dist` files inluding license information
-   Allow each hook to choose executable shell
-   Customized relative path to git hook source files (default `scripts\git\hooks`)
-   New functions:
    -   `git_check_whitespace_cached` checks for whitespace errors on cached files
    -   `git_current_branch` returns short name of the current branch
    -   `git_is_current_branch_in_list` checks if current branch is in a list

### Changed
-   Makefile `dist` recipe includes only  `.sh` files

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