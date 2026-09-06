#!/usr/bin/env python3
"""
Listet alle Apps (inkl. Custom Apps) auf einem AWTRIX3-Gerät auf
und loescht eine ausgewaehlte Custom App per HTTP-API.

Nutzung:
    python3 awtrix_delete_app.py <ip-oder-hostname>

Beispiel:
    python3 awtrix_delete_app.py awtrix_d01974.local
    python3 awtrix_delete_app.py 192.168.1.50
"""

import sys
import json
import urllib.request
import urllib.error
import urllib.parse


def fetch_loop(base_url: str) -> dict:
    url = f"{base_url}/api/loop"
    with urllib.request.urlopen(url, timeout=5) as resp:
        data = resp.read()
    return json.loads(data)


def delete_app(base_url: str, name: str) -> None:
    url = f"{base_url}/api/custom?name={urllib.parse.quote(name)}"
    req = urllib.request.Request(url, data=b"", method="POST")
    with urllib.request.urlopen(req, timeout=5) as resp:
        print(f"Status: {resp.status}")


def main():
    if len(sys.argv) != 2:
        print("Nutzung: python3 awtrix_delete_app.py <ip-oder-hostname>")
        sys.exit(1)

    host = sys.argv[1]
    base_url = f"http://{host}"

    try:
        apps = fetch_loop(base_url)
    except urllib.error.URLError as e:
        print(f"Fehler beim Abfragen von {base_url}/api/loop: {e}")
        sys.exit(1)

    if not apps:
        print("Keine Apps gefunden.")
        sys.exit(0)

    # Sortiert nach Position in der Loop-Reihenfolge
    sorted_apps = sorted(apps.items(), key=lambda kv: kv[1])

    print(f"\nApps auf {host}:\n")
    for idx, (name, position) in enumerate(sorted_apps, start=1):
        print(f"  {idx}) {name}  (Position {position})")

    print()
    choice = input("Nummer der zu loeschenden App (oder Enter zum Abbrechen): ").strip()

    if not choice:
        print("Abgebrochen.")
        sys.exit(0)

    try:
        choice_idx = int(choice)
        if not (1 <= choice_idx <= len(sorted_apps)):
            raise ValueError
    except ValueError:
        print("Ungueltige Auswahl.")
        sys.exit(1)

    app_name = sorted_apps[choice_idx - 1][0]
    confirm = input(f"'{app_name}' wirklich loeschen? (j/N): ").strip().lower()

    if confirm != "j":
        print("Abgebrochen.")
        sys.exit(0)

    try:
        delete_app(base_url, app_name)
        print(f"'{app_name}' geloescht.")
    except urllib.error.URLError as e:
        print(f"Fehler beim Loeschen: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
