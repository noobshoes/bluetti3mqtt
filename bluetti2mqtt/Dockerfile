ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Force a specific, stable Alpine repository to avoid build environment issues
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

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
