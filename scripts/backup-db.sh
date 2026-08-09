#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server="$root/server"
backup_dir="${1:-$root/backups}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
output="$backup_dir/acore-$timestamp.sql.gz"

if [[ ! -d "$server" ]]; then
  printf 'Run ./scripts/bootstrap.sh first.\n' >&2
  exit 1
fi

mkdir -p "$backup_dir"
trap 'rm -f "$output"' ERR

cd "$server"
docker compose exec -T ac-database sh -c \
  'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" --single-transaction --routines --events --all-databases' \
  | gzip -c > "$output"

test -s "$output"
trap - ERR
printf 'Backup created: %s\n' "$output"
