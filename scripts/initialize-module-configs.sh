#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$root/server/env/dist/etc/modules"

if [[ ! -d "$config_dir" ]]; then
  printf 'Module config directory is missing. Run docker compose build first.\n' >&2
  exit 1
fi

for config in playerbots mod_ahbot transmog dungeonrespawn IpTracker mod_autofish gamestate_api mod_autosort mod_autolearn_skills AOElootmodule; do
  dist="$config_dir/$config.conf.dist"
  target="$config_dir/$config.conf"
  if [[ ! -f "$dist" ]]; then
    printf 'Missing template: %s\n' "$dist" >&2
    exit 1
  fi
  if [[ ! -f "$target" ]]; then
    cp "$dist" "$target"
    printf 'Created %s\n' "$target"
  fi
done
