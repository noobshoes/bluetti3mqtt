ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Install only essential packages to avoid musl conflicts
RUN apk add --no-cache \
    bluez \
    dos2unix \
    git

# Fix line endings
RUN dos2unix /run.sh

# Install required dependencies first
RUN pip install --no-cache-dir \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1

# Install bluetti_mqtt from nano2dev repository
RUN pip install --no-cache-dir \
    "bluetti-mqtt[bluetooth]@git+https://github.com/nano2dev/bluetti_mqtt.git"

# Fix the bluetti-mqtt entry point script only (it needs sys.argv parameter)
# Check if the pattern exists before applying the sed command
RUN if grep -q "sys.exit(main())" /usr/local/bin/bluetti-mqtt; then \
        sed -i 's/sys.exit(main())/sys.exit(main(sys.argv))/' /usr/local/bin/bluetti-mqtt; \
    fi

# Verify bluetti-discovery and bluetti-logger are NOT modified (they expect main() with no args)
# These should remain as sys.exit(main()) without parameters

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
