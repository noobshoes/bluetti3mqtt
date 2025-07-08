FROM python:3.11-alpine

# Copy root filesystem
COPY rootfs /

# Install system dependencies
RUN apk add --no-cache \
    bluez \
    bluez-dev \
    dos2unix \
    git

# Fix line endings
RUN dos2unix /run.sh

# Install bluetti_mqtt
RUN pip install --no-cache-dir \
    "bluetti-mqtt[bluetooth]@git+https://github.com/nano2dev/bluetti_mqtt.git"

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
