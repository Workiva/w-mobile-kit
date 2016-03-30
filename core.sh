#!/bin/sh
# Formatting options
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
standard=`tput sgr0`

# Utility method for logging headings
function print_heading {
    echo
    echo -n "${underline}${bold}$*${normal}"
    echo
}

# Utility method for logging errors
function print_error {
    echo "${red}"
    echo "--------------------------------------------------------------"
    echo "$1"
    echo "--------------------------------------------------------------"
    echo "${standard}"
    exit 1
}

# Utility method for printing successes
function print_success {
    echo "${green}$1${standard}"
}
