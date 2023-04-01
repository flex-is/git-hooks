####################################################################################################
# Helper package for git hooks v0.1.0
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

# If there are whitespace errors, print the offending file names and fail.
git_check_whitespace_cached () {
    git diff-index --check --cached HEAD --
}

# Returns short name of the current branch
git_current_branch() {
    git symbolic-ref --short HEAD
    return
}

# Install git hooks with local calls
git_install_hooks_local() {
    local -r sourceDirDefault='scripts/git/hooks'
    local commands=("@source")

    read -p "Enter source dir ($sourceDirDefault): " sourceDir
    if [ -z $sourceDir ]; then
        sourceDir=$sourceDirDefault
    fi

    _git_install_hooks $sourceDir "${commands[@]}"
}

# Install git hooks with remote calls
git_install_hooks_remote() {
    local -r remoteDirDefault=$(pwd)
    local -r sourceDirDefault='scripts/git/hooks'
    local commands=()

    read -p "Enter SSH host: " remoteHost
    read -p "Enter remote root dir ($remoteDirDefault): " remoteDir
    read -p "Enter source dir ($sourceDirDefault): " sourceDir
    if [ -z $remoteDir ]; then
        remoteDir=$remoteDirDefault
    fi
    if [ -z $sourceDir ]; then
        sourceDir=$sourceDirDefault
    fi

    commands+=("ssh $remoteHost \"cd $remoteDir; @source\"")

    _git_install_hooks $sourceDir "${commands[@]}"
}

# Returns true if current commit is a merge commit
git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
}

# Check if current branch is in list
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

# Install git hooks with provided commands
_git_install_hooks() {
    local -r separator='### @auto-generated'
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
# Common info message output
msg_info () {
    echo "~ [INFO] $1"
}

# Common error message output
msg_error () {
    echo "~ [ERROR] $1"
}

# Run PHP static analysis tool
php_analyse () {
    local -r analyser="vendor/bin/phpstan"

    if ! [ -x $analyser ]; then
        msg_error "please install phpstan/phpstan"
        exit 1
    fi

    msg_info "running php static analysis..."
    $analyser analyse -c phpstan.dist.neon --memory-limit=4G --no-interaction --no-progress --quiet
    local -i -r analyser_exit_code=$?
    if [ 0 -ne $analyser_exit_code ]; then
        msg_error "php static analysis failed"
        msg_error "please run PHPStan & fix the issues first"
        exit 1
    fi
}

# Run PHP linter tool on cached files
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
    $fixer fix --config=.php-cs-fixer.dist.php --no-interaction --dry-run --stop-on-violation --quiet $cached_files
    local -i -r fixer_exit_code=$?
    if [ 0 -ne $fixer_exit_code ]; then
        msg_error "php linting failed"
        msg_error "please run PHP CS fixer first"
        exit 1
    fi

    return
}

# Alias for PHP lint
php_cs_cached () {
    php_lint_cached
}
