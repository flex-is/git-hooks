# This file is part of helper package for git hooks.
#
# (c) Martin Miskovic <miskovic.martin@gmail.com>
#
# For the full copyright and license information, please view
# the LICENSE file that was distributed with this source code.

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
