ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY rootfs /

# Install bluetti_mqtt
RUN apk add --update --no-cache \
        build-base \
        python3-dev \
        libffi-dev \
		bluez=5.65-r0 \
        git \
	&& pip install --no-cache-dir \
        pyasn1 \
        cryptography \
        git+https://github.com/nano2dev/bluetti_mqtt.git \
	&& rm -rf /var/cache/apk/* /lib/apk/db/* \
	&& chmod a+x /run.sh

CMD [ "/run.sh" ]
