# WotLK Playerbot Server

Docker Compose setup for a private World of Warcraft: Wrath of the Lich King 3.3.5a realm. It builds a pinned [AzerothCore Playerbot](https://github.com/mod-playerbots/azerothcore-wotlk) server with gameplay modules, MySQL, and reproducible GitHub Actions images.

> **Educational / personal-use notice.** This repository is an independent learning and self-hosting project assembled from publicly available, open-source projects. It is not affiliated with, endorsed by, or sponsored by Blizzard Entertainment. World of Warcraft and related marks are trademarks of their respective owners. No Blizzard game client, assets, or proprietary server code are distributed here; use it only with software and content you are entitled to use, and comply with the licences of each included upstream project.

The game client is not included.

## Quick start

```bash
cp .env.example .env
# Set a unique DOCKER_DB_ROOT_PASSWORD before the first start.
./scripts/bootstrap.sh
./scripts/up.sh
cd server && docker compose ps
```

MySQL data is stored in `data/mysql` on the host. Source revisions are pinned in [versions.env](versions.env); do not replace them with branches for a production realm. A fresh install automatically creates module configs and the extra DungeonRespawn/IP Tracker database tables using idempotent schemas; no manual SQL or config edits are required to start.

## Included sources

Core and existing modules:

- [AzerothCore Playerbot](https://github.com/mod-playerbots/azerothcore-wotlk)
- [mod-playerbots](https://github.com/mod-playerbots/mod-playerbots)
- [Auction House Bot](https://github.com/NathanHandley/mod-ah-bot)
- [Transmogrification](https://github.com/azerothcore/mod-transmog)

Additional modules:

- [DungeonRespawn](https://github.com/AnchyDev/DungeonRespawn)
- [Dungeon Clear](https://github.com/jrad7/mod-dungeon-clear)
- [IP Tracker](https://github.com/azerothcore/mod-ip-tracker)
- [Autofish](https://github.com/Flerp/mod-autofish)
- [Game State API](https://github.com/abutbul/mod-game-state-api)
- [Autosort](https://github.com/silviu20092/mod-autosort)
- [Autolearn Skills](https://github.com/poorhatsoap/mod-autolearn-skills)
- [AOE Loot](https://github.com/azerothcore/mod-aoe-loot)
- [GM Realm First Fix](https://github.com/Haeniken/mod-gm-realmfirst-fix)

`DungeonRespawn` includes a small compatibility patch for the pinned Playerbot core. It is applied automatically during bootstrap.

## Client connection

On the same machine, set the WotLK client file `Data/<locale>/realmlist.wtf` to:

```text
set realmlist 127.0.0.1
```

For LAN access, set both `WOW_BIND_ADDRESS` and `WOW_REALM_ADDRESS` to the host LAN IP, recreate `ac-worldserver`, and use that IP in `realmlist.wtf`.

## Configuration

Copy `.env.example` to `.env`. Changes take effect with:

```bash
cd server
docker compose up -d --force-recreate ac-worldserver
```

| Setting | Default | Description |
| --- | --- | --- |
| `WOW_BIND_ADDRESS` | `127.0.0.1` | Host address used to publish Docker ports. Keep local-only unless LAN access is required. |
| `WOW_REALM_NAME` | `My WotLK Realm` | Realm name shown by the client. |
| `WOW_REALM_ADDRESS` | `127.0.0.1` | Address sent to the client; must match the client realmlist. |
| `DOCKER_DB_ROOT_PASSWORD` | example value | MySQL root password. Set before first start; do not change it afterward without migrating the existing database. |
| `DOCKER_*_EXTERNAL_PORT` | `3306`, `3724`, `8085`, `7878` | Published MySQL, auth, world, and SOAP ports. Keep MySQL and SOAP local-only. |
| `DOCKER_GAME_STATE_API_BIND_ADDRESS`, `DOCKER_GAME_STATE_API_EXTERNAL_PORT` | `127.0.0.1`, `8080` | Host binding and port for the optional Game State API. Local-only by default. |
| `WOW_DB_DATA_DIR` | `../data/mysql` | Host path for the MySQL data directory, evaluated from `server/`. |
| `WOW_GAME_TYPE` | `0` | Realm type: `0` PvE, `1` PvP. |
| `WOW_MAX_PLAYERS` | `20` | Maximum real player connections. |
| `WOW_MAP_UPDATE_THREADS` | `2` | Map update threads. Use no more than available CPU cores. |
| `WOW_RATE_XP_KILL`, `WOW_RATE_XP_QUEST`, `WOW_RATE_MONEY` | `1` | Kill XP, quest XP, and money rate multipliers. |
| `WOW_DATABASE_UPDATES` | `7` | Databases to update on startup: `1` auth, `2` characters, `4` world; `7` applies all official pending updates. |
| `WOW_PLAYERBOTS_ENABLED` | `1` | Enables Playerbots. |
| `WOW_RANDOM_BOTS_AUTOLOGIN` | `1` | Automatically logs in random bots. |
| `WOW_RANDOM_BOTS_MIN`, `WOW_RANDOM_BOTS_MAX` | `30`, `50` | Random bot target range. Increase gradually while monitoring CPU and RAM. |
| `WOW_BOTS_ONLY_WITH_PLAYERS` | `0` | `1` keeps bots online only while a real player is present. |
| `WOW_AHBOT_GUIDS` | `0` | GUID of a dedicated normal auctioneer character; never use a Playerbot GUID. |
| `WOW_AHBOT_SELLER`, `WOW_AHBOT_BUYER` | `true` | Enables auction listing and purchasing behavior. |
| `WOW_AHBOT_ITEMS_PER_CYCLE` | `300` | New listings per cycle. Temporarily use `600` for initial population if performance permits. |
| `WOW_AHBOT_BUY_CANDIDATES` | `5` | Listings assessed per auction house on each buy cycle. |
| `WOW_AHBOT_BUY_PRICE_MODIFIER` | `0.85` | Maximum share of calculated price paid by the buyer. |
| `WOW_AHBOT_ALLIANCE_ITEMS`, `WOW_AHBOT_HORDE_ITEMS`, `WOW_AHBOT_NEUTRAL_ITEMS` | `1500`, `1500`, `500` | Target listing count for each auction house. |
| `WOW_TRANSMOG_ENABLED` | `1` | Enables transmogrification. |
| `WOW_TRANSMOG_COLLECTION` | `1` | Collects appearances from equipped and quest reward items. |
| `WOW_TRANSMOG_VENDOR_INTERFACE` | `1` | Enables the preview vendor interface. |
| `WOW_TRANSMOG_PORTABLE` | `1` | Enables the portable transmogrification NPC. |
| `WOW_TRANSMOG_SCALED_COST` | `0.0` | Standard transmog cost multiplier; `0.0` makes it free with zero copper cost. |
| `WOW_TRANSMOG_COPPER_COST` | `0` | Fixed additional transmog price in copper. `10000` copper is one gold. |
| `WOW_TRANSMOG_MIXED_WEAPONS` | `1` | Weapon appearance rules: `0` strict, `1` modern compatibility, `2` unrestricted. |

Most module settings are controlled from `.env`; `conf/wow.env.template` converts them to AzerothCore `AC_*` environment variables. Module `*.conf` files are created in `server/env/dist/etc/modules/`. Dungeon Clear deliberately keeps its tuning in its own module configuration so that settings can also be overridden temporarily by its companion addon.

| Module | `.env` settings | Notes |
| --- | --- | --- |
| Dungeon Respawn | `WOW_DUNGEON_RESPAWN_ENABLED`, `WOW_DUNGEON_RESPAWN_HEALTH_PCT` | Returns a dead player to the dungeon entrance with the selected health percentage. |
| Dungeon Clear | `server/env/dist/etc/modules/mod_dungeon_clear.conf` | No `.env` switch is required. The tank bot is enabled per group with `.dc on`; its server defaults live in this config file. |
| IP Tracker | `WOW_IP_TRACKER_ENABLED`, `WOW_IP_TRACKER_CLEANUP_DAYS` | Records account IP history. `0` disables automatic cleanup. |
| Autofish | `WOW_AUTOFISH_*` | Controls bobber scan timing/range, automatic looting/recasting, and optional required item/equipment IDs. |
| Game State API | `WOW_GAME_STATE_API_*` | Disabled by default. When enabled it listens on container port `8080`, published to `127.0.0.1:8080` by default. It has no authentication; do not expose it publicly. |
| Autosort | `WOW_AUTOSORT_*` | Controls stack merging, bag sorting, login sorting, cooldown, pinned items, and periodic sorting. |
| Autolearn Skills | `WOW_AUTOLEARN_*` | Controls weapon skills, riding ranks, mounts, and Cold Weather Flying. Default grants only Apprentice riding/mount. |
| AOE Loot | `WOW_AOE_LOOT_ENABLED`, `WOW_AOE_LOOT_MESSAGE`, `WOW_AOE_LOOT_RANGE`, `WOW_AOE_LOOT_IN_GROUP` | Official AzerothCore module. Merges nearby eligible creature loot into the selected corpse; range is 5–100 yards and group support is configurable. Login message is disabled by default. |

After changing `.env`, apply the values with:

```bash
cd server
docker compose up -d --force-recreate ac-worldserver
```

To enable the Game State API locally, set `WOW_GAME_STATE_API_ENABLED=1` and restart the worldserver. Access it at `http://127.0.0.1:8080`. For LAN access, set `DOCKER_GAME_STATE_API_BIND_ADDRESS` to the host LAN IP and restrict it with a firewall.

### Dungeon Clear: autonomous bot-led dungeon runs

Dungeon Clear is an extension for `mod-playerbots`: a **tank bot** leads a real-player party through an instance, routes to bosses, pulls packs, rests, loots, and handles many scripted events. The healer and DPS bots support that tank automatically. It does not control a player-operated tank; play a follower, or use Playerbot self-bot mode if you want your character driven by AI.

Enter an instance with a bot tank in your group, then use one of these commands as the real player in that group:

| Command | Result |
| --- | --- |
| `.dc on` / `.dc off` | Start or stop autonomous clearing. On stop, bots return to their normal following behaviour. |
| `.dc pause` | Pause in place; run it again to resume. |
| `.dc skip` | Skip the current objective when the tank is stuck. |
| `.dc pull` | Cycle pull style: Dynamic (default), Leeroy (faster/riskier), Advanced (safer/slower). |
| `.dc status` | Show current run state. |
| `.dc bosses` | Show bosses and their completion state. |
| `.dc go <boss>` | Send the tank toward a specific named boss. |
| `.dc config` | Show the effective settings for the current run. |
| `.dc spectate` | Toggle GM spectator camera; `.dc spectate follow <bot>` follows a bot. |

The equivalent in-party chat keywords are `dc on`, `dc off`, `dc pause`, `dc skip`, `dc pull`, `dc status`, and `dc bosses` (long forms such as `dungeon clear on` also work). `.dc test` is a GM-only automated test harness and is not needed for normal play.

For a visual in-game control panel, install the optional [Dungeon Clear companion addon](https://github.com/jrad7/mod-dungeon-clear-addon) in the game client separately. It can start, pause, skip, select pull mode, display status, and apply temporary per-run overrides; it is not bundled with this server.

#### Dungeon Clear settings

The persistent defaults are in `server/env/dist/etc/modules/mod_dungeon_clear.conf`. Edit that file and reload it with `.reload config` (or recreate `ac-worldserver`). The most useful defaults are:

| Setting | Default | Effect |
| --- | --- | --- |
| `DungeonClear.LootMinQuality` | `0` | Lowest loot quality to collect: `0` grey through `4` epic. |
| `DungeonClear.RestHealthPct`, `DungeonClear.RestManaPct` | `0`, `0` | Rest targets; `0` inherits Playerbot's normal thresholds. |
| `DungeonClear.SmartRest` | `0` | `1` uses fewer, full group rest cycles; its health/mana trigger settings are alongside it. |
| `DungeonClear.PullDynamicMaxLeeroyMobs` | `5` | Maximum estimated pack size the Dynamic mode will take directly. Lower it for more cautious pulls. |
| `DungeonClear.IgnoreChests` | `1` | Ignore world-object chests to reduce detours; `0` allows chest looting. |
| `DungeonClear.PreventBotRelease` | `1` | Keeps bots' instance corpses for resurrection instead of automatically releasing. |

Any `DungeonClear.*` setting can have a heroic-specific value by adding `.Heroic`, for example `DungeonClear.PullDynamicMaxLeeroyMobs.Heroic = 2`. The companion addon can override the general settings only for its current run; server-side file values remain the defaults. See the generated `.conf` for the full, commented configuration reference.

### Game State API endpoints

The API has no web page at `/`; use an `/api/...` endpoint. All responses are JSON.

| Endpoint | Description |
| --- | --- |
| `GET /api/health` | Health check and server uptime. |
| `GET /api/server` | Current server time, uptime, session, and player counts. |
| `GET /api/players` | Online player list. Add `?equipment=true` to include equipment. |
| `GET /api/player/<name>` | Detailed data for one online player. Add `?equipment=true` to include equipment. |
| `GET /api/player/<name>/stats` | Character stats, health, powers, and combat values. |
| `GET /api/player/<name>/equipment` | Equipped items and item details. |
| `GET /api/player/<name>/skills` | Active skills and talent data. |
| `GET /api/player/<name>/skills-full` | Complete skills and talent data, including passive skills. |
| `GET /api/player/<name>/quests` | Active quest data. |

Examples:

```bash
curl http://127.0.0.1:8080/api/health
curl http://127.0.0.1:8080/api/server
curl 'http://127.0.0.1:8080/api/player/CharacterName/stats'
```

The endpoints expose live player and realm information without authentication. Keep the default local-only API binding unless access is protected by a firewall or reverse proxy.

To add the portable Transmog NPC as a GM:

```text
.npc add 190010
```

## Auction bot setup

Create a dedicated normal account and character named `Auctioneer`. After that character has logged out, run:

```bash
./scripts/enable-ahbot.sh Auctioneer
```

Then use a GM character to run `.ahbot update` in game for immediate population.

## Published images

GitHub Actions runs on `ubuntu-24.04`, builds `linux/amd64`, and publishes the complete air-gapped image set. Each image receives the same three tags: `latest`, the UTC build date (`YYYYMMDD`), and the full Git SHA.

```text
bral1488/wowlk:latest
bral1488/wowlk:YYYYMMDD
bral1488/wowlk:<full-git-sha>

bral1488/wowlk-worldserver:<same-tag>
bral1488/wowlk-authserver:<same-tag>
bral1488/wowlk-db-import:<same-tag>
bral1488/wowlk-client-data:<same-tag>
```

`bral1488/wowlk` is a convenient alias for `bral1488/wowlk-worldserver`. For a fully offline first deployment, also preload `mysql:8.4`, which is the database image used by Compose.

## Backups

```bash
./scripts/backup-db.sh
```

The compressed SQL backup is written to `backups/`. Pass another output directory as the first argument if needed.
