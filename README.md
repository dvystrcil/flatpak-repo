# Flatpak Repository

This repository hosts Flatpak packages for MekHQ and future Flatpak applications.

## Available Packages

### MekHQ

| Property | Value |
|----------|-------|
| App ID | `com.megamek.mekhq` |
| Version | `0.50.12` |
| Runtime | `org.freedesktop.Platform 23.08` |
| SDK | `org.freedesktop.Sdk 23.08` |
| Java | `OpenJDK 21` |

## Usage

### Add the repository

```bash
flatpak remote-add --user mekhq-repo https://dvystrcil.github.io/flatpack-repo/
```

### Install MekHQ

```bash
flatpak install --user mekhq-repo com.megamek.mekhq
```

### Run MekHQ

```bash
flatpak run com.megamek.mekhq
```

### Update MekHQ

```bash
flatpak update --user com.megamek.mekhq
```

## Development

### Build locally

```bash
# Ensure Flathub is added
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.freedesktop.Platform/23.08 org.freedesktop.Sdk/23.08

# Build and install
flatpak-builder --user --install --force-clean build com.megamek.mekhq.json

# Run
flatpak run com.megamek.mekhq
```

### Add a new app to the repo

1. Create a new manifest file: `com.your.app.json`
2. Add source files (wrapper script, configs, etc.)
3. Add a GitHub Actions workflow to build it (see `.github/workflows/`)
4. Push and the CI will export to the repo

## Tech Stack

- **Flatpak**: Application sandboxing and packaging
- **OSTree**: Content-addressable repository format
- **GitHub Pages**: Static hosting for Flatpak repo
- **GitHub Actions**: CI/CD for building and publishing

## License

See the [MekHQ project](https://github.com/MegaMek/mekhq) for application licensing.