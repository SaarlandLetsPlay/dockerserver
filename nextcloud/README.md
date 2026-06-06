# ☁️ **Nextcloud**

## 📋 **Übersicht**

Nextcloud ist eine Open-Source File-Sync-und-Share-Lösung mit Self-Hosting, Collaboration-Tools, Mobile-Apps und AppAPI für externe Apps.

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
   docker compose logs -f nextcloud
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://cloud.example.com`
- **Admin-Login**: Siehe `.env` (`NEXTCLOUD_ADMIN_USER` / `NEXTCLOUD_ADMIN_PASSWORD`)

## ⚙️ **Konfiguration**

### **Ports**
- `85`: Web-Interface (intern)
- Extern über Nginx Proxy Manager (HTTPS)

### **Datenbank-Verbindung**
- **Host**: `mysql` (externer MySQL-Stack)
- **Port**: `3306`
- **Datenbank**: `nextcloud_db`
- **Benutzer**: `nextcloud`
- **Passwort**: Siehe `.env`

### **Redis-Cache**
- **Container**: `nextcloud-redis` (Redis 7 Alpine)
- **Funktion**: Distributed Cache, File-Locking, Memcache
- **Healthcheck**: Automatisch, Nextcloud startet erst nach Redis

### **AppAPI Deploy Daemon**
- **Docker Socket** wird gemountet für externe App-Installation
- **Berechtigungen** werden automatisch beim Start über `docker-socket-fix.sh` gesetzt

## 📁 **Verzeichnisstruktur**

```
nextcloud/
├── compose.yml            # Docker-Konfiguration
├── .env                   # Umgebungsvariablen (Credentials)
├── docker-socket-fix.sh   # Entrypoint-Wrapper für Docker Socket
└── README.md              # Diese Datei
```

## 🔧 **Umgebungsvariablen (.env)**

| Variable | Beschreibung | Standard |
|---|---|---|
| `NEXTCLOUD_VERSION` | Docker Image Tag | `latest` |
| `NEXTCLOUD_PORT` | Interner Port | `85` |
| `MYSQL_HOST` | Datenbank-Host | `mysql` |
| `MYSQL_DATABASE` | Datenbank-Name | `nextcloud_db` |
| `MYSQL_USER` | Datenbank-Benutzer | `nextcloud` |
| `MYSQL_PASSWORD` | Datenbank-Passwort | – |
| `NEXTCLOUD_ADMIN_USER` | Admin-Benutzername | `admin` |
| `NEXTCLOUD_ADMIN_PASSWORD` | Admin-Passwort | – |
| `NEXTCLOUD_DOMAIN` | Domain für Trusted Domains & Overwrite | – |

## 🔌 **Integrationen**

### **WebDAV**
```
https://cloud.example.com/remote.php/dav/files/<user>/
```

### **CalDAV (Kalender)**
```
https://cloud.example.com/remote.php/dav/calendars/<user>/
```

### **CardDAV (Kontakte)**
```
https://cloud.example.com/remote.php/dav/addressbooks/users/<user>/
```

### **Mobile & Desktop Apps**
- **Android**: Nextcloud Files (F-Droid / Play Store)
- **iOS**: Nextcloud (App Store)
- **Desktop**: Nextcloud Desktop Client (Linux, macOS, Windows)

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Datenbank sichern
docker exec mysql mysqldump -u nextcloud -p nextcloud_db > nextcloud_db_backup.sql

# Daten-Volume sichern
docker run --rm -v nextcloud_nextcloud_files:/data -v $(pwd):/backup alpine tar -czf /backup/nextcloud_files.tar.gz /data
```

### **Update durchführen**
```bash
# Image aktualisieren
docker compose pull

# Container neu starten
docker compose up -d

# ggf. Database-Update
docker exec -u 33 nextcloud php occ upgrade
```

### **Wartungsaufgaben**
```bash
# Dateien scannen
docker exec -u 33 nextcloud php occ files:scan --all

# Cache leeren
docker exec -u 33 nextcloud php occ cache:clear

# Fehlende DB-Indices hinzufügen
docker exec -u 33 nextcloud php occ db:add-missing-indices

# Trash leeren
docker exec -u 33 nextcloud php occ trashbin:cleanup --all-users
```

### **Konfiguration per CLI**
```bash
# Alle System-Config anzeigen
docker exec -u 33 nextcloud php occ config:system:get trusted_domains

# Setup-Checks ausführen
docker exec -u 33 nextcloud php occ setupchecks
```

## 📚 **Nützliche Links**

- [Nextcloud Dokumentation](https://docs.nextcloud.com/)
- [Nextcloud Apps](https://apps.nextcloud.com/)
- [Nextcloud GitHub](https://github.com/nextcloud)

---

*Nextcloud - Your Cloud, Your Data* ☁️
