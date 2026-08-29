# awtrix-ha-blueprints

Home Assistant Blueprints für ein AWTRIX3-Display (`awtrix_d01974`), Netzwerk-Monitoring
über MQTT auf Basis eines GL.iNet AR750S (Telekom-SIM, 5G/LTE).

## Blueprints

| Datei | Zweck |
|---|---|
| `awtrix_net_history_chart.yaml` | Live-Speed-Text + rollierender 2h-Verlaufs-Chart (`netspeed`/`netchart`) |
| `awtrix_internet_up.yaml` | Speed-Popup bei Reconnect oder Button-Druck, stößt frischen Speedtest an |
| `awtrix_internet_down.yaml` | Offline-Popup mit Warnton |
| `awtrix_reset_history.yaml` | Manueller Reset des Verlaufs (kein Trigger, per "Ausführen"-Button) |

## Benötigte Helper (`input_text`, unter Einstellungen → Helfer anlegen)

- `awtrix_max_down`, `awtrix_max_up` — letzter guter Speedtest-Referenzwert
- `download_rate_history`, `upload_rate_history` — JSON-Array, Verlauf
- `awtrix_hist_last_append` — Zeitstempel letzter Append
- `awtrix_text_cycle` — 0/1, wechselt Down/Up-Anzeige
- `awtrix_blink_frame` — 0-5, Aktivitäts-Pulsanimation

## Installation auf dem Home-Assistant-Host

```bash
rsync -av --delete blueprints/ pi@<HA-HOST>:/config/blueprints/
```

Danach in HA: Entwicklerwerkzeuge → YAML → *Alle YAML-Konfigurationen neu laden*
(oder Neustart), dann Einstellungen → Automatisierungen & Szenen → Blueprints-Reiter →
für jedes Blueprint eine Automation erstellen und die passenden Entities auswählen.

**Wichtig:** Bei allen Automationen dieselben `input_text`-Helper auswählen, sonst
laufen Max-Referenz und Verlauf auseinander.
