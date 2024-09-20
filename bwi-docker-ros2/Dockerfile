# Use the latest devel image with cudnn for all the CUDA bells n whistles
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
SHELL ["/bin/bash", "-c"]

# Set the ROS2 version
ENV ROS_DISTRO humble
ENV UDEV=1

# Install essential tools and utilities
RUN apt-get update &&\
    apt-get -y install apt-utils curl nano vim tmux python3-pip lsb-release gnupg2 \
    && echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Update and install ROS2 desktop full and other dependencies
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    ros-${ROS_DISTRO}-desktop python3-rosdep python3-colcon-common-extensions \
    python3-rosinstall python3-rosinstall-generator python3-vcstool build-essential \
    libqt5websockets5-dev qtbase5-dev &&\
    pip3 install -U pyYAML &&\
    rosdep init && rosdep update --include-eol-distros

# Source ROS2 environment
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# Switch to home directory
WORKDIR /root

# Clone the AMRL messages repository (adjust if you're using ROS 2 packages)
RUN git clone https://github.com/ut-amrl/amrl_msgs.git
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && cd amrl_msgs && colcon build

# Install software properties for adding repositories and dependencies
RUN apt-get update && apt-get -y install software-properties-common

# Install NVIDIA Docker support and X11 libraries
RUN apt-get update && apt-get clean && apt-get install -y --no-install-recommends \
    libxau-dev libxdmcp-dev libxcb1-dev libxext-dev libx11-dev mesa-utils x11-apps

# NVIDIA Container Runtime settings
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Install additional dependencies for the Kinect or other hardware (example)
# Example: Azure Kinect ROS wrapper (adjust to your use case)
# RUN apt-get update && apt-get -y install ros-${ROS_DISTRO}-kinect-ros-driver

# copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# run this script on startup
ENTRYPOINT /entrypoint.sh