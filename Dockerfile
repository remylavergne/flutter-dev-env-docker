# ====================================================================== #
# Flutter with Android SDK development environment (VNC enabled)
# ====================================================================== #

# Base image
# ---------------------------------------------------------------------- #
FROM ubuntu:18.04

# Author
# ---------------------------------------------------------------------- #
LABEL maintainer "lavergne.remy@gmail.com"

# Graphic environment
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xfce4 xfce4-goodies xfonts-base dbus-x11 git wget unzip

# ============================================================ #
# JDK installation + configuration (openJDK 8)
# ============================================================ #
RUN apt-get install -y --no-install-recommends openjdk-8-jdk && java --version

# ============================================================ #
# Android SDK Manager
# ============================================================ #
ARG COMMAND_LINE_VERSION=6609375
ENV ANDROID_SDK_ROOT /opt/cmdline-tools
RUN cd /opt && mkdir -p cmdline-tools && cd ${ANDROID_SDK_ROOT} && wget https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_VERSION}_latest.zip && unzip commandlinetools-linux*.zip && rm commandlinetools-linux*.zip && export PATH="$PATH:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/bin"

# ============================================================ #
# VNC installation + configuration
# ============================================================ #
ENV USER root
ENV DISPLAY :1
EXPOSE 5901
RUN apt-get update && \
    apt-get install -y --no-install-recommends tightvncserver expect xfonts-100dpi xfonts-75dpi gsfonts-x11
# File to accept VNC installation default option
ADD vncpass.sh /tmp/
RUN chmod +x /tmp/vncpass.sh && /tmp/vncpass.sh
# Add startup behaviour
RUN touch /root/.Xresources && touch /root/.Xauthority
ADD xstartup /root/.vnc/
RUN chmod +x /root/.vnc/xstartup

# Install SDK Flutter
ARG FLUTTER_VERSION=1.17.5
RUN cd /opt && wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && tar -xJvf flutter_linux*.tar.xz && rm flutter_linux*.tar.xz && export PATH="$PATH:/opt/flutter/bin"



# Debug
RUN apt-get install -y vim 