set -e

echo "Building for the TTWRPlus"
cd /workspaces/openrtx-build/OpenRTX
rm -rf build || true
meson setup build; meson compile -C build openrtx_ttwrplus
