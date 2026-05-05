#!/bin/bash
# Wrapper script for MekHQ Flatpak
# Uses OpenJDK 21 from org.freedesktop.Java.OpenJDK

exec "${JAVA_HOME}/bin/java" -jar /app/mekhq/MegaMek.jar "$@"