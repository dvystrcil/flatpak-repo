#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

exec /app/mekhq/bin/MekHQ "$@"
