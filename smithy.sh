#!/usr/bin/env bash
source ./core.sh

# Will fail if coverage drops below the threshold
code_coverage_threshold=90

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function run_unit_tests() {
    echo
    echo "Starting $1 unit tests."

    xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    "platform=iOS Simulator,name=$1,OS=8.4" -enableCodeCoverage YES | ocunit2junit

    unit_test_failure_check
}

function unit_test_failure_check {
    # Due to piping the results into ocunit2junit, $? does not represent testing results
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        print_error "ERROR: iOS unit test failure(s). See above for details."
    fi
}

function clean_previous_build {
    echo
    echo "Cleaning up from previous build."
    find . -name "*.gcda" -print0 | xargs -0 rm
    killall "WMobileKit"; sleep 2
    killall 'Simulator'; sleep 2
    xcrun simctl erase all; sleep 2
}

function archive_code_coverage {
    echo
    echo "Archiving code coverage reports."
    mkdir code_coverage
    zip -r -X code_coverage/coverage.zip xcov
}

./build.sh

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo
echo "Starting iPad Simulator."
open -a Simulator --args -CurrentDeviceUDID 7BE2512A-6B44-4FFF-96A8-60BF0D7269A1; sleep 3
run_unit_tests "iPad Retina"

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo
echo "Starting iPhone Simulator."
open -a Simulator --args -CurrentDeviceUDID 5E5091B3-63F2-4C60-8FF8-E30BBEC8383B; sleep 3
run_unit_tests "iPhone 5"

echo
echo "Generating code coverage report"
xcov -m $code_coverage_threshold -w WMobileKit.xcworkspace -s WMobileKit -o xcov

# If code coverage is not at least the minimum, stop here.
if [ $? -ne 0 ]; then
  archive_code_coverage
  print_error "ERROR: Code coverage failed. Needs to be at least $code_coverage_threshold%. See above for details."
fi

archive_code_coverage

echo "Exiting with status: $?"
