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
	sdl2

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
patch -Np1 -i ../touchhle_cargo_system_sdl2.patch
rustup default stable
cat << 'EOF' > ./cmake_wrapper
#!/bin/sh
if [ "$1" = "--build" ]; then
    /usr/bin/cmake "$@"
else
    /usr/bin/cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "$@"
fi
EOF
chmod +x ./cmake_wrapper
export CMAKE="$(pwd)/cmake_wrapper"
export SDL2_CONFIG_PATH=/usr/bin/sdl2-config
cargo build --release --no-default-features
mv -v target/release/touchHLE ../AppDir/bin
mv -v touchHLE_default_options.txt ../AppDir/bin/options.txt
find touchHLE_fonts -maxdepth 1 -type f \( -name "LICENSE.*" -o -name "README.md" \) -delete
find touchHLE_dylibs -maxdepth 1 -type f \( -name "COPYING.*" -o -name "README.md" \) -delete
mv -v touchHLE_fonts ../AppDir/bin
mv -v touchHLE_dylibs ../AppDir/bin
