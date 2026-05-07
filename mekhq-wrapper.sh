#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

# Change to MekHQ directory so relative paths work correctly
cd /app/mekhq

exec /app/mekhq/bin/MekHQ "$@"
