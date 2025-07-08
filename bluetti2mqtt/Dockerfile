ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install build dependencies, python, fix line endings, and install the package
RUN apk add --no-cache \
    python3 \
    py3-pip \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    cargo \
    bluez-dev \
    git \
    dos2unix \
    && dos2unix /run.sh \
    && pip3 install \
        --no-cache-dir \
        --break-system-packages \
        "bluetti-mqtt[bluetooth]@git+https://github.com/nano2dev/bluetti_mqtt.git" \
    && apk del build-base git cargo

# Set permissions for the run script
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
