#!/bin/bash
# Wrapper script for MekHQ Flatpak.
# Sets JAVA_HOME from the openjdk21 SDK extension and launches MekHQ.
# cd into /app/mekhq because megamek's loaders open files via relative
# paths (e.g. new File("mmconf/milestoneReleases.yml")).

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/mekhq/logs"

cd /app/mekhq
exec /app/mekhq/bin/MekHQ "$@"
