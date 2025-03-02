set -e

# a crude script to just build all of the ttpwr binaries

mkdir openrtx-build || true
cd openrtx-build
west init -m https://github.com/geeksville/OpenRTX.git --mr dev
west update
source zephyr/zephyr-env.sh # You need to execute this for every new shell