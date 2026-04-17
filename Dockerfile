FROM ubuntu:24.04

# Install SSH server and common tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    git \
    vim \
    htop \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo "root:nafij@67" | chpasswd

# Configure SSH: run on port 2222, enable password auth and gateway ports
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak \
    && sed -i 's/^#\s*Port.*/Port 2222/' /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
    && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config

# Create required SSH runtime directory
RUN mkdir -p /var/run/sshd

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D"]

