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
    git

# Install bluetti_mqtt
RUN pip install \
    --no-cache-dir \
    --break-system-packages \
    "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]"
