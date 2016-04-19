#!/usr/bin/env bash
source ~/.bashrc

echo
echo "Building project."
echo
./setup.sh

# If something went wrong with the build, stop here.
if [ $? -ne 0 ]; then
  print_error "ERROR: Build failed. See above for details."
fi
