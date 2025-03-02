# A devcontainer for building OpenRTX

NOTE: Eventually this might be useful to refactor and merge into the openrtx tree (because it 
guarantees repeatable reference builds for any user/dev and removes all variablity from the host
build environment).  

Currently this is just a proof of concept...  But it is my 'live' build environment, so as I actually start working on real code, this should still stay working.

## About this proof of concept

Ok thanks to the ptrs from @edgetriggered I've got my build working (yay).  In the process I made a "devcontainer" which might be useful for ya'll in the future.  Devcontainers are great because:

* they make the build environment totally portable/repeatable.  So you can tell new devs 'here's a reference build environment that is guaranteed to work for you - including all the tools needed to build, flash, debug etc...' And you don't need to worry about what the host OS or environment the dev has.
* devcontainers work easily from inside of github actions to automatically do CI on pull-requests, generate release binaries etc...
* The major IDEs all now support devcontainers
* provides a documented/structured/guaranteed-correct set of instructions on how to build
* very low performance cost (especially if the host OS is linux, in which case the cost is almost zero)
* Even works 'on the web' from inside of a cloud hosted "codespaces" included in the free github tier.  So if you have curious proto devs you can just say: go to this repo and click "start codespace" (though see below)

I based this container (for now) on the edgetriggered PR for ttpwr and the official latest zephyr docker container.  For now it is in a separate little repo with an extra test "build-all.sh" script included in the path - which fetches a proper OpenRTX tree and uses that for development.  Eventually you (we?) could add it to the OpenRTX project itself and then if users open the project in a supported IDE they would get autoprompted "would you like to open this in a devcontainer environment?"

### Running this devcontainer locally

If you'd like to try this proof-of-concept on your own machine:

* Clone https://github.com/geeksville/OpenRTX_devcontainer locally somewhere
* cd into it
* Run vscode "code ." or most other 'big' IDEs also support devcontainers automatically
* It should (I think) ask you if you want to install the devcontainer goo.  Say yes.
* It will fetch a bunch of stuff (only slow the first time) - you can click in the bottom right to see progress.
* Inside of the vscode window choose "new terminal" 
* Type "build-all.sh" (which runs the small ugly script sitting in the bin dir of this repo)
* It should fetch a patched version of the edgetriggered PR and build an app image.

### Trying out this dev environment in a (free) webhosted github Codespace

(Usually you don't want this but...) This can be an easy way to "try building this project from scratch, myself" without having to set-up a local build environment.  It runs an instance of VSCode "in the cloud."

If you'd like to try it yourself go here in your browser: https://github.com/geeksville/OpenRTX_devcontainer
Then click on Code... / Codespaces... / Create a codespace on main...

![Creating codespace](doc/codespace.png?raw=true "Creating codespace")

Note: the first time you do this it will be **VERY slow** (on the github free tier it can be many minutes) to open.  This is especially true if your github region hasn't cached all of the various dependencies.
To see progress: can click on "Building codespace..." in the bottom right. 
For future sessions if you'd like to keep using the same web based codespace it will be quite fast to reopen.

After the codespace opens, click in the bottom right of the vscode window and type "build-all.sh" you should see something like this:

![codespace](doc/codespaceinner.png?raw=true "Starting build")

And then...

![codespace2](doc/codespace2.png?raw=true "Build finished")

## Build setup

Misc private notes @geeksville is keeping for himself follow...

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

or if cloning from edgetriggered

mkdir openrtx-build && cd $_
west init -m https://github.com/edgetriggered/openrtx --mr ttwrplus
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
