#!/usr/bin/env bash
source ./core.sh

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function run_unit_tests() {
    echo "Starting unit tests."

    #xcodebuild -workspace WMobileKit.xcworkspace -scheme WMobileKit -sdk iphonesimulator test

    xcodebuild -workspace WMobileKit.xcworkspace -scheme WMobileKit -sdk iphonesimulator test | ocunit2junit

    #xcodebuild clean test -workspace Wdesk.xcworkspace -scheme Wdesk -configuration Debug -destination \
    #"platform=iOS Simulator,name=$1,OS=8.4" GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS SMITHY=1' | ocunit2junit

    unit_test_failure_check
}

function unit_test_failure_check {
    # Due to piping the results into ocunit2junit, $? does not represent testing results
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        print_error "ERROR: iOS unit test failure(s). See above for details."
    fi
}

./setup.sh

run_unit_tests

unit_test_failure_check
