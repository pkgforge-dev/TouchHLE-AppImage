#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/touchHLE/touchHLE/refs/heads/trunk/res/icon.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/touchHLE #/usr/share/touchhle
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here
#mkdir -p ./AppDir/bin/touchHLE_fonts
#cp -v /usr/share/fonts/liberation/LiberationSans-Bold.ttf ./AppDir/bin/touchHLE_fonts
#cp -v /usr/share/fonts/liberation/LiberationSans-Italic.ttf /AppDir/bin/touchHLE_fonts
#cp -v /usr/share/fonts/liberation/LiberationSans-Regular.ttf /AppDir/bin/touchHLE_fonts

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
