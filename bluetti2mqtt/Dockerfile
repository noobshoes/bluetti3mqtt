ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install build dependencies, install bluetti_mqtt, and then remove build dependencies
RUN apk update && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        bluez-dev \
        git && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --break-system-packages \
        "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]" && \
    apk del .build-deps

# Set permissions for the run script
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
