ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install git so we can fetch from the repository
RUN apk update && apk add --no-cache git

# Install bluetti_mqtt and all its python dependencies
RUN pip install \
    --no-cache-dir \
    --break-system-packages \
    "git+https://github.com/nano2dev/bluetti_mqtt.git#egg=bluettimqtt[bluetooth]" \
    && pip install --no-cache-dir --break-system-packages paho-mqtt pyserial-asyncio bleak

# Set permissions for the run script
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
