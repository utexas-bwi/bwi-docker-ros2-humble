#!/bin/bash

set -e

echo "In the entrypoint script"

while getopts :w:u:n: flag; do
    case "${flag}" in
        w)
          ws=${OPTARG}
          ;;
        u)
          userid=${OPTARG}
          ;;
        n)
          uname=${OPTARG}
          ;;
    esac
done

# Source the given workspace after /opt/ros...
if [ -n "$ws" ]; then
    echo "Updating ~/.bashrc with workspace path"
    echo "source $ws/install/setup.bash" >> ~/.bashrc
fi

# Get host user and ensure they own the projects dir
echo "Setting projects volume owner to $uname $userid"
export uid=${userid%"${userid#????}"}
useradd -u $uid -s /bin/bash -G dialout $uname
chown -R $userid /root/projects

# Source ROS 2 environment
source /opt/ros/humble/setup.bash

# Start a ROS 2 node or any long-running process here
echo "Starting ROS 2..."
# Example command to run, replace with your main node or launch file

### Find a better example to keep the docker container alive here
# Start the talker node as an example
ros2 run demo_nodes_cpp talker &

# Keep the container running
echo "Container is running. Use Ctrl+C to stop."
wait
