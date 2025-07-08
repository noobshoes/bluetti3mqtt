FROM python:3.11-alpine

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install build dependencies
RUN apk update && apk add --no-cache \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo \
    bluez-dev \
    git

# Install bluetti_mqtt and its dependencies
RUN pip install \
    --no-cache-dir \
    --break-system-packages \
    "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]" \
    && pip install --no-cache-dir --break-system-packages paho-mqtt pyserial-asyncio bleak

# Clean up build dependencies to reduce image size
RUN apk del build-base git cargo

# Set permissions for the run script
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
