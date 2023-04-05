####################################################################################################
# Helper package for git hooks v0.2.0
# https://github.com/flex-is/git-hooks/
#
# Released under the MIT License
#
# Copyright (c) 2023 Martin Miskovic
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
####################################################################################################

##################################################
# Check whitespace errors on cached/staged files
##################################################
git_check_whitespace_cached () {
    git diff-index --check --cached HEAD --
}

##################################################
# Returns short name of the current branch
# OUTPUTS:
#   Name of the current branch
##################################################
git_current_branch() {
    git symbolic-ref --short HEAD
    return
}

##################################################
# Install standard git hooks
##################################################
git_install_hooks_local() {
    local -r scriptDirDefault='scripts/git/hooks'
    local commands=("@source")

    read -p "Enter script directory ($scriptDirDefault): " scriptDir
    if [ -z $scriptDir ]; then
        scriptDir=$scriptDirDefault
    fi

    _git_install_hooks $scriptDir "${commands[@]}"
}

##################################################
# Install git hooks with remote calls
##################################################
git_install_hooks_remote() {
    local -r projectRootDefault=$(pwd)
    local -r scriptDirDefault='scripts/git/hooks'
    local commands=()

    read -p "Enter SSH host: " remoteHost
    read -p "Enter project root directory ($projectRootDefault): " projectRoot
    read -p "Enter script directory ($scriptDirDefault): " scriptDir
    if [ -z $projectRoot ]; then
        projectRoot=$projectRootDefault
    fi
    if [ -z $scriptDir ]; then
        scriptDir=$scriptDirDefault
    fi

    commands+=("ssh $remoteHost \"cd $projectRoot; @source\"")

    _git_install_hooks $scriptDir "${commands[@]}"
}

##################################################
# Check whether the current commit is a merge commit
# OUTPUTS:
#   True on merge commit, otherwise false.
##################################################
git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
}

##################################################
# Check whether the current branch is in provided list
# ARGUMENTS:
#   Array of branch names
# OUTPUTS:
#   True on match, otherwise false.
##################################################
git_is_current_branch_in_list() {
    local -r current=$(git_current_branch)
    branches=("$@")

    for i in "${branches[@]}"
    do
        if [ $i == $current ]; then
            true
            return
        fi
    done

    false
    return
}

##################################################
# @internal
# Add or replace generated git hooks with given set of commands
# ARGUMENTS:
#   - source directory with shared hooks
#   - array of hook commands
##################################################
_git_install_hooks() {
    local -r separator='########## @auto-generated ##########'
    local -r sourceDir=$1
    shift
    commands=("$@")

    find $sourceDir -type f | while read source
    do
        chmod a+x $source
        hook=".git/hooks/$(basename -- $source)"
        touch $hook

        line=$(sed -n -e "/$separator/=" $hook | sed -n '$p')
        if ! [ -z $line ]; then
            sed -i "1,${line}d" $hook
        fi

        if ! [ -s $hook ]; then
            echo '#!/bin/sh' > $hook
            echo $separator >> $hook
        else
            sed -i "2i $separator" $hook
        fi

        numcmd=$((${#commands[@]}-1))
        for i in $(seq $numcmd -1 0); do
            command="${commands[$i]//\@source/$source}"
            sed -i "2i $command" $hook
        done

    done
}
##################################################
# Print a given string with a semantic into prefix
# ARGUMENTS:
#   String to print
# OUTPUTS:
#   Write String to stdout
##################################################
msg_info () {
    echo "~ [INFO] $1"
}

##################################################
# Print a given string with a semantic error prefix
# ARGUMENTS:
#   String to print
# OUTPUTS:
#   Write String to stdout
##################################################
msg_error () {
    echo "~ [ERROR] $1"
}

##################################################
# Run PHP static analysis tool
# RETURN:
#   0 if no issue is found, non-zero corresponds with phpstan exit codes.
##################################################
php_analyse () {
    local -r analyser="vendor/bin/phpstan"

    if ! [ -x $analyser ]; then
        msg_error "please install phpstan/phpstan"
        exit 1
    fi

    msg_info "running php static analysis..."
    php $analyser analyse -c phpstan.dist.neon --memory-limit=4G --no-interaction --no-progress --quiet
    local -i -r analyser_exit_code=$?
    if [ 0 -ne $analyser_exit_code ]; then
        msg_error "php static analysis failed"
        msg_error "please run PHPStan & fix the issues first"
        exit $analyser_exit_code
    fi
}

##################################################
# Run PHP linter tool on cached/staged files
# RETURN:
#   0 if no issue is found, non-zero corresponds with cs fixer exit codes.
##################################################
php_lint_cached () {
    local -r fixer="vendor/bin/php-cs-fixer"

    if ! [ -x $fixer ]; then
        msg_error "please install friendsofphp/php-cs-fixer"
        exit 1
    fi

    local -r cached_files=`git diff --name-only --cached --diff-filter=AM | grep -e '.php$' | cut -d ' ' -f 9 | tr '\n' ' '`
    if [ -z $cached_files ]; then
        msg_info "skipping linting - no php files staged for commit"
        return
    fi

    msg_info "running php linting..."
    php $fixer fix --config=.php-cs-fixer.dist.php --no-interaction --dry-run --stop-on-violation --quiet $cached_files
    local -i -r fixer_exit_code=$?
    if [ 0 -ne $fixer_exit_code ]; then
        msg_error "php linting failed"
        msg_error "please run PHP CS fixer first"
        exit $fixer_exit_code
    fi

    return
}

##################################################
# Alias for PHP lint
##################################################
php_cs_cached () {
    php_lint_cached
}
