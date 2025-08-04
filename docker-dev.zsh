# Prune all docker junk data
# Requires: docker
docker-prune-all() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "[docker-prune-all] Error: docker not found in PATH" >&2
    return 1
  fi
  docker system prune -f
}

# Docker image tag generator
# Usage: docker-image-tag [tag] [mode]
docker-image-tag() {
  if ! command -v git >/dev/null 2>&1; then
    echo "[docker-image-tag] Error: git not found in PATH" >&2
    return 1
  fi
  TAG="${1:-notag}"
  MODE="${2:-release}"
  echo "${MODE}_$(date +"%Y%m%d%H%M%S")_${TAG}_$(git rev-parse HEAD | head -c 8)"
}

# Stop all running docker compose projects
docker-compose-stop-world() {
  if ! command -v docker >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "[docker-compose-stop-world] Error: docker or jq not found in PATH" >&2
    return 1
  fi
  docker compose ls --format json | jq -r '.[].Name' | while IFS= read -r name; do
    docker compose -p "$name" down
  done
}
