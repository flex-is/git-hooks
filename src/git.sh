###################################################################################################:
# This file is part of helper package for git hooks.
#
# (c) Martin Miskovic <miskovic.martin@gmail.com>
#
# For the full copyright and license information, please view
# the LICENSE file that was distributed with this source code.
###################################################################################################:

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
# Install git hooks according to user input.
# Useful for install scripts.
##################################################
git_install_hooks() {
    read -p "Select the hook connection type (remote/local): " remote
    if [ -z $remote ] || [[ ${remote@L} == r* ]]; then
        git_install_hooks_remote
    else
        git_install_hooks_local
    fi
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