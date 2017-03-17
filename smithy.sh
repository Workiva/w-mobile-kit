#!/usr/bin/env bash
source ./core.sh

# Will fail if coverage drops below the threshold
code_coverage_threshold=90

# Make sure we're using the rbenv version of ruby
PATH="$(cd ~/; pwd)/.rbenv/shims:$(cd ~/; pwd)/.rbenv/bin:$PATH"

function build_example_app() {
    print_heading "Building example app"

    cd Example

    xcodebuild -workspace WMobileKitExample.xcworkspace -scheme WMobileKit-Example -configuration Debug

    # Error out if the example app does not build properly
    if [ $? -ne 0 ]; then
        print_error "ERROR: Unable to build example app. See above for details."
    fi

    cd ..
}

function run_unit_tests() {
    print_heading "Starting $1 unit tests."

    xcodebuild clean test -workspace WMobileKit.xcworkspace -scheme WMobileKit -configuration Debug -destination \
    "platform=iOS Simulator,name=$1,OS=10.0" -enableCodeCoverage YES | ocunit2junit

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
    echo "Going to kill Simulator"
    killall Simulator
    # Ensure it's dead
    while [ $? -ne 1 ]; do
        sleep 3; killall Simulator
    done
    xcrun simctl erase all
}

function archive_code_coverage {
    print_heading "Archiving code coverage reports."
    mkdir code_coverage
    zip -r -X code_coverage/coverage.zip xcov
}

# Validate library status
./build.sh

print_heading "Validating WMobileKit.podspec"
bundle exec pod lib lint WMobileKit.podspec --allow-warnings
if [ $? -ne 0 ]; then
    print_error "ERROR: Library validation failed. Verify WMobileKit.podspec."
fi

# Verify example app builds properly
build_example_app

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo
echo "Starting iPad Air 2 Simulator."
run_unit_tests "iPad Air 2"

# Running unit tests, we need to open the simulator to make sure xcodebuild knows that it is open.
clean_previous_build
echo
echo "Starting iPhone 7 Simulator."
run_unit_tests "iPhone 7"

# Clean up and ensure the sim is killed
clean_previous_build

print_heading "Generating code coverage report"
bundle exec xcov -m 90 -w WMobileKit.xcworkspace -s WMobileKit -o xcov  \
    --exclude_targets 'SDWebImage.framework, Nimble.framework, SnapKit.framework, CryptoSwift.framework, Quick.framework'

# If code coverage is not at least the minimum, stop here.
if [ $? -ne 0 ]; then
    archive_code_coverage
    print_error "ERROR: Code coverage failed. Needs to be at least $code_coverage_threshold%. See above for details."
fi

archive_code_coverage

echo "Exiting with status: $?"
