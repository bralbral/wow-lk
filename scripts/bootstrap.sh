#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server="$root/server"

# shellcheck source=../versions.env
source "$root/versions.env"

if [[ -e "$server" ]]; then
  printf 'Refusing to overwrite existing %s\n' "$server" >&2
  exit 1
fi

git clone --branch Playerbot https://github.com/mod-playerbots/azerothcore-wotlk.git "$server"
git -C "$server" checkout "$AZEROTHCORE_PLAYERBOT_REF"
git -C "$server" submodule update --init --recursive

git clone https://github.com/mod-playerbots/mod-playerbots.git "$server/modules/mod-playerbots"
git -C "$server/modules/mod-playerbots" checkout "$PLAYERBOTS_REF"
git clone https://github.com/NathanHandley/mod-ah-bot.git "$server/modules/mod-ah-bot"
git -C "$server/modules/mod-ah-bot" checkout "$AHBOT_REF"
git clone https://github.com/azerothcore/mod-transmog.git "$server/modules/mod-transmog"
git -C "$server/modules/mod-transmog" checkout "$TRANSMOG_REF"
git clone https://github.com/AnchyDev/DungeonRespawn.git "$server/modules/mod-dungeon-respawn"
git -C "$server/modules/mod-dungeon-respawn" checkout "$DUNGEON_RESPAWN_REF"
git -C "$server/modules/mod-dungeon-respawn" apply "$root/patches/mod-dungeon-respawn-playerbot.patch"
git -C "$server/modules/mod-dungeon-respawn" apply "$root/patches/mod-dungeon-respawn-loader-playerbot.patch"
git clone https://github.com/azerothcore/mod-ip-tracker.git "$server/modules/mod-ip-tracker"
git -C "$server/modules/mod-ip-tracker" checkout "$IP_TRACKER_REF"
git clone https://github.com/Flerp/mod-autofish.git "$server/modules/mod-autofish"
git -C "$server/modules/mod-autofish" checkout "$AUTOFISH_REF"
git clone https://github.com/abutbul/mod-game-state-api.git "$server/modules/mod-game-state-api"
git -C "$server/modules/mod-game-state-api" checkout "$GAME_STATE_API_REF"
git clone https://github.com/silviu20092/mod-autosort.git "$server/modules/mod-autosort"
git -C "$server/modules/mod-autosort" checkout "$AUTOSORT_REF"
git clone https://github.com/poorhatsoap/mod-autolearn-skills.git "$server/modules/mod-autolearn-skills"
git -C "$server/modules/mod-autolearn-skills" checkout "$AUTOLEARN_SKILLS_REF"
# This repository keeps the actual module one directory below its checkout.
git clone https://github.com/Seaferer/AOE-loot---merge.git "$server/modules/.mod-aoe-loot-repo"
git -C "$server/modules/.mod-aoe-loot-repo" checkout "$AOE_LOOT_REF"
git -C "$server/modules/.mod-aoe-loot-repo" apply --ignore-space-change "$root/patches/mod-aoe-loot-playerbot.patch"
git -C "$server/modules/.mod-aoe-loot-repo" apply "$root/patches/mod-aoe-loot-loader-playerbot.patch"
ln -s .mod-aoe-loot-repo/mod-aoeloot "$server/modules/mod-aoe-loot"
git clone https://github.com/Haeniken/mod-gm-realmfirst-fix.git "$server/modules/mod-gm-realmfirst-fix"
git -C "$server/modules/mod-gm-realmfirst-fix" checkout "$GM_REALMFIRST_FIX_REF"

# AzerothCore imports updates from its own data tree, while Transmog ships
# separate SQL files for three databases.
for database in auth characters world; do
  source_dir="$server/modules/mod-transmog/data/sql/db-$database"
  target_dir="$server/data/sql/updates/db_$database"
  if [[ -d "$source_dir" ]]; then
    find "$source_dir" -maxdepth 1 -type f -name '*.sql' -exec cp {} "$target_dir/" \;
  fi
done

# The two modules below ship schema files outside AzerothCore's usual update
# tree. Copy them into the core update directories so db-import applies them.
for database in auth characters world; do
  target_dir="$server/data/sql/updates/db_$database"
  find "$server/modules/mod-dungeon-respawn/data/sql/db-$database" \
       "$server/modules/mod-ip-tracker/data/sql/db-$database" \
       -type f -name '*.sql' -exec cp {} "$target_dir/" \; 2>/dev/null || true
done

cp "$root/docker-compose.override.yml.template" "$server/docker-compose.override.yml"
cp "$root/conf/wow.env.template" "$server/conf/wow.env"

if [[ ! -f "$root/.env" ]]; then
  cp "$root/.env.example" "$root/.env"
  printf 'Created %s/.env. Edit it before the first docker compose up.\n' "$root"
fi

mkdir -p "$root/data/mysql"
ln -s ../.env "$server/.env"
printf 'Source and modules ready in %s\n' "$server"
printf 'Ready. Start with ./scripts/up.sh\n'
