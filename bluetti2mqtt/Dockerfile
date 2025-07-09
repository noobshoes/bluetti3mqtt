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
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages

# Install Python dependencies (handle both old and new pip versions)
RUN pip install --no-cache-dir --break-system-packages --upgrade pip setuptools wheel || \
    pip install --no-cache-dir --upgrade pip setuptools wheel

# Install required dependencies first
RUN pip install --no-cache-dir --break-system-packages \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1 \
    bleak==0.22.3 \
    crcmod==1.7 \
    asyncio-mqtt==0.12.1 || \
    pip install --no-cache-dir \
    pyasn1==0.6.1 \
    cryptography==44.0.0 \
    dbus-next==0.2.3 \
    paho-mqtt==1.6.1 \
    bleak==0.22.3 \
    crcmod==1.7 \
    asyncio-mqtt==0.12.1

# Install bluetti_mqtt from nano2dev repository with error handling
RUN pip install --no-cache-dir --break-system-packages \
    "bluetti-mqtt[bluetooth]@git+https://github.com/nano2dev/bluetti_mqtt.git" || \
    pip install --no-cache-dir \
    "bluetti-mqtt[bluetooth]@git+https://github.com/nano2dev/bluetti_mqtt.git" || \
    (echo "Retrying bluetti-mqtt installation..." && \
     pip install --no-cache-dir --break-system-packages --force-reinstall \
     "git+https://github.com/nano2dev/bluetti_mqtt.git") || \
    (echo "Final fallback bluetti-mqtt installation..." && \
     pip install --no-cache-dir --force-reinstall \
     "git+https://github.com/nano2dev/bluetti_mqtt.git")

# Fix all bluetti entry point scripts (they all need different argument handling)
RUN echo "Creating bluetti-mqtt script..." && \
    echo '#!/usr/bin/python3' > /usr/local/bin/bluetti-mqtt && \
    echo '# -*- coding: utf-8 -*-' >> /usr/local/bin/bluetti-mqtt && \
    echo 'import re' >> /usr/local/bin/bluetti-mqtt && \
    echo 'import sys' >> /usr/local/bin/bluetti-mqtt && \
    echo 'from bluetti_mqtt.server_cli import main' >> /usr/local/bin/bluetti-mqtt && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-mqtt && \
    echo '    sys.argv[0] = re.sub(r"(-script\.pyw|\.exe)?$", "", sys.argv[0])' >> /usr/local/bin/bluetti-mqtt && \
    echo '    sys.exit(main(sys.argv))' >> /usr/local/bin/bluetti-mqtt && \
    chmod +x /usr/local/bin/bluetti-mqtt && \
    echo "Creating bluetti-discovery script..." && \
    echo '#!/usr/bin/python3' > /usr/local/bin/bluetti-discovery && \
    echo '# -*- coding: utf-8 -*-' >> /usr/local/bin/bluetti-discovery && \
    echo 'import re' >> /usr/local/bin/bluetti-discovery && \
    echo 'import sys' >> /usr/local/bin/bluetti-discovery && \
    echo 'from bluetti_mqtt.discovery_cli import main' >> /usr/local/bin/bluetti-discovery && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-discovery && \
    echo '    sys.argv[0] = re.sub(r"(-script\.pyw|\.exe)?$", "", sys.argv[0])' >> /usr/local/bin/bluetti-discovery && \
    echo '    sys.exit(main())' >> /usr/local/bin/bluetti-discovery && \
    chmod +x /usr/local/bin/bluetti-discovery && \
    echo "Creating bluetti-logger script..." && \
    echo '#!/usr/bin/python3' > /usr/local/bin/bluetti-logger && \
    echo '# -*- coding: utf-8 -*-' >> /usr/local/bin/bluetti-logger && \
    echo 'import re' >> /usr/local/bin/bluetti-logger && \
    echo 'import sys' >> /usr/local/bin/bluetti-logger && \
    echo 'from bluetti_mqtt.logger_cli import main' >> /usr/local/bin/bluetti-logger && \
    echo 'if __name__ == "__main__":' >> /usr/local/bin/bluetti-logger && \
    echo '    sys.argv[0] = re.sub(r"(-script\.pyw|\.exe)?$", "", sys.argv[0])' >> /usr/local/bin/bluetti-logger && \
    echo '    sys.exit(main())' >> /usr/local/bin/bluetti-logger && \
    chmod +x /usr/local/bin/bluetti-logger

# Verify installations and create diagnostic script
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
