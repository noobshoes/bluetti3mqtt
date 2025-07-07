ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY rootfs /

# Install dependencies
RUN apk add --update --no-cache \
        bluez \
        py3-cryptography \
        git \
    && pip install --no-cache-dir --break-system-packages \
        pyasn1 \
        git+https://github.com/nano2dev/bluetti_mqtt.git \
    && rm -rf /var/cache/apk/* /lib/apk/db/* \
    && chmod a+x /run.sh

CMD [ "/run.sh" ]
