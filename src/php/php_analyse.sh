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
