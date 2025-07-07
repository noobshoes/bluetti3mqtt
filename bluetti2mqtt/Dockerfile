ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo \
    bluez-dev \
    git \
    py3-cryptography

# Install bluetti_mqtt, but tell pip not to fetch cryptography from its index
RUN pip install \
    --no-cache-dir \
    --break-system-packages \
    --no-deps \
    "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]" \
    && pip install --no-cache-dir --break-system-packages paho-mqtt pyserial-asyncio bleak
