#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	boost		   \
	cargo		   \
	cmake		   \
	libdecor	   \
	openal		   \
	rustup		   \
	sdl2		   \
	ttf-liberation

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ! llvm

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of touchHLE..."
echo "---------------------------------------------------------------"
REPO="https://github.com/touchHLE/touchHLE"
VERSION=$(git ls-remote --tags --refs --sort='v:refname' "$REPO" | tail -n1 | cut -d/ -f3)
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./touchHLE
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./touchHLE
patch -Np1 -i ../touchHLE_cargo_system_sdl2.patch
rustup default stable
export CMAKE_CONFIGURE_FLAGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release"
cargo build --release --all-features
mv -v target/release/touchHLE ../AppDir/bin
mv -v touchHLE_default_options.txt ../AppDir/bin
