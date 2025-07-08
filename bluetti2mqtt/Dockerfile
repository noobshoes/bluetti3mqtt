ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Update the package index and install build-base
RUN apk update && apk add --no-cache build-base

# Install remaining build dependencies one by one
RUN apk add --no-cache python3-dev
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache python3-openssl
RUN apk add --no-cache cargo
RUN apk add --no-cache bluez-dev
RUN apk add --no-cache git

# Install bluetti_mqtt
RUN pip install \
    --no-cache-dir \
    --break-system-packages \
    "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]" \
    && pip install --no-cache-dir --break-system-packages paho-mqtt pyserial-asyncio bleak
