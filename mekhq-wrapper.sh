#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Sets JAVA_HOME to the OpenJDK 21 extension and launches MekHQ

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

# Create writable logs directory in user's XDG data home
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
MEKHQ_DATA="$DATA_HOME/mekhq"
mkdir -p "$MEKHQ_DATA/logs"

# Symlink logs directory to writable location
if [ ! -L "$MEKHQ_DATA/logs" ]; then
  rm -rf "$MEKHQ_DATA/logs"
fi
ln -sf "$MEKHQ_DATA/logs" /app/mekhq/logs

# Change to MekHQ directory so relative paths work correctly
cd /app/mekhq

exec /app/mekhq/bin/MekHQ "$@"
