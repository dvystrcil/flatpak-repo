#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

# Create writable logs directory in user's XDG data home
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
MEKHQ_DATA="$DATA_HOME/mekhq"
mkdir -p "$MEKHQ_DATA/logs"

# Change to MekHQ directory first so absolute paths work
cd /app/mekhq

# Create symlink from /app/mekhq/logs to user's writable logs directory
rm -rf logs
ln -sf "$MEKHQ_DATA/logs" logs

# Note: logs is now a symlink to $MEKHQ_DATA/logs

exec /app/mekhq/bin/MekHQ "$@"
