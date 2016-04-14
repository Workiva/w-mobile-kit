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

function clean_previous_build {
    echo "Cleaning up from previous build."
    find . -name "*.gcda" -print0 | xargs -0 rm
    killall "WMobileKit"; sleep 2
    osascript reset-sim.applescript; sleep 5; killall 'Simulator'; sleep 5
}

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
open -a Simulator --args -CurrentDeviceUDID 3B6E0ECB-4650-49E5-BBA3-9C4B86D9FA73; sleep 3
run_unit_tests

echo "Exiting with status: $?"
