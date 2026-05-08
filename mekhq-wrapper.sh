#!/bin/bash
# Wrapper for the MekHQ flatpak — used for MekHQ, MegaMek, and MegaMekLab.
# Dispatches on basename($0) so /app/bin/{mekhq,megamek,megameklab} all
# share this script.
#
# /app is read-only, but the three apps open files via paths relative
# to cwd — both for reading (mmconf/milestoneReleases.yml) and for
# writing (mmconf/megameklab.properties, userdata/*, data/images/temp/
# pilot portraits, data/mekfiles/units.cache, logs/*). To support
# writes we cd into a per-user working directory under XDG_DATA_HOME
# with read-only assets symlinked from /app/mekhq and writable dirs
# seeded from there.

export JAVA_HOME=/app/jre
export PATH="${JAVA_HOME}/bin:${PATH}"

APP=/app/mekhq
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mekhq"
WORK_DIR="$DATA_DIR/work"
LOG_DIR="$DATA_DIR/logs"

mkdir -p "$WORK_DIR" "$LOG_DIR"

# Mirror src into dst by symlinking each child of src — except names in
# remaining args, which the caller will populate as writable.
mirror_dir() {
    local src=$1 dst=$2
    shift 2
    mkdir -p "$dst"
    for entry in "$src"/* "$src"/.[!.]*; do
        [ -e "$entry" ] || continue
        local name skip=0
        name=$(basename "$entry")
        for s in "$@"; do
            [ "$s" = "$name" ] && skip=1 && break
        done
        [ "$skip" -eq 1 ] && continue
        ln -sfn "$entry" "$dst/$name"
    done
}

# Migration: older wrapper versions made data/ a single symlink.
# Replace with a real dir so we can mix writable subdirs in.
[ -L "$WORK_DIR/data" ] && rm -f "$WORK_DIR/data"

# data/ — symlinks for everything except images/ and mekfiles/, which
# need writable children (TT_Portrait pngs, units.cache).
mirror_dir "$APP/data" "$WORK_DIR/data" images mekfiles
mirror_dir "$APP/data/images" "$WORK_DIR/data/images" temp
mkdir -p "$WORK_DIR/data/images/temp"
mirror_dir "$APP/data/mekfiles" "$WORK_DIR/data/mekfiles" units.cache

# Other top-level read-only links.
ln -sfn "$APP/docs" "$WORK_DIR/docs"
ln -sfn "$LOG_DIR" "$WORK_DIR/logs"

# Writable dirs — seed any file missing from /app/mekhq, never overwrite
# user-modified copies. Catches new files added on upstream upgrade.
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

case "$(basename "$0")" in
    megamek)    exec "$APP/bin/MegaMek" "$@" ;;
    megameklab) exec "$APP/bin/MegaMekLab" "$@" ;;
    *)          exec "$APP/bin/MekHQ" "$@" ;;
esac
