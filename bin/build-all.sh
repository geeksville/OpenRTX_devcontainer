set -e

# a crude script to just build all of the ttpwr binaries

if [ ! -d ".west" ]; then
  echo "Fetching reference OpenRTX repo..."
  west init -m https://github.com/geeksville/OpenRTX.git --mr dev
fi
west update
source zephyr/zephyr-env.sh # You need to execute this for every new shell

cd OpenRTX
rm -rf build || true
meson setup build; meson compile -C build openrtx_ttwrplus