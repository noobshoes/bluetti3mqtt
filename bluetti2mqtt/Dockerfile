ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY rootfs /

# Install dependencies
RUN apk add --update --no-cache \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        bluez \
        git \
    && pip install --no-cache-dir \
        cffi \
        cryptography \
        pyasn1 \
        git+https://github.com/nano2dev/bluetti_mqtt.git \
    && rm -rf /var/cache/apk/* /lib/apk/db/* \
    && chmod a+x /run.sh

CMD [ "/run.sh" ]
