ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY rootfs /

# Install dependencies in separate layers to improve debugging and caching

# Step 1: Remove any pre-existing cryptography packages to avoid conflicts
RUN apk del py3-cryptography || true

# Step 2: Install system-level build dependencies
RUN apk add --update --no-cache \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        bluez \
        git

# Step 3: Install python packages
RUN pip install --no-cache-dir \
        cryptography \
        pyasn1 \
        git+https://github.com/nano2dev/bluetti_mqtt.git

# Step 4: Final cleanup and permissions
RUN rm -rf /var/cache/apk/* /lib/apk/db/* \
    && chmod a+x /run.sh

CMD [ "/run.sh" ]
