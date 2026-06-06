# RustDesk Self-Hosted Server

## Server starten

```bash
docker compose up -d
```

Den Public Key nach dem ersten Start auslesen:

```bash
cat /opt/stacks/rustdesk/data/*.pub
```

Diesen Key brauchst du für die Client-Konfiguration.

---

## RustDesk App einrichten

### 1. App herunterladen

[https://rustdesk.com/de/](https://rustdesk.com/de/) → passende Version für dein Betriebssystem.

### 2. Eigenen Server eintragen

In der App:

```
Einstellungen (⚙) → Netzwerk → ID-Server / Relay-Server
```

| Feld | Wert |
|---|---|
| ID-Server | `rustdesk.example.com` |
| Relay-Server | `rustdesk.example.com` |
| API-Server | *(leer lassen)* |
| Key | `<Public Key aus *.pub Datei>` |

Danach **Anwenden** klicken – die App verbindet sich neu.

### 3. Verbindung testen

In der Hauptansicht erscheint deine ID. Trage diese ID bei einer anderen RustDesk-Instanz ein und klicke **Verbinden**.

---

## Ports (müssen in der Firewall freigegeben sein)

| Port | Protokoll | Zweck |
|---|---|---|
| 21115 | TCP | NAT-Type-Test |
| 21116 | TCP + UDP | ID-Registrierung & Heartbeat |
| 21117 | TCP | Relay-Traffic |

> Diese Ports laufen **direkt** – kein HTTP-Proxy über NPM möglich.

---

## Wartung

```bash
# Logs
docker compose logs -f

# Update
docker compose pull && docker compose up -d

# Key anzeigen
cat /opt/stacks/rustdesk/data/*.pub
```
