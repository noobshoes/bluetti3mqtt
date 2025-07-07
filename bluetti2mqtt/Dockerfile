ARG BUILD_FROM
FROM "ghcr.io/hassio-addons/base-python:5.0.2"

# Copy data for add-on
COPY rootfs /

# Install bluetti_mqtt
RUN \
    pip install \
        --no-cache-dir \
        --break-system-packages \
        "bluettimqtt[bluetooth]==0.2.3" \
    && chmod a+x /run.sh

CMD [ "/run.sh" ]
