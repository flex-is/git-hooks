
# Install git hooks with provided commands
_git_install_hooks() {
    local -r separator='### @auto-generated'
    commands=("$@")

    find .githooks -type f | while read source
    do
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

# Install git hooks with local calls
git_install_hooks_local() {
    local commands=("sh @source")

    _git_install_hooks "${commands[@]}"
}

# Install git hooks with remote calls
git_install_hooks_remote() {
    local commands=()

    read -p "Enter SSH host: " remoteHost
    read -p "Enter remote path ($(pwd)): " remoteDir
    if [ -z $remoteDir ]; then
        remoteDir=$(pwd)
    fi

    commands+=("ssh $remoteHost \"cd $remoteDir; sh @source\"")

    _git_install_hooks "${commands[@]}"
}

# Returns true if current commit is a merge commit
git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
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
