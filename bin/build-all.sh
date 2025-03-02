set -e

# a crude script to just build all of the ttpwr binaries
cd /workspaces/openrtx-build

if [ ! -d ".west" ]; then
  echo "Fetching reference OpenRTX repo..."
  west init -m https://github.com/geeksville/OpenRTX.git --mr dev
fi
west update
source zephyr/zephyr-env.sh # You need to execute this for every new shell

ARMTARGET=mod17
echo "Building for the $ARMTARGET"
cd OpenRTX
rm -rf build || true
meson setup --cross-file cross_arm.txt build_arm
meson compile -C build_arm openrtx_$ARMTARGET
cd ..

echo "Linux emulator build disabled FIXME"
# doesn't work yet due to /usr/bin/ld: /usr/lib/i386-linux-gnu/libSDL2.so: error adding symbols: file in wrong format
# I think because the lib is 386 only and the rest of the build is amd64?
# meson setup build_linux
# meson compile -C build_linux openrtx_linux

echo "Building for the TTWRPlus"
cd OpenRTX
rm -rf build || true
meson setup build; meson compile -C build openrtx_ttwrplus
cd ..