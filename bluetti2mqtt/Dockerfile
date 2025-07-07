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

# Upgrade pip and install cryptography separately to help with dependency resolution
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --break-system-packages cryptography cffi

# Install the bluetti_mqtt package
RUN pip install \
        --no-cache-dir \
        --break-system-packages \
        "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]"

# Clean up build dependencies to reduce image size
RUN apk del \
        build-base \
        git \
        cargo

# Set permissions for the run script
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
