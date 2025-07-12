
# Use Debian-based Home Assistant base image for compatibility
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /


# Install system dependencies (Alpine Linux)
RUN apk add --no-cache \
        bluez \
        dos2unix \
        git \
        python3-dev \
        nodejs \
        npm



# Fix line endings
RUN dos2unix /run.sh

# Set environment variables for better compatibility
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Create directory structure and install bluetti_mqtt from GitHub
RUN mkdir -p /bluetti2mqtt

# Install bluetti_mqtt from nano2dev GitHub repository directly into venv at runtime
# This ensures we have the module available regardless of local file issues
RUN echo '#!/bin/bash' > /install_bluetti.sh && \
    echo 'if [ ! -f /venv/lib/python3.10/site-packages/bluetti_mqtt/__init__.py ]; then' >> /install_bluetti.sh && \
    echo '  echo "Installing bluetti_mqtt from GitHub..."' >> /install_bluetti.sh && \
    echo '  /venv/bin/pip install --no-cache-dir git+https://github.com/nano2dev/bluetti_mqtt.git' >> /install_bluetti.sh && \
    echo 'else' >> /install_bluetti.sh && \
    echo '  echo "bluetti_mqtt already installed"' >> /install_bluetti.sh && \
    echo 'fi' >> /install_bluetti.sh && \
    chmod +x /install_bluetti.sh

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
