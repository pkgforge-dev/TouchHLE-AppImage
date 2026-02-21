#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	android-tools     \
	base-devel        \
	curl              \
	git               \
	libx11            \
	libxrandr         \
	libxss            \
	pulseaudio        \
	pulseaudio-alsa   \
	wget              \
	xorg-server-xvfb  \
	zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano opus-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of touchHLE..."
echo "---------------------------------------------------------------"
REPO="https://github.com/UnknownShadow200/ClassiCube"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./touchHLE
echo "$VERSION" > ~/version

