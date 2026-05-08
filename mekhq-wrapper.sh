#!/bin/bash
# Wrapper script for MekHQ Flatpak.
# Sets JAVA_HOME from the openjdk21 SDK extension and launches MekHQ.

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/mekhq/logs"

exec /app/mekhq/bin/MekHQ "$@"
