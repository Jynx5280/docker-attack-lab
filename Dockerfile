# Use the official Parrot OS Security image as our base
FROM parrotsec/security

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install a lightweight desktop, VNC, web browser, and essential tools
# Note: The desktop package name is slightly different from Kali's
RUN apt-get update && apt-get install -y --no-install-recommends \
    parrot-desktop-xfce \
    tigervnc-standalone-server \
    novnc \
    websockify \
    firefox-esr \
    openvpn \
    nmap \
    gobuster \
    seclists \
    metasploit-framework \
    && apt-get clean

# Set up the VNC password using a build secret from GitHub Codespaces
# This securely uses the secret without ever writing it into the code or the final image
RUN --mount=type=secret,id=VNC_PASSWORD \
    mkdir -p /root/.vnc && \
    cat /run/secrets/VNC_PASSWORD | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Expose the port for the web-based VNC client
EXPOSE 6080

# Copy our startup script into the container and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# This command will run when the container starts
ENTRYPOINT ["/entrypoint.sh"]
