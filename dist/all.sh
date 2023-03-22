
# Common info message output
function msg_info () {
    echo "~ [INFO] $1"
}

# Common error message output
function msg_error () {
    echo "~ [ERROR] $1"
}

# Run PHP static analysis tool
function php_analyse () {
    local -r analyser="vendor/bin/phpstan"

    if ! [ -x $analyser ]; then
        msg_error "please install phpstan/phpstan"
        exit 1
    fi

    $analyser analyse -c phpstan.dist.neon --memory-limit=4G --no-interaction --no-progress
    local -i -r analyser_exit_code=$?
    if [ 0 -ne $analyser_exit_code ]; then
        msg_error "static analysis of php failed"
        exit 1
    fi
}

# Run PHP linter tool on cached files
function php_lint_cached () {
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

    $fixer fix --config=.php-cs-fixer.dist.php --no-interaction --dry-run --stop-on-violation --quiet $cached_files
    local -i -r fixer_exit_code=$?
    if [ 0 -ne $fixer_exit_code ]; then
        msg_error "lint validation of php failed"
        msg_error "please run PHP CS fixer first"
        exit 1
    fi

    return
}

# Alias for PHP lint
function php_cs_cached () {
    php_lint_cached
}

# Returns true if current commit is a merge commit
function git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
}
