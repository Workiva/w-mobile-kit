#!/usr/bin/env bash
source ./core.sh

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function run_unit_tests() {
    echo "Starting $1 unit tests."

    #xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    #"platform=iOS Simulator,name=$1,OS=8.4" -enableCodeCoverage YES | ocunit2junit

    xcodebuild test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    "platform=iOS Simulator,name=$1,OS=8.4" | ocunit2junit

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
    killall 'Simulator'; sleep 5
    xcrun simctl erase all; sleep 5
}

echo "Setting up project."
echo
./setup.sh

# We need to open the workspace to make sure the schemes have been generated.
echo
echo "Generating schemes."
echo
killall Xcode
open "WMobileKit.xcworkspace"
sleep 5
killall Xcode

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo "Starting iPad Simulator."
open -a Simulator --args -CurrentDeviceUDID 7BE2512A-6B44-4FFF-96A8-60BF0D7269A1; sleep 3
run_unit_tests "iPad Retina"

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo "Starting iPhone Simulator."
open -a Simulator --args -CurrentDeviceUDID 5E5091B3-63F2-4C60-8FF8-E30BBEC8383B; sleep 3
run_unit_tests "iPhone 5"

#echo "Generating code coverage report"
#xcov -w WMobileKit.xcworkspace -s WMobileKit -o xcov
#mkdir code_coverage
#zip -r -X code_coverage/coverage.zip xcov

echo "Exiting with status: $?"
