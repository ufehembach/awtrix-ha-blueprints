# awtrix-ha-blueprints

Home Assistant Blueprints für ein AWTRIX3-Display (Ulanzi TC001, 32×8 Pixel), Netzwerk-Monitoring
über MQTT auf Basis eines GL.iNet AR750S (Telekom-SIM, 5G/LTE) bzw. UDM Pro.

## Blueprints

| Datei | Zweck | Import |
|---|---|---|
| `awtrix_net_history_chart.yaml` | Live-Speed-Text + rollierender 2h-Verlaufs-Chart (`netspeed`/`netchart`) | [![Blueprint importieren](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fufehembach%2Fawtrix-ha-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fufe%2Fawtrix_net_history_chart.yaml) |
| `awtrix_internet_status.yaml` | Online/Offline-Status mit Speed-Popup bei Reconnect und Warnton bei Ausfall | [![Blueprint importieren](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fufehembach%2Fawtrix-ha-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fufe%2Fawtrix_internet_status.yaml) |
| `awtrix_reset_history.yaml` | Manueller Reset des Verlaufs (kein Trigger, per „Ausführen"-Button) | [![Blueprint importieren](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fufehembach%2Fawtrix-ha-blueprints%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fufe%2Fawtrix_reset_history.yaml) |

## Installation

Auf das Badge in der Tabelle klicken. Home Assistant öffnet den Import-Dialog, dort
**Blueprint importieren** bestätigen. Danach unter *Einstellungen → Automatisierungen & Szenen → Blueprints*
das Blueprint sehen und pro Display eine Automation daraus erstellen.

Alternativ ohne Badge: *Einstellungen → Automatisierungen & Szenen → Blueprints → Blueprint importieren*
und die GitHub-Blob-URL der gewünschten Datei einfügen.

## Benötigte Helper

Die Helper liegen in `packages/awtrix_helpers.yaml` (als Package unter `/config/packages/` einbinden).
Nach dem Anlegen ist ein vollständiger Neustart nötig, ein Neuladen reicht bei neuen `input_text`-Helfern nicht.

- `awtrix_max_down`, `awtrix_max_up` — letzter guter Speedtest-Referenzwert
- `download_rate_history`, `upload_rate_history` — JSON-Array, Verlauf
- `awtrix_hist_last_append` — Zeitstempel letzter Append
- `awtrix_text_cycle` — 0/1, wechselt Down/Up-Anzeige

**Wichtig:** Bei allen Automationen dieselben `input_text`-Helper auswählen, sonst
laufen Max-Referenz und Verlauf auseinander.

## Entwicklung

Änderungen am Repo lassen sich per `sync_to_ha.sh` (rsync) direkt in eine HA-Instanz kopieren.
Dry-Run mit `-n`, Löschen veralteter Dateien mit `-d`.
