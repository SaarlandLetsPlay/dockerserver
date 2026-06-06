# 📧 **Open Archiver**

## 📋 **Übersicht**

Open Archiver ist eine Open-Source E-Mail-Archivierungslösung mit Volltextsuche, Verschlüsselung und Compliance-Features. Unterstützt IMAP, Google Workspace, Microsoft 365, PST- und Mbox-Dateien.

## 🚀 **Schnellstart**

1. **Konfiguration anpassen:**
   ```bash
   nano .env
   ```

2. **Server starten:**
   ```bash
   docker compose up -d
   ```

3. **Logs ansehen:**
   ```bash
   docker compose logs -f open-archiver
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://archiver.example.com`
- **Interner Port**: `3100`

## ⚙️ **Konfiguration**

### **Ports**
- `3100`: Web-Interface (intern, gemappt auf Container-Port 3000)
- Extern über Nginx Proxy Manager (HTTPS)

### **Services**
| Service | Container | Beschreibung |
|---|---|---|
| Open Archiver | `open-archiver` | Frontend + Backend |
| PostgreSQL 17 | `oa-postgres` | Metadaten-Datenbank |
| Valkey 8 | `oa-valkey` | Job Queue (Redis-kompatibel) |
| Meilisearch | `oa-meilisearch` | Volltextsuche |
| Apache Tika | `oa-tika` | Dokumenten-Parsing (PDF, DOCX, etc.) |

## 📁 **Verzeichnisstruktur**

```
openarchiver/
├── compose.yml    # Docker-Konfiguration (5 Services)
├── .env           # Umgebungsvariablen (Credentials, Keys)
└── README.md      # Diese Datei
```

## 🔧 **Umgebungsvariablen (.env)**

| Variable | Beschreibung | Standard |
|---|---|---|
| `OA_PORT` | Externer Port | `3100` |
| `APP_URL` | Öffentliche URL | – |
| `POSTGRES_DB` | Datenbank-Name | `open_archive` |
| `POSTGRES_USER` | Datenbank-Benutzer | `openarchiver` |
| `POSTGRES_PASSWORD` | Datenbank-Passwort | – |
| `MEILI_MASTER_KEY` | Meilisearch API-Key | – |
| `REDIS_PASSWORD` | Valkey/Redis Passwort | – |
| `JWT_SECRET` | JWT Signierung | – |
| `ENCRYPTION_KEY` | Master Encryption Key | – |
| `STORAGE_TYPE` | Speicher-Backend (`local`/`s3`) | `local` |
| `TIKA_URL` | Tika-Server URL | `http://oa-tika:9998` |

## 🔑 **Features**

- **E-Mail-Quellen**: IMAP, Google Workspace, Microsoft 365, PST, Mbox
- **Volltextsuche**: Über alle E-Mails und Anhänge (PDF, DOCX, etc.)
- **Verschlüsselung**: AES-256 at rest, File-Hash-Integrity
- **Compliance**: Retention Policies, Audit Trail, Legal Hold
- **Thread-Discovery**: Konversations-Erkennung

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Datenbank sichern
docker exec oa-postgres pg_dump -U openarchiver open_archive > oa_backup.sql

# Volumes sichern
docker run --rm -v openarchiver_oa_data:/data -v $(pwd):/backup alpine tar -czf /backup/oa_data.tar.gz /data
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

## 📚 **Nützliche Links**

- [Open Archiver Dokumentation](https://github.com/LogicLabs-OU/OpenArchiver)
- [Live Demo](https://demo.openarchiver.com)

---

*Open Archiver - Sichere E-Mail-Archivierung* 📧
