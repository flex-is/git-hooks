###################################################################################################:
# This file is part of helper package for git hooks.
#
# (c) Martin Miskovic <miskovic.martin@gmail.com>
#
# For the full copyright and license information, please view
# the LICENSE file that was distributed with this source code.
###################################################################################################:

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
