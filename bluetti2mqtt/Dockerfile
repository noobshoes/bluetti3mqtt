
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

# Copy all files first, then organize them
COPY . /tmp/build/

# Move the required files to the correct locations
RUN mkdir -p /bluetti2mqtt && \
    cp /tmp/build/requirements.txt /bluetti2mqtt/ 2>/dev/null || echo "requirements.txt not found in /tmp/build/" && \
    cp /tmp/build/setup.py /bluetti2mqtt/ 2>/dev/null || echo "setup.py not found in /tmp/build/" && \
    cp -r /tmp/build/bluetti_mqtt /bluetti2mqtt/ 2>/dev/null || echo "bluetti_mqtt/ not found in /tmp/build/" && \
    ls -la /tmp/build/ && \
    echo "Contents copied to /bluetti2mqtt:" && \
    ls -la /bluetti2mqtt/

# Test that files are in the right place
RUN [ -f /bluetti2mqtt/requirements.txt ] && echo "✓ requirements.txt found" || echo "✗ requirements.txt missing" && \
    [ -f /bluetti2mqtt/setup.py ] && echo "✓ setup.py found" || echo "✗ setup.py missing" && \
    [ -d /bluetti2mqtt/bluetti_mqtt ] && echo "✓ bluetti_mqtt/ directory found" || echo "✗ bluetti_mqtt/ directory missing"

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
