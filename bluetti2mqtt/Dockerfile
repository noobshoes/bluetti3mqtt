
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

# Copy local project files to /bluetti2mqtt (matching script expectations)
COPY requirements.txt /bluetti2mqtt/
COPY setup.py /bluetti2mqtt/
COPY bluetti_mqtt/ /bluetti2mqtt/bluetti_mqtt/

# Test that files are in the right place
RUN ls -la /bluetti2mqtt/ && \
    [ -f /bluetti2mqtt/requirements.txt ] && echo "✓ requirements.txt found" || echo "✗ requirements.txt missing" && \
    [ -f /bluetti2mqtt/setup.py ] && echo "✓ setup.py found" || echo "✗ setup.py missing" && \
    [ -d /bluetti2mqtt/bluetti_mqtt ] && echo "✓ bluetti_mqtt/ directory found" || echo "✗ bluetti_mqtt/ directory missing"

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
