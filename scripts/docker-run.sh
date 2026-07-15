#!/bin/bash
#
# Navidrome - Docker Run Script
# ==============================
# This script runs Navidrome using Docker.
#
# Usage:
#   ./scripts/docker-run.sh [OPTIONS]
#
# Options:
#   -m, --music PATH     Path to your music directory (required)
#   -d, --data PATH      Path for Navidrome data directory (default: ./navidrome-data)
#   -p, --port PORT      Host port to bind (default: 4533)
#   -e, --env KEY=VAL    Additional environment variables (can be used multiple times)
#   -t, --tag TAG        Docker image tag (default: latest)
#   -h, --help           Show this help message
#
# Examples:
#   ./scripts/docker-run.sh --music /home/user/music
#   ./scripts/docker-run.sh -m /media/music -d /opt/navidrome-data -p 8080
#   ./scripts/docker-run.sh -m ~/Music -e ND_LOGLEVEL=debug -e ND_SCANSCHEDULE=30m
#

set -euo pipefail

# Default values
MUSIC_DIR=""
DATA_DIR="$(pwd)/navidrome-data"
HOST_PORT="4533"
IMAGE_TAG="latest"
EXTRA_ENV=()
SCRIPT_NAME="$(basename "$0")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help function
show_help() {
  sed -n '2,/^$/p' "$0" | sed 's/^# //g; s/^#$//g' | head -n -1
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--music)
      MUSIC_DIR="$2"
      shift 2
      ;;
    -d|--data)
      DATA_DIR="$2"
      shift 2
      ;;
    -p|--port)
      HOST_PORT="$2"
      shift 2
      ;;
    -e|--env)
      EXTRA_ENV+=("-e" "$2")
      shift 2
      ;;
    -t|--tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      show_help
      ;;
  esac
done

# Validate required arguments
if [[ -z "$MUSIC_DIR" ]]; then
  echo -e "${RED}Error: Music directory is required. Use -m or --music to specify it.${NC}"
  echo ""
  show_help
fi

if [[ ! -d "$MUSIC_DIR" ]]; then
  echo -e "${RED}Error: Music directory '$MUSIC_DIR' does not exist.${NC}"
  exit 1
fi

# Convert to absolute paths
MUSIC_DIR="$(realpath "$MUSIC_DIR")"
DATA_DIR="$(realpath "$DATA_DIR")"

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Starting Navidrome with Docker${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "  ${YELLOW}Music directory:${NC}  $MUSIC_DIR"
echo -e "  ${YELLOW}Data directory:${NC}   $DATA_DIR"
echo -e "  ${YELLOW}Host port:${NC}        $HOST_PORT"
echo -e "  ${YELLOW}Image tag:${NC}        $IMAGE_TAG"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo -e "${RED}Error: Docker is not installed or not in PATH.${NC}"
  exit 1
fi

# Stop and remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^navidrome$"; then
  echo -e "${YELLOW}Stopping and removing existing 'navidrome' container...${NC}"
  docker stop navidrome 2>/dev/null || true
  docker rm navidrome 2>/dev/null || true
fi

# Run the container
echo -e "${GREEN}Starting Navidrome container...${NC}"
docker run -d \
  --name navidrome \
  --restart=unless-stopped \
  -v "$DATA_DIR:/data" \
  -v "$MUSIC_DIR:/music:ro" \
  -p "$HOST_PORT:4533" \
  -e ND_SCANSCHEDULE=1h \
  -e ND_LOGLEVEL=info \
  "${EXTRA_ENV[@]}" \
  docker.io/deluan/navidrome:"$IMAGE_TAG"

echo ""
echo -e "${GREEN}✓ Navidrome is running!${NC}"
echo -e "  Access it at: ${YELLOW}http://localhost:$HOST_PORT${NC}"
echo ""
echo -e "  To view logs: ${YELLOW}docker logs -f navidrome${NC}"
echo -e "  To stop:      ${YELLOW}docker stop navidrome${NC}"
echo -e "  To start:     ${YELLOW}docker start navidrome${NC}"
