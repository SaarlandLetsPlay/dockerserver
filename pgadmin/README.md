# 🐘 **pgAdmin PostgreSQL Management**

## 📋 **Übersicht**

pgAdmin ist ein webbasiertes Administration-Tool für PostgreSQL-Datenbanken mit vollständigen CRUD-Operationen und Query-Editor.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f pgadmin
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `http://5.175.180.185:5050`
- **Admin-Login**: `admin@saarlandletsplay.de` / `PgR7x2!vBfP9qK`

## ⚙️ **Konfiguration**

### **Ports**
- `5050`: Web-Interface

### **Admin-Zugang**
- **Email**: `admin@saarlandletsplay.de`
- **Passwort**: `PgR7x2!vBfP9qK`

### **Server-Einstellungen**
- **Server-Mode**: Disabled
- **Master-Password**: Nicht erforderlich

## 📁 **Verzeichnisstruktur**

```
pgadmin/
├── compose.yml          # Docker-Konfiguration
├── data/               # pgAdmin Daten
│   ├── sessions/       # Session-Daten
│   └── storage/        # Konfiguration
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **pgAdmin-Einstellungen**
```env
PGADMIN_DEFAULT_EMAIL=admin@saarlandletsplay.de
PGADMIN_DEFAULT_PASSWORD=PgR7x2!vBfP9qK
PGADMIN_CONFIG_SERVER_MODE='False'
PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED='False'
```

### **Network-Einstellungen**
- **saarlandletsplay-external**: Externer Zugriff
- **saarlandletsplay-internal**: Interne Datenbank-Verbindung

## 🗄️ **Server-Verbindungen**

### **PostgreSQL Haupt-Server**
1. "Add New Server" (➕)
2. **General Tab**:
   - Name: `PostgreSQL Main Server`
3. **Connection Tab**:
   - Host: `postgresql`
   - Port: `5432`
   - Username: `postgres`
   - Password: *(leer lassen)*
   - Save password: `No`

### **Authentik Datenbank**
1. **Name**: `Authentik Database`
2. **Host**: `postgresql`
3. **Port**: `5432`
4. **Username**: `authentik`
5. **Password**: `authentik_pass`
6. **Database**: `authentik`

### **GitLab Datenbank**
1. **Name**: `GitLab Database`
2. **Host**: `postgresql`
3. **Port**: `5432`
4. **Username**: `gitlab`
5. **Password**: `gitlab_pass`
6. **Database**: `gitlabhq_production`

### **Vaultwarden Datenbank**
1. **Name**: `Vaultwarden Database`
2. **Host**: `postgresql`
3. **Port**: `5432`
4. **Username**: `vaultwarden`
5. **Password**: `vaultwarden_pass`
6. **Database**: `vaultwarden_db`

### **Grafana Datenbank**
1. **Name**: `Grafana Database`
2. **Host**: `postgresql`
3. **Port**: `5432`
4. **Username**: `grafana`
5. **Password**: `grafana_pass`
6. **Database**: `grafana_db`

## 📊 **Datenbank-Management**

### **Tabellen anzeigen**
1. Server-Verbindung auswählen
2. "Databases" → Datenbank auswählen
3. "Schemas" → "Tables"
4. Tabelle für Details auswählen

### **Queries ausführen**
1. "Tools" → "Query Tool"
2. SQL-Query eingeben
3. "Execute" (▶) klicken
4. Ergebnisse anzeigen

### **Beispiel-Queries**
```sql
-- Alle Tabellen anzeigen
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- Tabellen-Größen anzeigen
SELECT schemaname,tablename,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Benutzer anzeigen
SELECT usename, usecreatedb, usesuper, usecreaterole FROM pg_user;

-- Datenbank-Größen anzeigen
SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size FROM pg_database ORDER BY pg_database_size(datname) DESC;
```

## 🔧 **Datenbank-Operationen**

### **Datenbank erstellen**
1. Rechtsklick auf "Databases"
2. "Create" → "Database"
3. Namen eingeben
4. Owner auswählen
5. "Save"

### **Benutzer erstellen**
```sql
-- Benutzer erstellen
CREATE USER neuer_benutzer WITH PASSWORD 'sicheres_passwort';

-- Berechtigungen vergeben
GRANT ALL PRIVILEGES ON DATABASE datenbankname TO neuer_benutzer;

-- Superuser-Rechte
ALTER USER neuer_benutzer WITH SUPERUSER;
```

### **Tabellen erstellen**
```sql
-- Beispiel-Tabelle
CREATE TABLE benutzer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index erstellen
CREATE INDEX idx_benutzer_email ON benutzer(email);
```

## 📈 **Monitoring**

### **Performance-Überwachung**
```sql
-- Langsame Queries
SELECT query, mean_time, calls, total_time FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;

-- Aktive Verbindungen
SELECT state, count(*) FROM pg_stat_activity GROUP BY state;

-- Locks anzeigen
SELECT relation::regclass, mode, pid FROM pg_locks;
```

### **System-Informationen**
```sql
-- PostgreSQL-Version
SELECT version();

-- Konfiguration anzeigen
SELECT name, setting FROM pg_settings WHERE name LIKE '%memory%';

-- Disk-Nutzung
SELECT pg_size_pretty(pg_database_size(current_database()));
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Komplette Datenbank sichern
docker exec postgresql pg_dump -U postgres --all-databases > full_backup.sql

# Einzelne Datenbank sichern
docker exec postgresql pg_dump -U postgres authentik > authentik_backup.sql

# Komprimiertes Backup
docker exec postgresql pg_dump -U postgres --all-databases | gzip > full_backup.sql.gz
```

### **Datenbank-Optimierung**
```sql
-- VACUUM ausführen
VACUUM ANALYZE;

-- Indexe neu erstellen
REINDEX DATABASE datenbankname;

-- Statistiken aktualisieren
ANALYZE;
```

### **Logs ansehen**
```bash
docker compose logs -f pgadmin
```

## 🚨 **Fehlerbehandlung**

### **Verbindungsprobleme**
1. PostgreSQL-Container prüfen
2. Netzwerkverbindung prüfen
3. Benutzerrechte prüfen
4. Passwort prüfen

### **Permission Denied**
1. Benutzerrechte prüfen
2. GRANT-Befehle ausführen
3. Row-Level-Security prüfen

### **Performance-Probleme**
1. EXPLAIN ANALYZE verwenden
2. Indexe prüfen
3. VACUUM ausführen

### **Speicherplatz-Probleme**
1. Disk-Space prüfen
2. Alte Logs löschen
3. VACUUM FULL ausführen

## 🔐 **Sicherheit**

### **Benutzer-Sicherheit**
- Starke Passwörter verwenden
- Minimale Berechtigungen vergeben
- Regelmäßige Passwort-Änderungen

### **Verbindungssicherheit**
- SSL-Verbindungen verwenden
- IP-Whitelist konfigurieren
- Verbindungs-Limits setzen

### **Daten-Sicherheit**
- Regelmäßige Backups
- Verschlüsselte Speicherung
- Access-Control-Listen

## 📚 **Nützliche Links**

- [pgAdmin Dokumentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Dokumentation](https://www.postgresql.org/docs/)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [PostgreSQL Performance](https://wiki.postgresql.org/wiki/Performance_Optimization)

---

*pgAdmin - Powerful PostgreSQL Management* 🐘
