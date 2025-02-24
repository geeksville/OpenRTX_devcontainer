FROM zephyrprojectrtos/zephyr-build:v0.27.4
# v0.27.4 v026.18 0.26.9, v0.25.1 also no good (fails wrt PATH)
# v0.24.12 failed because tools were too old

## Setup a user with sudo support
USER root

RUN apt update
RUN apt install -y gdb less git pkg-config build-essential libcodec2-dev

# We use 'user' as the name to match what the zhephyr-build image already created
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
RUN apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Let the user access ttyUSB devices
RUN usermod -a -G dialout $USERNAME

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# Add .local/bin to the user's path - because we will install meson and ninja there
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# The pip version included in the zephyr-build image might be old
RUN python3 -m pip install --upgrade pip

RUN pip3 install --user meson ninja
