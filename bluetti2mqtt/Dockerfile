ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY rootfs /

# Install build dependencies, bluetti_mqtt, and then remove build dependencies
RUN apk add --update --no-cache --virtual .build-deps \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        git \
    && apk add --update --no-cache bluez \
    && pip install --no-cache-dir \
        pyasn1 \
        cryptography \
        git+https://github.com/nano2dev/bluetti_mqtt.git \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /lib/apk/db/* \
    && chmod a+x /run.sh

CMD [ "/run.sh" ]
