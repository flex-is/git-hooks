###################################################################################################:
# This file is part of helper package for git hooks.
#
# (c) Martin Miskovic <miskovic.martin@gmail.com>
#
# For the full copyright and license information, please view
# the LICENSE file that was distributed with this source code.
###################################################################################################:

##################################################
# Run PHP testing tool
# RETURN:
#   0 if no issue is found, non-zero corresponds with phpunit exit codes.
##################################################
php_test () {
    local -r tester="vendor/bin/phpunit"

    if ! [ -x $tester ]; then
        msg_error "please install phpunit/phpunit"
        exit 1
    fi

    msg_info "running php unit tests..."
    php $tester -c phpunit.dist.xml --no-output
    local -i -r tester_exit_code=$?
    if [ 0 -ne $tester_exit_code ]; then
        msg_error "php unit tests failed"
        msg_error "please run PHPUnit & fix the issues first"
        exit $tester_exit_code
    fi
}
