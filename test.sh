#!/bin/bash
#
# Use docker for testing.
#
PS4='$(printf "+ \033[38;5;245m%-20s\033[0m " "${BASH_SOURCE[0]}:${LINENO}:")'
set -x
PLATS=(
    centos:5
    centos:6
    centos:7
    debian
    fedora
    ubuntu
)
./uplat.sh
for PLAT in ${PLATS[@]} ; do
    docker run -it --init --rm -v $(pwd):/mnt $PLAT /mnt/uplat.sh
done
