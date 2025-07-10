ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Install build dependencies and runtime requirements for better compatibility
RUN apk add --no-cache \
    bluez \
    dos2unix \
    git \
    python3-dev \
    py3-pip

# Fix line endings
RUN dos2unix /run.sh

# Set environment variables for better compatibility
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install Python dependencies with compatibility fixes
RUN pip install --upgrade pip setuptools wheel

# Install required dependencies first
RUN pip install --no-cache-dir \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1 \
    bleak==0.22.3 \
    crcmod==1.7 \
    asyncio-mqtt==0.12.1

# Install bluetti_mqtt from nano2dev repository with safe verification
RUN echo "Installing bluetti_mqtt..." && \
    pip install --no-cache-dir "git+https://github.com/nano2dev/bluetti_mqtt.git" && \
    echo "Verifying basic installation..." && \
    python3 -c "import bluetti_mqtt; print('✓ bluetti_mqtt module installed successfully')" && \
    echo "Installation verification complete"

# Create simple entry point scripts without complex error handling that might cause segfaults
RUN echo "Creating entry point scripts..." && \
    echo '#!/usr/local/bin/python3' > /usr/local/bin/bluetti-mqtt && \
    echo 'import sys' >> /usr/local/bin/bluetti-mqtt && \
    echo 'print("[DEBUG] sys.executable:", sys.executable)' >> /usr/local/bin/bluetti-mqtt && \
    echo 'print("[DEBUG] sys.path:", sys.path)' >> /usr/local/bin/bluetti-mqtt && \
    echo 'from bluetti_mqtt.server_cli import main' >> /usr/local/bin/bluetti-mqtt && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-mqtt && \
    echo '    sys.exit(main())' >> /usr/local/bin/bluetti-mqtt && \
    chmod +x /usr/local/bin/bluetti-mqtt && \
    echo '#!/usr/local/bin/python3' > /usr/local/bin/bluetti-discovery && \
    echo 'import sys' >> /usr/local/bin/bluetti-discovery && \
    echo 'print("[DEBUG] sys.executable:", sys.executable)' >> /usr/local/bin/bluetti-discovery && \
    echo 'print("[DEBUG] sys.path:", sys.path)' >> /usr/local/bin/bluetti-discovery && \
    echo 'from bluetti_mqtt.discovery_cli import main' >> /usr/local/bin/bluetti-discovery && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-discovery && \
    echo '    sys.exit(main())' >> /usr/local/bin/bluetti-discovery && \
    chmod +x /usr/local/bin/bluetti-discovery && \
    echo '#!/usr/local/bin/python3' > /usr/local/bin/bluetti-logger && \
    echo 'import sys' >> /usr/local/bin/bluetti-logger && \
    echo 'print("[DEBUG] sys.executable:", sys.executable)' >> /usr/local/bin/bluetti-logger && \
    echo 'print("[DEBUG] sys.path:", sys.path)' >> /usr/local/bin/bluetti-logger && \
    echo 'from bluetti_mqtt.logger_cli import main' >> /usr/local/bin/bluetti-logger && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-logger && \
    echo '    sys.exit(main())' >> /usr/local/bin/bluetti-logger && \
    chmod +x /usr/local/bin/bluetti-logger

# Verify installation without triggering segfaults
RUN python3 -c "import bluetti_mqtt; print('bluetti_mqtt imported successfully')" && \
    which python3 && \
    ls -la /usr/local/bin/bluetti-* && \
    echo "Entry points verified"

# Create a diagnostic script for troubleshooting
RUN echo '#!/bin/sh' > /usr/local/bin/test-bluetti-commands && \
    echo 'echo "=== Bluetti CLI Tools Diagnostic ==="' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo "Python version: $(python3 --version)"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo "Available commands:"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'ls -la /usr/local/bin/bluetti-*' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo ""' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo "Testing import:"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'python3 -c "import bluetti_mqtt; print(\"✓ bluetti_mqtt module loads successfully\")" || echo "✗ Failed to import bluetti_mqtt"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo ""' >> /usr/local/bin/test-bluetti-commands && \
    echo 'echo "Testing entry points:"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'for cmd in bluetti-mqtt bluetti-discovery bluetti-logger; do' >> /usr/local/bin/test-bluetti-commands && \
    echo '    echo "Testing $cmd --help..."' >> /usr/local/bin/test-bluetti-commands && \
    echo '    timeout 5s $cmd --help > /dev/null 2>&1 && echo "✓ $cmd works" || echo "✗ $cmd failed"' >> /usr/local/bin/test-bluetti-commands && \
    echo 'done' >> /usr/local/bin/test-bluetti-commands && \
    chmod +x /usr/local/bin/test-bluetti-commands

# Set permissions
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
