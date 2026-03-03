# 🗄️ **phpMyAdmin MySQL Management**

## 📋 **Übersicht**

phpMyAdmin ist ein webbasiertes Tool zur Verwaltung von MySQL-Datenbanken mit vollständigen CRUD-Operationen und SQL-Query-Editor.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f phpmyadmin
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `http://5.175.180.185:8080`
- **Standard-Login**: `root` / `R7x2!vBfP9qK`

## ⚙️ **Konfiguration**

### **Ports**
- `8080`: Web-Interface

### **MySQL-Verbindung**
- **Host**: `mysql`
- **Port**: `3306`
- **Standard-User**: `root`
- **Standard-Passwort**: `R7x2!vBfP9qK`

### **Arbitrary-Login**
- `PMA_ARBITRARY: 1`: Login auf beliebige Datenbanken erlauben

## 📁 **Verzeichnisstruktur**

```
phpmyadmin/
├── compose.yml          # Docker-Konfiguration
├── config/             # phpMyAdmin Konfiguration
│   └── config.inc.php  # Konfigurationsdatei
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **phpMyAdmin-Einstellungen**
```env
PMA_HOST=mysql
PMA_PORT=3306
PMA_ARBITRARY=1
PMA_USER=root
PMA_PASSWORD=R7x2!vBfP9qK
```

### **Custom-Konfiguration**
```php
// /opt/stacks/phpmyadmin/config/config.inc.php
$cfg['Servers'][1]['host'] = 'mysql';
$cfg['Servers'][1]['port'] = '3306';
$cfg['Servers'][1]['auth_type'] = 'cookie';
$cfg['Servers'][1]['user'] = 'root';
$cfg['Servers'][1]['password'] = 'R7x2!vBfP9qK';
```

## 🗄️ **Datenbank-Übersicht**

### **Verfügbare Datenbanken**
- `npm_db`: Nginx Proxy Manager
- `owncloud_db`: OwnCloud
- `grafana_db`: Grafana
- `information_schema`: MySQL System-Datenbank
- `mysql`: MySQL System-Datenbank
- `performance_schema`: MySQL Performance-Daten

### **Benutzer**
- `root`: Administrator (alle Rechte)
- `npm`: Nginx Proxy Manager (npm_db)
- `owncloud`: OwnCloud (owncloud_db)
- `grafana`: Grafana (grafana_db)

## 📊 **Datenbank-Management**

### **Tabellen anzeigen**
1. Datenbank auswählen
2. Tabellen-Liste anzeigen
3. Struktur und Daten einsehen

### **SQL-Queries ausführen**
1. "SQL" Tab auswählen
2. SQL-Query eingeben
3. "Go" klicken
4. Ergebnisse anzeigen

### **Beispiel-Queries**
```sql
-- Alle Datenbanken anzeigen
SHOW DATABASES;

-- Tabellen in Datenbank anzeigen
SHOW TABLES FROM npm_db;

-- Tabellen-Struktur anzeigen
DESCRIBE users;

-- Daten einfügen
INSERT INTO users (username, email) VALUES ('testuser', 'test@example.com');

-- Daten aktualisieren
UPDATE users SET email = 'new@example.com' WHERE username = 'testuser';

-- Daten löschen
DELETE FROM users WHERE username = 'testuser';
```

## 🔧 **Datenbank-Operationen**

### **Datenbank erstellen**
1. "New" → "Create database"
2. Datenbankname eingeben
3. Collation auswählen
4. "Create"

### **Benutzer erstellen**
1. "User accounts" → "Add user account"
2. Benutzername eingeben
3. Hostname auswählen (% für alle)
4. Passwort eingeben
5. Berechtigungen zuweisen

### **Tabelle erstellen**
1. Datenbank auswählen
2. "New" → "Create table"
3. Spalten definieren
4. Datentypen auswählen
5. "Save"

## 📈 **Monitoring**

### **System-Status**
1. "Status" Tab
2. MySQL-Status-Variablen
3. Performance-Metriken
4. Verbindungs-Statistiken

### **Prozessliste**
1. "SQL" → "Process list"
2. Aktive Queries anzeigen
3. Lange Queries identifizieren
4. Prozesse beenden

### **Variablen anzeigen**
```sql
-- Alle Variablen anzeigen
SHOW VARIABLES;

-- Speicher-Einstellungen
SHOW VARIABLES LIKE '%memory%';

-- Performance-Einstellungen
SHOW VARIABLES LIKE '%query_cache%';
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Komplette Datenbank sichern
docker exec mysql mysqldump -u root -pR7x2!vBfP9qK --all-databases > full_backup.sql

# Einzelne Datenbank sichern
docker exec mysql mysqldump -u root -pR7x2!vBfP9qK npm_db > npm_backup.sql

# Komprimiertes Backup
docker exec mysql mysqldump -u root -pR7x2!vBfP9qK --all-databases | gzip > full_backup.sql.gz
```

### **Backup wiederherstellen**
```bash
# Komplette Datenbank wiederherstellen
docker exec -i mysql mysql -u root -pR7x2!vBfP9qK < full_backup.sql

# Einzelne Datenbank wiederherstellen
docker exec -i mysql mysql -u root -pR7x2!vBfP9qK npm_db < npm_backup.sql
```

### **Optimierung**
```sql
-- Tabellen optimieren
OPTIMIZE TABLE table_name;

-- Fragmentierung prüfen
SHOW TABLE STATUS FROM database_name;

-- Indexe neu erstellen
ANALYZE TABLE table_name;
```

### **Logs ansehen**
```bash
docker compose logs -f phpmyadmin
```

## 🚨 **Fehlerbehandlung**

### **Verbindungsprobleme**
1. MySQL-Container prüfen
2. Netzwerkverbindung prüfen
3. Benutzerrechte prüfen
4. Passwort prüfen

### **Access Denied**
1. Benutzername und Passwort prüfen
2. Host-Berechtigungen prüfen
3. GRANT-Berechtigungen prüfen

### **Performance-Probleme**
1. Slow Query Log prüfen
2. Indexe optimieren
3. Query-Cache prüfen

### **Speicherplatz-Probleme**
1. Disk-Space prüfen
2. Log-Dateien aufräumen
3. Temporäre Tabellen leeren

## 🔐 **Sicherheit**

### **Benutzer-Sicherheit**
- Starke Passwörter verwenden
- Minimale Berechtigungen vergeben
- Regelmäßige Passwort-Änderungen

### **Verbindungssicherheit**
- SSL-Verbindungen verwenden
- IP-Whitelist konfigurieren
- Fail2Ban aktivieren

### **phpMyAdmin-Sicherheit**
- HTTPS erzwingen
- Authentication Timeout
- Session-Security

## 📚 **Nützliche Links**

- [phpMyAdmin Dokumentation](https://www.phpmyadmin.net/docs/)
- [MySQL Dokumentation](https://dev.mysql.com/doc/)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)

---

*phpMyAdmin - Easy MySQL Management* 🗄️
