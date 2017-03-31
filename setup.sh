#!/bin/bash

function update_pods() {
  bundle exec pod install --repo-update
}

# Ensure correct dependencies are installed
gem install bundler

bundle install
echo
# Install pods for the Framework
echo "Installing pods for framework"
echo
update_pods
echo

cd ./Example
# Install pods for example project
echo
echo "Installing pods for example project"
echo
update_pods

cd -
