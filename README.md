# 🎵 Navidrome

<div align="center">

[![CI](https://github.com/actiago/navridrome/actions/workflows/ci.yml/badge.svg)](https://github.com/actiago/navridrome/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/deluan/navidrome)
[![Podman](https://img.shields.io/badge/Podman-892CA0?logo=podman&logoColor=white)](https://podman.io)

**Navidrome** is a modern music server and streamer compatible with Subsonic API.
This repository provides deployment configurations for running Navidrome with **Docker** and **Podman**.

</div>

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
  - [Using Docker](#using-docker)
  - [Using Podman](#using-podman)
- [Docker Compose](#docker-compose)
- [Podman Compose](#podman-compose)
- [Configuration](#configuration)
- [Deployment Scripts](#deployment-scripts)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## ✅ Prerequisites

Before you begin, ensure you have one of the following installed:

- **Docker** (20.10+) and Docker Compose — [Install Docker](https://docs.docker.com/engine/install/)
- **Podman** (3.0+) and Podman Compose — [Install Podman](https://podman.io/docs/installation)

> 💡 **Note:** Podman is a daemonless container engine that is a drop-in replacement for Docker. It is particularly well-suited for rootless container execution.

---

## 🚀 Quick Start

### Using Docker

Run Navidrome with a single command:

```bash
docker run -d \
  --name navidrome \
  --restart=unless-stopped \
  -v $(pwd)/navidrome-data:/data \
  -v /path/to/your/music:/music:ro \
  -p 4533:4533 \
  -e ND_SCANSCHEDULE=1h \
  -e ND_LOGLEVEL=info \
  docker.io/deluan/navidrome:latest
```

Then access Navidrome at **http://localhost:4533**.

### Using Podman

Run Navidrome with a single command:

```bash
podman run -d \
  --name navidrome \
  --restart=unless-stopped \
  -v $(pwd)/navidrome-data:/data:Z \
  -v /path/to/your/music:/music:ro,Z \
  -p 4533:4533 \
  -e ND_SCANSCHEDULE=1h \
  -e ND_LOGLEVEL=info \
  docker.io/deluan/navidrome:latest
```

> 🔒 The `:Z` flag on volumes is specific to Podman/SELinux systems and automatically sets the correct SELinux context.

---

## 🐳 Docker Compose

For a more structured setup, use Docker Compose:

1. **Clone this repository:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure the environment (optional):**

   ```bash
   cp .env.example .env
   # Edit .env with your Last.fm API credentials if desired
   ```

3. **Edit `docker-compose.yml`** and update the music volume path:

   ```yaml
   volumes:
     - ./navidrome-data:/data
     - /path/to/your/music:/music:ro   # ← Change this path
   ```

4. **Start Navidrome:**

   ```bash
   docker compose up -d
   ```

5. **View logs:**

   ```bash
   docker compose logs -f
   ```

6. **Stop Navidrome:**

   ```bash
   docker compose down
   ```

---

## 🦭 Podman Compose

For Podman users, use the provided `podman-compose.yml`:

1. **Clone this repository:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure the environment (optional):**

   ```bash
   cp .env.example .env
   # Edit .env with your Last.fm API credentials if desired
   ```

3. **Edit `podman-compose.yml`** and update the music volume path:

   ```yaml
   volumes:
     - ./navidrome-data:/data:Z
     - /path/to/your/music:/music:ro,Z   # ← Change this path
   ```

4. **Start Navidrome:**

   ```bash
   podman-compose up -d
   ```

   Or using Podman's Docker Compose compatibility:

   ```bash
   podman compose up -d
   ```

5. **View logs:**

   ```bash
   podman-compose logs -f
   ```

6. **Stop Navidrome:**

   ```bash
   podman-compose down
   ```

---

## ⚙️ Configuration

### Environment Variables

Navidrome can be configured using environment variables. All variables are prefixed with `ND_`.

| Variable | Default | Description |
|---|---|---|
| `ND_SCANSCHEDULE` | `1h` | How often to scan for new music (e.g., `30m`, `1h`, `6h`) |
| `ND_LOGLEVEL` | `info` | Log level: `debug`, `info`, `warning`, `error` |
| `ND_LASTFM_ENABLED` | `false` | Enable Last.fm scrobbling |
| `ND_LASTFM_APIKEY` | — | Your Last.fm API key |
| `ND_LASTFM_SECRET` | — | Your Last.fm shared secret |
| `ND_MUSICFOLDER` | `/music` | Path to music directory inside the container |
| `ND_DATAFOLDER` | `/data` | Path to data directory inside the container |

For a complete list of configuration options, see the [official Navidrome documentation](https://www.navidrome.org/docs/usage/configuration-options/).

### Using `.env` File

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Then edit `.env` with your preferred settings. The Docker Compose files will automatically load variables from this file.

---

## 📜 Deployment Scripts

This repository includes helper scripts for quick deployment:

### Docker Script

```bash
# Make the script executable
chmod +x scripts/docker-run.sh

# Run with required music directory
./scripts/docker-run.sh --music /path/to/your/music

# With custom options
./scripts/docker-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Podman Script

```bash
# Make the script executable
chmod +x scripts/podman-run.sh

# Run with required music directory
./scripts/podman-run.sh --music /path/to/your/music

# With custom options
./scripts/podman-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Script Options

| Option | Description | Default |
|---|---|---|
| `-m, --music PATH` | Path to music directory **(required)** | — |
| `-d, --data PATH` | Path for Navidrome data | `./navidrome-data` |
| `-p, --port PORT` | Host port to bind | `4533` |
| `-e, --env KEY=VAL` | Additional environment variables | — |
| `-t, --tag TAG` | Container image tag | `latest` |
| `-h, --help` | Show help message | — |

---

## 📁 Project Structure

```
navidrome/
├── .editorconfig              # Editor configuration
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore rules
├── .github/
│   ├── dependabot.yml         # Dependabot configuration
│   └── workflows/
│       ├── ci.yml             # CI workflow (lint, validate)
│       └── release.yml        # Release workflow
├── CHANGELOG.md               # Version history
├── LICENSE                    # MIT License
├── README.md                  # This file
├── docker-compose.yml         # Docker Compose configuration
├── podman-compose.yml         # Podman Compose configuration
└── scripts/
    ├── docker-run.sh          # Docker deployment script
    └── podman-run.sh          # Podman deployment script
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Commit** your changes: `git commit -am 'Add my feature'`
4. **Push** to the branch: `git push origin feature/my-feature`
5. **Open** a Pull Request

Please ensure your code follows the existing style and includes appropriate documentation.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  Made with ❤️ for the Navidrome community
</div>
