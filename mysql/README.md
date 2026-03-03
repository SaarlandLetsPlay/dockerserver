# 🐬 **MySQL Database Server**

## 📋 **Übersicht**

MySQL ist ein beliebtes Open-Source Relationales Datenbank-Management-System, das für Webanwendungen und Datenspeicherung verwendet wird.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f mysql
   ```

## 🌐 **Zugriff**

- **phpMyAdmin**: `http://5.175.180.185:8080`
- **Root-Benutzer**: `root`
- **Root-Passwort**: `R7x2!vBfP9qK`

## ⚙️ **Konfiguration**

### **Datenbanken**
- `npm_db`: Nginx Proxy Manager
- `owncloud_db`: OwnCloud
- `grafana_db`: Grafana

### **Benutzer**
- `root`: Administrator
- `npm`: Nginx Proxy Manager
- `owncloud`: OwnCloud
- `grafana`: Grafana

### **Passwörter**
- `root`: `R7x2!vBfP9qK`
- `npm`: `NpM4@dA9#xP`
- `owncloud`: `owncloud_pass`
- `grafana`: `grafana_pass`

## 📁 **Verzeichnisstruktur**

```
mysql/
├── compose.yml          # Docker-Konfiguration
├── data/               # MySQL Daten
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **MySQL-Einstellungen**
```env
MYSQL_ROOT_PASSWORD=R7x2!vBfP9qK
MYSQL_DATABASE=npm_db
MYSQL_USER=npm
MYSQL_PASSWORD=NpM4@dA9#xP
```

### **Zusätzliche Datenbanken**
```env
MYSQL_DATABASE_2=owncloud_db
MYSQL_DATABASE_3=grafana_db
```

### **Health-Check**
```yaml
healthcheck:
  test:
    - CMD
    - mysqladmin
    - ping
    - -h
    - localhost
  interval: 10s
  timeout: 5s
  retries: 5
```

## 🗄️ **Datenbank-Management**

### **Datenbank erstellen**
```sql
CREATE DATABASE neue_datenbank;
CREATE USER 'benutzer'@'%' IDENTIFIED BY 'passwort';
GRANT ALL PRIVILEGES ON neue_datenbank.* TO 'benutzer'@'%';
FLUSH PRIVILEGES;
```

### **Benutzer verwalten**
```sql
-- Benutzer anzeigen
SELECT User, Host FROM mysql.user;

-- Berechtigungen anzeigen
SHOW GRANTS FOR 'benutzer'@'%';

-- Passwort ändern
ALTER USER 'benutzer'@'%' IDENTIFIED BY 'neues_passwort';
```

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

# Komprimiertes Backup wiederherstellen
gunzip -c full_backup.sql.gz | docker exec -i mysql mysql -u root -pR7x2!vBfP9qK
```

## 🔌 **Verbindungen**

### **Interne Verbindungen**
```bash
# Von anderem Container
mysql -h mysql -u benutzer -p

# Verbindung testen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "SELECT 1;"
```

### **Externe Verbindungen**
- **Host**: `mysql` (intern) oder `5.175.180.185` (extern)
- **Port**: `3306`
- **Protokoll**: MySQL

### **Verbindungs-Strings**
```python
# Python
import mysql.connector
conn = mysql.connector.connect(
    host="mysql",
    user="benutzer",
    password="passwort",
    database="datenbank"
)

# PHP
$mysqli = new mysqli("mysql", "benutzer", "passwort", "datenbank");

# Node.js
const mysql = require('mysql2');
const connection = mysql.createConnection({
    host: 'mysql',
    user: 'benutzer',
    password: 'passwort',
    database: 'datenbank'
});
```

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f mysql
```

### **Status prüfen**
```bash
# MySQL-Status
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "SHOW STATUS;"

# Prozesse anzeigen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "SHOW PROCESSLIST;"

# Datenbank-Größen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables GROUP BY table_schema;"
```

### **Performance-Optimierung**
```sql
-- Slow Query Log aktivieren
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- Indexe analysieren
ANALYZE TABLE table_name;

-- Tabellen optimieren
OPTIMIZE TABLE table_name;
```

## 🛠️ **Wartung**

### **Datenbank-Optimierung**
```sql
-- Fragmentierung prüfen
SELECT table_schema, table_name, ROUND(data_free/1024/1024, 2) AS 'Free Space (MB)' FROM information_schema.tables WHERE data_free > 0;

-- Tabellen reparieren
REPAIR TABLE table_name;

-- Tabellen optimieren
OPTIMIZE TABLE table_name;
```

### **Log-Rotation**
```bash
# MySQL-Logs rotieren
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "FLUSH LOGS;"

# Binäre Logs löschen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "PURGE BINARY LOGS BEFORE DATE_SUB(NOW(), INTERVAL 7 DAY);"
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

## 🚨 **Fehlerbehandlung**

### **Verbindungsprobleme**
1. Container-Status prüfen
2. Netzwerkverbindung prüfen
3. Benutzerrechte prüfen

### **Performance-Probleme**
1. Slow Query Log prüfen
2. Indexe optimieren
3. Memory-Einstellungen anpassen

### **Speicherplatz-Probleme**
1. Disk-Space prüfen
2. Log-Dateien aufräumen
3. Alte Daten löschen

### **Recovery**
```bash
# MySQL im Safe-Mode starten
docker exec mysql mysqld --skip-grant-tables --skip-networking

# Root-Passwort zurücksetzen
docker exec mysql mysql -u root -e "UPDATE mysql.user SET authentication_string=PASSWORD('neues_passwort') WHERE User='root'; FLUSH PRIVILEGES;"
```

## 🔐 **Sicherheit**

### **Benutzer-Sicherheit**
- Starke Passwörter verwenden
- Minimale Berechtigungen vergeben
- Regelmäßige Passwort-Änderungen

### **Netzwerk-Sicherheit**
- Keine externen Ports exponieren
- Nur interne Verbindungen erlauben
- Firewall-Regeln konfigurieren

### **Daten-Sicherheit**
- Regelmäßige Backups
- Verschlüsselte Verbindungen
- Access-Control-Listen

## 📚 **Nützliche Links**

- [MySQL Dokumentation](https://dev.mysql.com/doc/)
- [MySQL Workbench](https://www.mysql.com/products/workbench/)
- [phpMyAdmin](https://www.phpmyadmin.net/)
- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)

---

*MySQL - Reliable Database Server* 🐬
