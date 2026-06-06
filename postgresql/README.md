# 🐘 **PostgreSQL Database Server**

## 📋 **Übersicht**

PostgreSQL ist ein leistungsstarkes Open-Source Objekt-Relationales Datenbank-Management-System mit erweiterten Features und hoher Zuverlässigkeit.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f postgresql
   ```

## 🌐 **Zugriff**

- **pgAdmin**: `http://5.175.180.185:5050`
- **Standard-User**: `postgres`
- **Standard-Passwort**: *(kein Passwort gesetzt)*

## ⚙️ **Konfiguration**

### **Datenbanken**
- `authentik`: Authentik Identity Provider
- `gitlabhq_production`: GitLab
- `grafana_db`: Grafana
- `vaultwarden_db`: Vaultwarden

### **Benutzer**
- `postgres`: Administrator
- `authentik`: Authentik
- `gitlab`: GitLab
- `grafana`: Grafana
- `vaultwarden`: Vaultwarden

### **Passwörter**
- `postgres`: *(kein Passwort)*
- `authentik`: `authentik_pass`
- `gitlab`: `gitlab_pass`
- `grafana`: `grafana_pass`
- `vaultwarden`: `vaultwarden_pass`

## 📁 **Verzeichnisstruktur**

```
postgresql/
├── compose.yml          # Docker-Konfiguration
├── data/               # PostgreSQL Daten
├── init-scripts/       # Initialisierungsskripte
│   └── 01-create-databases.sh
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **PostgreSQL-Einstellungen**
```env
POSTGRES_PASSWORD=<DEIN_POSTGRES_PASSWORT>
POSTGRES_USER=postgres
POSTGRES_DB=authentik
```

### **Zusätzliche Datenbanken**
```env
POSTGRES_DB_2=gitlabhq_production
POSTGRES_DB_3=grafana_db
POSTGRES_DB_4=vaultwarden_db
```

### **Health-Check**
```yaml
healthcheck:
  test:
    - CMD-SHELL
    - pg_isready -U postgres
  interval: 30s
  timeout: 5s
  retries: 5
  start_period: 20s
```

## 🗄️ **Datenbank-Management**

### **Datenbank erstellen**
```sql
CREATE DATABASE neue_datenbank;
CREATE USER benutzer WITH PASSWORD 'passwort';
GRANT ALL PRIVILEGES ON DATABASE neue_datenbank TO benutzer;
```

### **Benutzer verwalten**
```sql
-- Benutzer anzeigen
SELECT usename, usecreatedb, usesuper FROM pg_user;

-- Berechtigungen anzeigen
\l

-- Passwort ändern
ALTER USER benutzer WITH PASSWORD 'neues_passwort';
```

### **Backup erstellen**
```bash
# Komplette Datenbank sichern
docker exec postgresql pg_dump -U postgres --all-databases > full_backup.sql

# Einzelne Datenbank sichern
docker exec postgresql pg_dump -U postgres authentik > authentik_backup.sql

# Komprimiertes Backup
docker exec postgresql pg_dump -U postgres --all-databases | gzip > full_backup.sql.gz
```

### **Backup wiederherstellen**
```bash
# Komplette Datenbank wiederherstellen
docker exec -i postgresql psql -U postgres < full_backup.sql

# Einzelne Datenbank wiederherstellen
docker exec -i postgresql psql -U postgres authentik < authentik_backup.sql

# Komprimiertes Backup wiederherstellen
gunzip -c full_backup.sql.gz | docker exec -i postgresql psql -U postgres
```

## 🔌 **Verbindungen**

### **Interne Verbindungen**
```bash
# Von anderem Container
psql -h postgresql -U benutzer -d datenbank

# Verbindung testen
docker exec postgresql psql -U postgres -c "SELECT 1;"
```

### **Externe Verbindungen**
- **Host**: `postgresql` (intern) oder `5.175.180.185` (extern)
- **Port**: `5432`
- **Protokoll**: PostgreSQL

### **Verbindungs-Strings**
```python
# Python mit psycopg2
import psycopg2
conn = psycopg2.connect(
    host="postgresql",
    user="benutzer",
    password="passwort",
    database="datenbank"
)

# PHP mit PDO
$pdo = new PDO("pgsql:host=postgresql;dbname=datenbank", "benutzer", "passwort");

# Node.js mit pg
const { Client } = require('pg');
const client = new Client({
    host: 'postgresql',
    user: 'benutzer',
    password: 'passwort',
    database: 'datenbank'
});
```

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f postgresql
```

### **Status prüfen**
```bash
# PostgreSQL-Status
docker exec postgresql pg_isready -U postgres

# Aktive Verbindungen
docker exec postgresql psql -U postgres -c "SELECT state, count(*) FROM pg_stat_activity GROUP BY state;"

# Datenbank-Größen
docker exec postgresql psql -U postgres -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size FROM pg_database ORDER BY pg_database_size(datname) DESC;"
```

### **Performance-Optimierung**
```sql
-- Slow Queries anzeigen
SELECT query, mean_time, calls FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;

-- Index-Nutzung
SELECT schemaname, tablename, attname, n_distinct, correlation FROM pg_stats;

-- Locks anzeigen
SELECT relation::regclass, mode, pid FROM pg_locks;
```

## 🛠️ **Wartung**

### **Datenbank-Optimierung**
```sql
-- VACUUM ausführen
VACUUM ANALYZE;

-- Indexe neu erstellen
REINDEX DATABASE datenbankname;

-- Statistiken aktualisieren
ANALYZE;
```

### **Log-Rotation**
```bash
# PostgreSQL-Logs rotieren
docker exec postgresql psql -U postgres -c "SELECT pg_rotate_logfile();"
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
1. pg_stat_statements prüfen
2. Indexe optimieren
3. Memory-Einstellungen anpassen

### **Speicherplatz-Probleme**
1. Disk-Space prüfen
2. WAL-Logs aufräumen
3. Alte Daten löschen

### **Recovery**
```bash
# PostgreSQL im Recovery-Modus starten
docker exec postgresql postgres -c recovery.conf
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
- Row-Level-Security

## 📚 **Nützliche Links**

- [PostgreSQL Dokumentation](https://www.postgresql.org/docs/)
- [pgAdmin](https://www.pgadmin.org/)
- [PostgreSQL Performance](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

---

*PostgreSQL - The World's Most Advanced Open Source Relational Database* 🐘
