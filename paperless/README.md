# Paperless-ngx

## Übersicht

Dokumenten-Management-System mit OCR, automatischer Klassifizierung und Volltextsuche. Nutzt die zentrale PostgreSQL-Instanz.

## Services

| Service | Image | Beschreibung |
|---|---|---|
| **paperless** | `ghcr.io/paperless-ngx/paperless-ngx:latest` | Hauptanwendung |
| **paperless-redis** | `redis:7-alpine` | Task-Broker |
| **paperless-tika** | `ghcr.io/paperless-ngx/tika:latest` | Dokumenten-Parsing (Word, Excel, etc.) |
| **paperless-gotenberg** | `gotenberg/gotenberg:8` | PDF-Konvertierung |

## Zugang

| URL | Beschreibung |
|---|---|
| `https://paperless.example.com` | Paperless Web-UI (über NPM) |

**Admin-Login:** `admin` / siehe `.env` → `PAPERLESS_ADMIN_PASSWORD`

## Datenbank

Nutzt die zentrale PostgreSQL-Instanz (`postgresql`):
- **Datenbank:** `paperless_db`
- **User:** `paperless`

## Volumes

| Volume | Beschreibung |
|---|---|
| `paperless_data` | Interne Daten & Index |
| `paperless_media` | Gespeicherte Dokumente |
| `paperless_consume` | Eingangsordner für neue Dokumente |
| `paperless_export` | Export-Verzeichnis |
| `paperless_redis` | Redis-Daten |

## Dokumente einlesen

Dokumente in den Consume-Ordner legen:
```bash
# Datei in den Consume-Ordner kopieren
docker cp mein-dokument.pdf paperless:/usr/src/paperless/consume/

# Oder direkt im Container-Volume
docker exec paperless document_consumer
```

## NPM Proxy-Host

| Feld | Wert |
|---|---|
| **Forward Hostname** | `paperless` |
| **Forward Port** | `8000` |
| **Scheme** | `http` |

## Wartung

```bash
# Logs anzeigen
docker logs paperless --tail 50

# Dokumente neu indexieren
docker exec -u paperless paperless document_index reindex

# Backup exportieren
docker exec -u paperless paperless document_exporter /usr/src/paperless/export

# Admin-User Passwort ändern
docker exec -u paperless paperless createsuperuser
```
