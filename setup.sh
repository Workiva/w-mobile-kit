#!/bin/bash

# Ensure correct dependencies are installed
bundle install
echo
# Install pods for the Framework
echo "Installing pods for framework"
echo
bundle exec pod install
echo

cd ./Example
# Install pods for example project
echo
echo "Installing pods for example project"
echo
bundle exec pod install

cd -
