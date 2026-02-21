#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=PATH_OR_URL_TO_ICON
export DESKTOP=PATH_OR_URL_TO_DESKTOP_ENTRY
export DEPLOY_OPENGL=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/touchHLE /usr/share/touchhle

# Additional changes can be done in between here
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist


# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
