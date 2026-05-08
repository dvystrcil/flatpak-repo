#!/bin/bash
# Wrapper script for MekHQ Flatpak.
# Sets JAVA_HOME from the openjdk21 SDK extension and launches MekHQ.
# cd into /app/mekhq because megamek's loaders open files via relative
# paths (e.g. new File("mmconf/milestoneReleases.yml")).
# log4j2.xml is sed-patched at build time to use ${sys:mekhq.logDir};
# we set that property here so logs land in the user's data dir
# instead of the read-only /app/mekhq/logs.

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

LOG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mekhq/logs"
mkdir -p "$LOG_DIR"
export JAVA_OPTS="-Dmekhq.logDir=$LOG_DIR ${JAVA_OPTS:-}"

cd /app/mekhq
exec /app/mekhq/bin/MekHQ "$@"
