#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

# Ensure logs directory exists
mkdir -p /home/dan/.local/share/mekhq/logs

# Pass log4j configuration file explicitly
exec /app/mekhq/bin/MekHQ -Dlog4j.configurationFile=/app/mekhq/mmconf/log4j2.xml "$@"
