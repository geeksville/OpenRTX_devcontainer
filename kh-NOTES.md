## Build setup

* per https://openrtx.org/#/compiling?id=building-openrtx-from-sources
* https://openrtx.org/#/compiling?id=building-openrtx-from-sources
* https://docs.zephyrproject.org/latest/develop/getting_started/installation_linux.html
* latest cmake: https://apt.kitware.com/ 

## To fix build missing dependency

apt install python3-pykwalify
pipx inject west pyserial pyelftools

## To setup ESP tools so they work with zephyr 

ESP_IDF_PATH was not set for some reason
per https://wiki.amarulasolutions.com/opensource/zephyr/esp32/esp32-setup.html

~/packages$ git clone --recursive https://github.com/espressif/esp-idf.git
~/packages/esp-idf$ ./install.sh all
All done! You can now run:

  . ./export.sh


```
export ZEPHYR_TOOLCHAIN_VARIANT="espressif"
export ESPRESSIF_TOOLCHAIN_PATH="${HOME}/.espressif/tools/xtensa-esp32-elf/esp-2021r2-8.4.0/xtensa-esp32-elf/"
export ESP_IDF_PATH="${HOME}/packages/esp-idf"
```

```
mkdir openrtx-build && cd $_
west init -m https://github.com/geeksville/OpenRTX
west update
source zephyr/zephyr-env.sh # You need to execute this for every new shell
```

To do a build
```
~/development/openrtx-build/OpenRTX$ rm -rf build; meson setup build; meson compile -C build openrtx_ttwrplus_uf2
The Meson build system
Version: 1.7.0
Source dir: /home/kevinh/development/openrtx-build/OpenRTX
Build dir: /home/kevinh/development/openrtx-build/OpenRTX/build
Build type: native build
Project name: OpenRTX
Project version: 0.3.6
C compiler for the host machine: ccache cc (gcc 14.2.0 "cc (Ubuntu 14.2.0-4ubuntu2) 14.2.0")
C linker for the host machine: cc ld.bfd 2.43.1
C++ compiler for the host machine: ccache c++ (gcc 14.2.0 "c++ (Ubuntu 14.2.0-4ubuntu2) 14.2.0")
C++ linker for the host machine: c++ ld.bfd 2.43.1
Host machine cpu family: x86_64
Host machine cpu: x86_64
```

to build and flash bootloader
```
cd $ZEPHYR_PATH/zephyr
source zephyr-env.sh
west build -p always -b esp32s3_devkitm --sysbuild samples/hello_world
west flash
```

to setup devcontainer: https://code.visualstudio.com/docs/devcontainers/containers
https://www.zellaco.se/insights/building-zephyr-within-a-development-container-in-visual-code 
https://www.stefanocottafavi.com/embedded/vscode_zephyr_docker/ 
https://blog.golioth.io/build-before-installing-zephyr-dev-environment-using-codespaces/ 

how to rebuild dependencies: https://stackoverflow.com/questions/75780051/where-did-the-vscode-rebuild-container-command-go
how to use custom docker image in devcontainer: https://stackoverflow.com/questions/77128650/how-to-manage-many-depdencies-with-devcontainers 
use 'post create' command to add extra dependencies to devcontainer: https://stackoverflow.com/questions/74390179/install-additional-packages-in-vscode-dev-container 

## docker stuff

https://docs.docker.com/engine/install/ubuntu/

use docker desktop context for all CLI commands

docker context use desktop-linux

delete all local contexts: docker rm -v $(docker ps -qa)

## west in docker stuff

no need to source zephyr-env.sh?
"west init -l <localdir>"

get openocd from https://github.com/espressif/openocd-esp32
https://github.com/espressif/openocd-esp32/releases
then debug with 'west debug --openocd `which openocd-esp32openocd`'
