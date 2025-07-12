
# Use Alpine-based Home Assistant base image for compatibility
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Copy requirements.txt to the app directory
COPY requirements.txt /bluetti2mqtt/requirements.txt

# Install system dependencies (Alpine Linux) - minimal for Bluetooth support
RUN apk add --no-cache \
        bluez \
        dbus \
        git \
    && mkdir -p /var/run/dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id

# Set environment variables for better compatibility
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Create directory structure
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
