#!/bin/bash
# Start VNC server on display :1 with a 1080p resolution
vncserver :1 -geometry 1920x1080 -depth 24

# Start the noVNC web server, which provides browser access to the VNC session
websockify -D --web=/usr/share/novnc/ 6080 localhost:5901

# This keeps the container running indefinitely
tail -f /dev/null
