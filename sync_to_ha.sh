#!/usr/bin/env bash
# sync_to_ha.sh — kopiert Dateien aus dem Git-Repo per rsync in eine HA-Instanz.
#
# Die Quelle wird relativ zum Repo-Root ermittelt (ueber `git rev-parse
# --show-toplevel`, ausgehend vom Ordner, in dem dieses Script liegt) -
# nicht relativ zum aktuellen Arbeitsverzeichnis. Das Script kann also von
# ueberall aus aufgerufen werden (auch per vollem Pfad oder aus cron).
#
# Nutzung: ./sync_to_ha.sh [-n] [-d] <ziel> [unterordner]
#   ziel:        lokaler Pfad ODER rsync-Ziel  user@host:/pfad/
#   unterordner: Pfad relativ zum Repo-Root, Default: gesamtes Repo
#   -n           Dry-Run (nichts wird geschrieben, nur Vorschau)
#   -d           mit --delete (Zieldateien loeschen, die es in der Quelle
#                nicht mehr gibt - Vorsicht bei geteilten Zielordnern!)
#
# Beispiele:
#   ./sync_to_ha.sh -n /Users/uwe/ha-test/blueprints/automation/awtrix
#   ./sync_to_ha.sh uwe@h1docker0:/srv/homeassistant/blueprints/automation/awtrix blueprints/automation
#   ./sync_to_ha.sh -d uwe@h1piwowa:/srv/homeassistant/blueprints/automation/awtrix

set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") [-n] [-d] <ziel> [unterordner]" >&2
  echo "  ziel:        lokaler Pfad oder rsync-Ziel (user@host:/pfad/)" >&2
  echo "  unterordner: Pfad relativ zum Repo-Root, Default: gesamtes Repo" >&2
  echo "  -n           Dry-Run (rsync --dry-run)" >&2
  echo "  -d           mit --delete" >&2
  exit 1
}

DRY_RUN=()
DELETE=()
while getopts "nd" opt; do
  case "$opt" in
    n) DRY_RUN=(--dry-run) ;;
    d) DELETE=(--delete) ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

[[ $# -ge 1 ]] || usage
TARGET="$1"
SUBDIR="${2:-.}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)" \
  || { echo "Kein Git-Repo oberhalb von $SCRIPT_DIR gefunden." >&2; exit 1; }

SOURCE="${REPO_ROOT%/}/${SUBDIR#./}"
SOURCE="${SOURCE%/}/"
TARGET="${TARGET%/}/"

[[ -d "$SOURCE" ]] || { echo "Quelle nicht gefunden: $SOURCE" >&2; exit 1; }

echo "Repo:   $REPO_ROOT"
echo "Quelle: $SOURCE"
echo "Ziel:   $TARGET"

# in sync_to_ha.sh ergänzen:

PROFILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    -p|--profile) PROFILE="$2"; shift 2 ;;
    *) break ;;
  esac
done

# ... bestehender rsync-Block für den Rest des Repos ...

if [ -n "$PROFILE" ]; then
  src="$REPO_ROOT/packages/net_metrics-${PROFILE}.yaml"
  if [ ! -f "$src" ]; then
    echo "Kein Profil '$PROFILE' (erwartet: $src)" >&2
    exit 1
  fi
  rsync -a "$src" "$TARGET/packages/net_metrics.yaml"
  echo "Profil '$PROFILE' als packages/net_metrics.yaml deployed"
fi
