#!/usr/bin/env bash
#
# Figure out the current platform.
#
# This is a heuristic because many platforms use different idioms.
#
# The format of the output is:
#
#   <plat>-<dist>-<ver>-<arch>
#   ^      ^      ^     ^
#   |      |      |     +----- architecture: x86_64, i86pc, etc.
#   |      |      +----------- version: 5.5, 6.4, 10.9, etc.
#   |      +------------------ distribution: centos, rhel, nexenta, darwin
#   +------------------------- platform: linux, sunos, macos
#
# Copyright (c) 2018 by Joe Linoff
# MIT Open Source License

# Clean a string.
function _clean() {
    echo "$*" | tr -d '[ \t]' | tr 'A-Z' 'a-z'
}

# Get the distro.
function _get_uplat() {
    local OS_NAME='unknown'
    local OS_ARCH='unknown'
    local DISTRO_NAME='unknown'
    local DISTRO_VERSION='unknown'

    if uname >/dev/null 2>&1 ; then
        # If uname is present we are in good shape.
        # If it isn't present we have a problem.
        OS_NAME=$(uname 1>/dev/null 2>&1 && _clean $(uname) || echo 'unknown')
        OS_ARCH=$(uname -m 1>/dev/null 2>&1 && _clean $(uname -m) || echo 'unknown')
    fi

    case "$OS_NAME" in
        cygwin)
            # Not well tested.
            OS_NAME='linux'
            DISTRO_NAME=$(awk -F- '{print $1}')
            DISTRO_VERSION=$(awk -F- '{print $2}')
            OS_ARCH=$(awk -F- '{print $3}')
            ;;
        darwin)
            # Not well tested for older versions of Mac OS X.
            DISTRO_NAME=$(_clean $(system_profiler SPSoftwareDataType | grep 'System Version:' | awk '{print $3}'))
            DISTRO_VERSION=$(_clean $(system_profiler SPSoftwareDataType | grep 'System Version:' | awk '{print $4}'))
            ;;
        linux)
            if [ -f /etc/centos-release ] ; then
                # centos 6, 7
                DISTRO_NAME='centos'
                DISTRO_VERSION=$(awk '{for(i=1;i<=NF;i++){if($i ~ /^[0-9]/){print $i; break}}}' /etc/centos-release)
            elif [ -f /etc/fedora-release ] ; then
                DISTRO_NAME='fedora'
                DISTRO_VERSION=$(awk '{for(i=1;i<=NF;i++){if($i ~ /^[0-9]/){print $i; break}}}' /etc/fedora-release)
            elif [ -f /etc/redhat-release ] ; then
                # other flavors of redhat.
                DISTRO_NAME=$(_clean $(awk '{print $1}' /etc/redhat-release))
                DISTRO_VERSION=$(awk '{for(i=1;i<=NF;i++){if($i ~ /^[0-9]/){print $i; break}}}' /etc/redhat-release)
            elif [ -f /etc/os-release ] ; then
                # Tested for recent versions of debian and ubuntu.
                if grep -q '^ID=' /etc/os-release ; then
                    DISTRO_NAME=$(_clean $(awk -F= '/^ID=/{print $2}' /etc/os-release))
                    DISTRO_VERSION=$(_clean $(awk -F= '/^VERSION=/{print $2}' /etc/os-release | \
                                                  sed -e 's/"//g' | \
                                                  awk '{print $1}'))
                fi
            fi
            ;;
        sunos)
            # Not well tested.
            OS_NAME='sunos'
            DISTRO_NAME=$(_clean $(uname -v))
            DISTRO_VERSION=$(_clean $(uname -r))
            ;;
        *)
            ;;
    esac
    printf '%s-%s-%s-%s\n' "$OS_NAME" "$DISTRO_NAME" "$DISTRO_VERSION" "$OS_ARCH"
}

_get_uplat
