
# zephyr-build is quite large and adds some nice GUI addons etc... but for now we use the
# ci version instead so we can stay below the 15GB limit for github codespaces.
# FROM zephyrprojectrtos/zephyr-build:v0.27.4
FROM zephyrprojectrtos/ci:v0.27.4

# We use 'user' as the name to match what the zhephyr-build image already created
ARG USERNAME=user
ARG WORKSPACE=workspace

## Setup a user with sudo support
USER root

RUN apt update
RUN apt install -y less git pkg-config build-essential libsdl2-dev libcodec2-dev libreadline-dev

# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
RUN apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Get the radio_tool and install it (using the last built release from the git repo)
RUN cd /tmp \
    && wget https://github.com/v0l/radio_tool/releases/download/v0.2.2/radio_tool-0.2.2-Linux.deb \
    && sudo dpkg -i radio_tool-0.2.2-Linux.deb

# This tool is apparently needed for the non ttpwr radios...
RUN cd /tmp \
    && wget https://miosix.org/toolchain/MiosixToolchainInstaller.run \
    && sh MiosixToolchainInstaller.run

# We expose the full hostos /dev tree (to allow podman to see hotplugged USB devices such as /host/dev/ttyACM0)
RUN mkdir -p /host/dev

# Let the user access ttyUSB devices (can't work on podman, but will work for docker)
RUN usermod -a -G dialout $USERNAME

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# Add the workspace bin to the path (must be done after setting user)
ENV PATH="${WORKSPACE}/bin:$PATH"

# Add .local/bin to the user's path - because we will install meson and ninja there
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# The pip version included in the zephyr-build image might be old
RUN python3 -m pip install --upgrade pip

RUN pip3 install --user meson ninja
