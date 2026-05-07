#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

# Note: log paths are hardcoded in log4j2.xml to /home/dan/.local/share/mekhq/logs

exec /app/mekhq/bin/MekHQ "$@"
