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

# ====================================================================== #
# JDK installation + configuration (openJDK 8)
# ====================================================================== #
RUN apt-get install -y --no-install-recommends openjdk-8-jdk

# ====================================================================== #
# Gradle
# ====================================================================== #
# https://services.gradle.org/distributions/
ARG GRADLE_VERSION=6.4.1
ARG GRADLE_DIST=bin
RUN cd /opt && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-${GRADLE_DIST}.zip && \
    unzip gradle*.zip && \
    ls -d */ | sed 's/\/*$//g' | xargs -I{} mv {} gradle && \
    rm gradle*.zip

# ====================================================================== #
# Kotlin compiler
# ====================================================================== #
# https://github.com/JetBrains/kotlin/releases/latest
ARG KOTLIN_VERSION=1.3.72
RUN cd /opt && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
    unzip *kotlin*.zip && \
    rm *kotlin*.zip

# ====================================================================== #
# Android SDK Manager
# ====================================================================== #
ARG COMMAND_LINE_VERSION=6609375
ENV ANDROID_SDK_ROOT /opt/android
RUN cd /opt && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_VERSION}_latest.zip && \
    unzip commandlinetools-linux*.zip && \
    rm commandlinetools-linux*.zip

# ====================================================================== #
# VNC installation + configuration (TightVNC)
# ====================================================================== #
ENV USER root
ENV DISPLAY :1
EXPOSE 5901
RUN apt-get update && \
    apt-get install -y --no-install-recommends tightvncserver expect xfonts-100dpi xfonts-75dpi gsfonts-x11 xz-utils
# File to accept VNC installation default option
ADD vncpass.sh /tmp/
RUN chmod +x /tmp/vncpass.sh && /tmp/vncpass.sh
# Add startup behaviour
RUN touch /root/.Xresources && touch /root/.Xauthority
ADD xstartup /root/.vnc/
RUN chmod +x /root/.vnc/xstartup
# RUN vncserver

# ====================================================================== #
# Install SDK Flutter
# ====================================================================== #
ARG FLUTTER_VERSION=1.17.5
RUN cd /opt && wget -q https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
RUN cd /opt && tar -xf flutter_linux*.tar.xz && rm flutter_linux*.tar.xz 

# ENV 
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_HOME /opt/gradle
ENV KOTLIN_HOME /opt/kotlinc
ENV FLUTTER_HOME /opt/flutter
ENV PATH ${PATH}:${GRADLE_HOME}/bin:${KOTLIN_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin
ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
# WORKAROUND: for issue https://issuetracker.google.com/issues/37137213
ENV LD_LIBRARY_PATH ${ANDROID_SDK_ROOT}/emulator/lib64:${ANDROID_SDK_ROOT}/emulator/lib64/qt/lib
# patch emulator issue: Running as root without --no-sandbox is not supported. See https://crbug.com/638180.
# https://doc.qt.io/qt-5/qtwebengine-platform-notes.html#sandboxing-support
ENV QTWEBENGINE_DISABLE_SANDBOX 1

# ====================================================================== #
# Install Android tools
# ====================================================================== #
RUN yes | sdkmanager --licenses && yes | sdkmanager --update
RUN cd ${ANDROID_SDK_ROOT} && sdkmanager "platform-tools"
RUN cd ${ANDROID_SDK_ROOT} && sdkmanager "platforms;android-28" 
RUN cd ${ANDROID_SDK_ROOT} && sdkmanager "build-tools;28.0.3"
RUN cd ${ANDROID_SDK_ROOT} && sdkmanager "emulator"
RUN cd ${ANDROID_SDK_ROOT} && sdkmanager "system-images;android-28;google_apis;x86"

# ====================================================================== #
# Install Flutter tools
# ====================================================================== #
#RUN flutter emulators --create --name my_emulator

##########################################
# Debug tools ############################
##########################################
RUN apt-get install -y vim cpu-checker

#### TODO #####
# Avoir un émulateur x86...