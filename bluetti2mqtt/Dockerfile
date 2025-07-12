
# Use Debian-based Home Assistant base image for compatibility
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /


# Install system dependencies (Debian/Ubuntu)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bluez \
        dos2unix \
        git \
        python3-dev \
        python3-pip \
        python3-venv \
        nodejs \
        npm && \
    rm -rf /var/lib/apt/lists/*



# Fix line endings
RUN dos2unix /run.sh

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1


# Create and activate Python virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip and setuptools in venv
RUN /venv/bin/pip install --upgrade pip setuptools wheel

# Install required dependencies in venv
RUN /venv/bin/pip install --no-cache-dir \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1 \
    bleak==0.22.3 \
    crcmod==1.7 \
    asyncio-mqtt==0.12.1

# Set environment variables for better compatibility
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy local project files to /bluetti2mqtt (matching script expectations)
COPY . /bluetti2mqtt

# Test that files are in the right place
RUN ls -la /bluetti2mqtt/ && \
    [ -f /bluetti2mqtt/requirements.txt ] && echo "✓ requirements.txt found" || echo "✗ requirements.txt missing" && \
    [ -f /bluetti2mqtt/setup.py ] && echo "✓ setup.py found" || echo "✗ setup.py missing"

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
