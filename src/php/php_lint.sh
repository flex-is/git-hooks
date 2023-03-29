# This file is part of helper package for git hooks.
#
# (c) Martin Miskovic <miskovic.martin@gmail.com>
#
# For the full copyright and license information, please view
# the LICENSE file that was distributed with this source code.

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
