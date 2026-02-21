#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	android-tools \
	cargo		  \
	libdecor	  \
	rust		  \
	sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano opus-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of touchHLE..."
echo "---------------------------------------------------------------"
REPO="https://github.com/UnknownShadow200/ClassiCube"
VERSION=$(git ls-remote --tags --sort='v:refname' "$REPO" | tail -n1 | cut -d/ -f3)
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./touchHLE
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./touchHLE
cargo build --release --all-features
mv -v target/release/touchHLE ../AppDir/bin
mv -v touchHLE_default_options.txt ../AppDir/bin
