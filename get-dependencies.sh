#!/bin/sh

set -eu

EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"
PACKAGE_BUILDER="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/make-aur-package.sh"

echo "Installing build dependencies..."
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
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-opengl --prefer-nano opus-mini

echo "Building touchhle..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$PACKAGE_BUILDER" -O ./make-aur-package.sh
chmod +x ./make-aur-package.sh
./make-aur-package.sh touchhle

# share/touchhle/fonts contains symlinks to /usr/share/fonts instead of the real thing
for L in $(find /usr/share/touchhle/fonts -type l); do
	linkpath=$(readlink "$L")
	rm -f "$L"
	cp -v "$linkpath" /usr/share/touchhle/fonts
done

pacman -Q touchhle | awk '{print $2; exit}' > ~/version
