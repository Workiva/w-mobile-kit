#!/usr/bin/env bash
source ./core.sh

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function run_unit_tests() {
    echo "Starting unit tests."

    xcodebuild -workspace WMobileKit.xcworkspace -scheme WMobileKit -enableCodeCoverage YES -sdk iphonesimulator test | ocunit2junit

    unit_test_failure_check
}

function unit_test_failure_check {
    # Due to piping the results into ocunit2junit, $? does not represent testing results
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        print_error "ERROR: iOS unit test failure(s). See above for details."
    fi
}

run_unit_tests
