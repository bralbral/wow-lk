#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || -z "$1" ]]; then
  printf 'Usage: %s <regular-character-name>\n' "$0" >&2
  exit 64
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server="$root/server"
character_name="$1"
sql_character_name="${character_name//\'/\'\'}"

if [[ ! -f "$root/.env" || ! -d "$server" ]]; then
  printf 'Run scripts/bootstrap.sh and create .env first.\n' >&2
  exit 1
fi

guid="$(
  cd "$server"
  docker compose exec -T ac-database sh -c \
    'mysql -N -s -uroot -p"$MYSQL_ROOT_PASSWORD" acore_characters -e "$1"' sh \
    "SELECT guid FROM characters WHERE name = '$sql_character_name' LIMIT 1;"
)"

if [[ ! "$guid" =~ ^[0-9]+$ ]] || [[ "$guid" == 0 ]]; then
  printf 'No regular character named %s was found. Create it in-game first.\n' "$character_name" >&2
  exit 1
fi

sed -i -E "s|^WOW_AHBOT_GUIDS=.*$|WOW_AHBOT_GUIDS=$guid|" "$root/.env"

cd "$server"
docker compose up -d --force-recreate ac-worldserver
printf 'Auction Bot Plus enabled with %s (GUID %s).\n' "$character_name" "$guid"
printf 'Log in as GM and use .ahbot update to fill auctions immediately.\n'
