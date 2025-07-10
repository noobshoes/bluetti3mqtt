ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Install system dependencies
RUN apk add --no-cache \
    bluez \
    dos2unix \
    git \
    python3-dev \
    py3-pip \
    nodejs \
    npm


# Fix line endings
RUN dos2unix /run.sh

# Set environment variables for better compatibility
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install Python dependencies with compatibility fixes
RUN pip install --upgrade pip setuptools wheel

# Install required dependencies first
RUN pip install --no-cache-dir \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1 \
    bleak==0.22.3 \
    crcmod==1.7 \
    asyncio-mqtt==0.12.1



# Install bluetti_mqtt from nano2dev GitHub (AC180 support)
RUN pip install --no-cache-dir git+https://github.com/nano2dev/bluetti_mqtt.git && \
    python3 -c "import bluetti_mqtt; print('✓ bluetti_mqtt (nano2dev) module installed successfully')"

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
