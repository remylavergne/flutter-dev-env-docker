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
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xfce4 xfce4-goodies xfonts-base dbus-x11

# Install VNC
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

# RUN vncserver

# Config vncserver
#RUN vncserver

# Debug
RUN apt-get install -y vim 