# MegaMek Suite Flatpak Repository

Self-hosted Flatpak repository for MekHQ and related MegaMek applications, built and published via GitHub Actions to GitHub Pages.

> **Status:** Testing / pre-release. Not affiliated with the upstream MegaMek project.

## Quick Install

Add the repository and install MekHQ in two commands:

```bash
flatpak remote-add --user --if-not-exists mekhq-repo \
  https://dvystrcil.github.io/flatpack-repo/mekhq.flatpakrepo

flatpak install --user mekhq-repo com.megamek.mekhq
```

Then launch:

```bash
flatpak run com.megamek.mekhq
```

## Available Packages

### MekHQ — Campaign manager for BattleTech

| Property        | Value                          |
| --------------- | ------------------------------ |
| App ID          | `com.megamek.mekhq`            |
| Version         | `0.50.12`                      |
| Runtime         | `org.freedesktop.Platform//24.08` |
| SDK             | `org.freedesktop.Sdk//24.08`   |
| SDK Extension   | `org.freedesktop.Sdk.Extension.openjdk21` |
| Upstream        | [MegaMek/mekhq](https://github.com/MegaMek/mekhq) |

## Managing the Installation

**Update:**

```bash
flatpak update --user com.megamek.mekhq
```

**Remove the app:**

```bash
flatpak uninstall --user com.megamek.mekhq
```

**Remove the repository:**

```bash
flatpak remote-delete --user mekhq-repo
```

## Standalone Bundle (no repo required)

If you'd rather not add a remote, download the bundle directly from the [latest release](https://github.com/dvystrcil/flatpack-repo/releases) or from the GitHub Pages site, then:

```bash
flatpak install --user mekhq.flatpak
```

Note: standalone bundles don't auto-update — you'll need to redownload for new versions.

## Building Locally

Prerequisites: a Linux system with `flatpak` and `flatpak-builder` installed, plus the Flathub remote configured for runtime dependencies.

```bash
# Add Flathub if not already configured
flatpak remote-add --user --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

# Install build dependencies
flatpak install --user flathub \
  org.freedesktop.Platform//24.08 \
  org.freedesktop.Sdk//24.08 \
  org.freedesktop.Sdk.Extension.openjdk21//24.08

# Download the MekHQ tarball (referenced by the manifest)
curl -L -o mekhq.tar.gz \
  https://github.com/MegaMek/mekhq/releases/download/v0.50.12/MekHQ-0.50.12.tar.gz

# Build and install in one step
flatpak-builder --user --install --force-clean \
  build-dir com.megamek.mekhq.json

# Run
flatpak run com.megamek.mekhq
```

## Repository Structure

```
flatpack-repo/
├── README.md
├── com.megamek.mekhq.json       # Flatpak manifest
├── com.megamek.mekhq.desktop    # Desktop entry
├── mekhq-wrapper.sh             # Launcher script
├── mekhq.png                    # Application icon
└── .github/
    └── workflows/
        └── build.yml            # Build & publish to GitHub Pages
```

## CI/CD

| Trigger                    | Behavior                                          |
| -------------------------- | ------------------------------------------------- |
| Push to `main`             | Build, publish to GitHub Pages, attach artifacts |
| Manual workflow dispatch   | Build a specific MekHQ version on demand         |

GitHub Pages serves the OSTree repository and `.flatpakrepo` metadata at <https://dvystrcil.github.io/flatpack-repo/>.

## Adding a New App

1. Create the manifest: `com.your.app.json`
2. Add supporting files (wrapper script, `.desktop` entry, icon) to the repo root
3. Update `.github/workflows/build.yml` to add a build step for the new manifest using the same `repository-name` so it shares the OSTree repo
4. Update this README to list the new app
5. Commit and push — CI builds and publishes automatically

## Troubleshooting

**"Runtime not found" during install:** make sure your Flatpak setup has access to the freedesktop runtime. Adding Flathub usually resolves this:

```bash
flatpak remote-add --user --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo
```

**App fails to launch:** run from a terminal to see error output:

```bash
flatpak run com.megamek.mekhq
```

Common causes are missing graphics drivers (the manifest grants `--device=dri` and `--socket=wayland`/`fallback-x11`, which should cover most setups) or Java runtime issues.

**Repo signature warning when adding the remote:** this repo is currently unsigned for testing. GPG signing will be added before any wider release.

## License

This packaging configuration is provided as-is for testing purposes.

MekHQ and the MegaMek suite are licensed separately by their upstream maintainers. See the [MekHQ project](https://github.com/MegaMek/mekhq) for application source code and licensing terms.
