#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server="$root/server"

if [[ ! -d "$server" || ! -f "$root/.env" ]]; then
  printf 'Run ./scripts/bootstrap.sh and configure .env first.\n' >&2
  exit 1
fi

# These files are generated from the repository templates. User settings stay
# in the root .env and are not overwritten.
cp "$root/docker-compose.override.yml.template" "$server/docker-compose.override.yml"
cp "$root/conf/wow.env.template" "$server/conf/wow.env"

cd "$server"
docker compose up -d --build
