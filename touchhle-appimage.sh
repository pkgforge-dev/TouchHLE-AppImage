#!/bin/sh

set -eu

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export OUTPUT_APPIMAGE=1
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=TouchHLE-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=DUMMY
export ICON=DUMMY
export DEPLOY_OPENGL=1
export DEPLOY_SDL=1
export DEPLOY_PULSE=1

# ADD LIBRARIES
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/touchHLE

mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist
