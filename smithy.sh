#!/usr/bin/env bash
source ./core.sh

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function run_unit_tests() {
    echo "Starting unit tests."

    # xcodebuild -workspace WMobileKit.xcworkspace -scheme WMobileKit -enableCodeCoverage YES -sdk iphonesimulator test | ocunit2junit
xcodebuild -workspace WMobileKit.xcworkspace -scheme WMobileKit -enableCodeCoverage YES -sdk iphonesimulator test
    unit_test_failure_check | ocunit2junit
}

function run_unit_tests2() {
    echo "Starting $1 unit tests."
    #xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    #"platform=iOS Simulator,name=$1,OS=8.4" | ocunit2junit

    xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    "platform=iOS Simulator,name=$1,OS=8.4" | ocunit2junit

#xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination "platform=iOS Simulator,name=iPad Retina,OS=8.4"

    echo "Unit tests finished running"

echo "Checking for failure"
    unit_test_failure_check
    echo "End check for failure"
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
    killall 'Simulator'; sleep 5
    xcrun simctl erase all; sleep 5
    echo "Clean finished"
    #osascript -e reset-sim.applescript; sleep 5; killall 'Simulator'; sleep 5
}

./setup.sh

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
#clean_previous_build
#open -a Simulator --args -CurrentDeviceUDID 3B6E0ECB-4650-49E5-BBA3-9C4B86D9FA73; sleep 3
#run_unit_tests

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
open -a Simulator --args -CurrentDeviceUDID 7BE2512A-6B44-4FFF-96A8-60BF0D7269A1; sleep 3
echo "Simulator open"

run_unit_tests2 "iPad Retina"
echo "Unit tests done"

clean_previous_build
open -a Simulator --args -CurrentDeviceUDID 5E5091B3-63F2-4C60-8FF8-E30BBEC8383B; sleep 3
run_unit_tests2 "iPhone 5"

echo "Trying other way"
clean_previous_build
open -a Simulator --args -CurrentDeviceUDID 5E5091B3-63F2-4C60-8FF8-E30BBEC8383B; sleep 3
run_unit_tests

echo "Exiting with status: $?"
