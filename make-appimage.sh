#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:wayland-is-broken.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/touchHLE/touchHLE/refs/heads/trunk/res/icon.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/touchHLE

# Turn AppDir into AppImage
quick-sharun --make-appimage
