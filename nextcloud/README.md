# ☁️ **OwnCloud File Storage**

## 📋 **Übersicht**

OwnCloud ist eine Open-Source File-Sync-und-Share-Lösung mit Self-Hosting, Collaboration-Tools und Mobile-Apps.

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
   docker compose logs -f owncloud
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://cloud.saarlandletsplay.de`
- **Admin-Login**: `admin` / `Y7uK3pL9xF2vN6mT`

## ⚙️ **Konfiguration**

### **Ports**
- `85`: Web-Interface (intern)
- Extern über Nginx Proxy Manager

### **Datenbank-Verbindung**
- **Host**: `mysql`
- **Port**: `3306`
- **Datenbank**: `owncloud_db`
- **Benutzer**: `owncloud`
- **Passwort**: `owncloud_pass`

### **Redis-Einstellungen**
- **Status**: Deaktiviert (`OWNCLOUD_REDIS_ENABLED: "false"`)
- **Grund**: Vereinfachung der Konfiguration

## 📁 **Verzeichnisstruktur**

```
owncloud/
├── compose.yml          # Docker-Konfiguration
├── .env                 # Umgebungsvariablen
├── data/               # OwnCloud Daten
│   ├── config/         # Konfigurationsdateien
│   ├── files/          # Benutzerdateien
│   └── apps/           # Apps
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **OwnCloud-Einstellungen**
```env
OWNCLOUD_DOMAIN=cloud.saarlandletsplay.de
OWNCLOUD_DB_TYPE=mysql
OWNCLOUD_DB_NAME=owncloud_db
OWNCLOUD_DB_USERNAME=owncloud
OWNCLOUD_DB_PASSWORD=owncloud_pass
OWNCLOUD_DB_HOST=mysql
```

### **Admin-Zugang**
```env
OWNCLOUD_ADMIN_USERNAME=admin
OWNCLOUD_ADMIN_PASSWORD=Y7uK3pL9xF2vN6mT
```

### **Domain-Einstellungen**
```env
OWNCLOUD_TRUSTED_DOMAINS=cloud.saarlandletsplay.de
OWNCLOUD_OVERWRITEHOST=cloud.saarlandletsplay.de
OWNCLOUD_OVERWRITEPROTOCOL=https
OWNCLOUD_OVERWRITECLIURL=https://cloud.saarlandletsplay.de
```

## 👥 **Benutzerverwaltung**

### **Benutzer erstellen**
1. Admin-Login
2. "Users" → "Add user"
3. Benutzername und E-Mail eingeben
4. Passwort festlegen
5. Gruppen zuweisen

### **Gruppen erstellen**
1. "Groups" → "Add group"
2. Gruppenname eingeben
3. Benutzer zu Gruppen hinzufügen

### **Berechtigungen**
- **Admin**: Vollzugriff
- **User**: Eigene Dateien
- **Guest**: Lesen (konfigurierbar)

## 📁 **Datei-Management**

### **Dateien hochladen**
1. Web-Interface → "Files"
2. "Upload" Button
3. Dateien auswählen
4. Oder Drag & Drop

### **Ordner erstellen**
1. "New folder" Button
2. Ordnername eingeben
3. Berechtigungen festlegen

### **Sharing**
1. Datei/Ordner auswählen
2. "Share" Button
3. Benutzer/Gruppe auswählen
4. Berechtigungen festlegen (Read/Write)

### **Versionierung**
- Automatische Versionierung
- Alte Versionen wiederherstellen
- Verlauf einsehen

## 📱 **Apps**

### **Standard-Apps**
- **Files**: Datei-Management
- **Gallery**: Bild-Anzeige
- **Music**: Musik-Player
- **Calendar**: Kalender
- **Contacts**: Kontakte

### **Zusätzliche Apps**
1. "Apps" → "Apps"
2. App auswählen
3. "Enable" klicken

### **Beliebte Apps**
- **OnlyOffice**: Office-Dokumente
- **Collabora Online**: Online-Editor
- **Social**: Social Media Integration
- **Bookmarks**: Lesezeichen
- **Notes**: Notizen

## 🔌 **Integrationen**

### **WebDAV**
```bash
# URL
https://cloud.saarlandletsplay.de/remote.php/dav/files/admin/

# Mount mit davfs2
sudo mount -t davfs https://cloud.saarlandletsplay.de/remote.php/dav/files/admin/ /mnt/owncloud
```

### **CalDAV/CardDAV**
```bash
# CalDAV (Kalender)
https://cloud.saarlandletsplay.de/remote.php/dav/calendars/admin/

# CardDAV (Kontakte)
https://cloud.saarlandletsplay.de/remote.php/dav/addressbooks/users/admin/
```

### **Mobile Apps**
- **Android**: OwnCloud Files
- **iOS**: OwnCloud
- **Desktop**: OwnCloud Desktop Client

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f owncloud
```

### **System-Informationen**
1. Admin-Panel → "Settings" → "Admin"
2. System-Status prüfen
3. Speicherplatz anzeigen
4. Benutzer-Statistiken

### **Performance**
- Cache-Status
- Database-Performance
- File-System-Health

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Daten sichern
tar -czf owncloud_backup.tar.gz data/

# Datenbank sichern
docker exec mysql mysqldump -u root -pR7x2!vBfP9qK owncloud_db > owncloud_db_backup.sql
```

### **Update durchführen**
```bash
# Image aktualisieren
docker compose pull

# Container neu starten
docker compose up -d

# Database-Update
docker exec owncloud occ upgrade
```

### **Wartungsaufgaben**
```bash
# Cache leeren
docker exec owncloud occ cache:clear

# Dateien scannen
docker exec owncloud occ files:scan --all

# Trash leeren
docker exec owncloud occ trashbin:cleanup --all-users
```

## 🚨 **Fehlerbehandlung**

### **Login-Probleme**
1. Admin-Benutzer prüfen
2. Passwort zurücksetzen
3. Browser-Cache leeren

### **Datei-Probleme**
1. Speicherplatz prüfen
2. Berechtigungen prüfen
3. Dateien neu scannen

### **Performance-Probleme**
1. Cache leeren
2. Datenbank optimieren
3. PHP-Einstellungen prüfen

### **Sync-Probleme**
1. Netzwerkverbindung prüfen
2. Client-Update prüfen
3. Konflikt-Dateien prüfen

## 🔐 **Sicherheit**

### **Zugangskontrolle**
- Starke Passwörter
- 2FA aktivieren
- IP-Whitelist

### **Datei-Sicherheit**
- Verschlüsselte Verbindung
- Datei-Verschlüsselung
- Access-Control

### **Backup-Sicherheit**
- Regelmäßige Backups
- Offsite-Storage
- Verschlüsselte Backups

## 📚 **Nützliche Links**

- [OwnCloud Dokumentation](https://doc.owncloud.org/)
- [OwnCloud Apps](https://apps.owncloud.com/)
- [WebDAV Protokoll](https://webdav.io/)
- [CalDAV/CardDAV](https://caldav.org/)

---

*OwnCloud - Your Cloud, Your Data* ☁️
