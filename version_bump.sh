#!/bin/sh
source core.sh

function usage {
    echo "${underline}${bold}Usage${normal}"
    echo "    ./version_bump.sh current_version new_version"
    echo
    echo "${underline}${bold}Example${normal}"
    echo "    ./version_bump.sh 2.6.0 2.6.1"
}

# Usage: updateVersion $arg1 $arg2
function updateVersion {
    print_heading "Updating version from $1 to $2"
    # Spaces are necessary
    sed -i "" -E "s/s.version          = '$1'/s.version          = '$2'/g" WMobileKit.podspec

    sed -i "" -E "s/<string>$1<\/string>/<string>$2<\/string>/g" Source/Info.plist

    sed -i "" -E "s/<string>$1<\/string>/<string>$2<\/string>/g" Example/WMobileKitExample/Info.plist
}

function updatePods {
    print_heading "Updating Pods for new version"
    ./setup.sh
}

if [[ "$#" -lt 1 ]] ; then
    usage
else
    updateVersion $1 $2
    updatePods
fi
