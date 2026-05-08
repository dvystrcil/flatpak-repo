#!/bin/bash
# Wrapper script for MekHQ Flatpak.
#
# /app is read-only, but megamek/mekhq/megameklab open files via paths
# relative to cwd — both for reading (mmconf/milestoneReleases.yml) and
# for writing (mmconf/megameklab.properties, userdata/*, campaigns/*,
# logs/*). To support writes we cd into a per-user working directory
# under XDG_DATA_HOME, with read-only assets symlinked from /app/mekhq
# and writable dirs seeded from there.

set -e

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

APP=/app/mekhq
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mekhq"
WORK_DIR="$DATA_DIR/work"
LOG_DIR="$DATA_DIR/logs"

mkdir -p "$WORK_DIR" "$LOG_DIR"

# Read-only assets — symlinks (refresh each launch to track upgrades).
for d in data docs; do
    [ -e "$APP/$d" ] && ln -sfn "$APP/$d" "$WORK_DIR/$d"
done

# logs/ as a symlink to the writable log dir, in case anything resolves
# logs/ relative to cwd (log4j2.xml is sed-patched to use an absolute
# path via -Dmekhq.logDir, but this is belt-and-suspenders).
ln -sfn "$LOG_DIR" "$WORK_DIR/logs"

# Writable dirs — seed any file missing from /app/mekhq, never overwrite
# the user's modified copies. Catches new files added on upstream upgrade.
for d in mmconf userdata campaigns; do
    if [ -d "$APP/$d" ]; then
        mkdir -p "$WORK_DIR/$d"
        (cd "$APP/$d" && find . -type f) | while read -r rel; do
            dst="$WORK_DIR/$d/${rel#./}"
            if [ ! -e "$dst" ]; then
                mkdir -p "$(dirname "$dst")"
                cp "$APP/$d/${rel#./}" "$dst"
            fi
        done
    fi
done

export JAVA_OPTS="-Dmekhq.logDir=$LOG_DIR ${JAVA_OPTS:-}"

cd "$WORK_DIR"
exec "$APP/bin/MekHQ" "$@"
