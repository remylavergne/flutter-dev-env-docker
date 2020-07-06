# ====================================================================== #
# Flutter with Android SDK development environment (VNC enabled)
# ====================================================================== #

# Base image
# ---------------------------------------------------------------------- #
FROM ubuntu:20.10

# Author
# ---------------------------------------------------------------------- #
LABEL maintainer "lavergne.remy@gmail.com"

# Graphic environment
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xfce4 xfce4-goodies xfonts-base dbus-x11

# Install VNC
ENV USER root
ENV DISPLAY :1
EXPOSE 5901
RUN apt-get update && \
    apt-get install -y --no-install-recommends tightvncserver expect

# File to accept VNC installation default option
ADD vncpass.sh /tmp/
RUN chmod +x /tmp/vncpass.sh && /tmp/vncpass.sh

# Add startup behaviour
# RUN mkdir ~/.vnc
RUN ls -l
ADD xstartup root/.vnc/
RUN chmod +x root/.vnc/xstartup

RUN vncserver

# Config vncserver
#RUN vncserver