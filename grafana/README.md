# 📊 **Grafana Monitoring Dashboard**

## 📋 **Übersicht**

Grafana ist ein Open-Source Analytics & Monitoring Lösung für Zeitreihen-Daten mit schönen Dashboards und Alerting.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f grafana
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `http://5.175.180.185:3000`
- **Admin-Login**: `admin` / `Gn9fe4cdz.`

## ⚙️ **Konfiguration**

### **Ports**
- `3000`: Web-Interface

### **Datenbank-Verbindung**
- **Host**: `postgresql`
- **Port**: `5432`
- **Datenbank**: `grafana_db`
- **Benutzer**: `grafana`
- **Passwort**: `grafana_pass`

### **Admin-Zugang**
- **Benutzer**: `admin`
- **Passwort**: `Gn9fe4cdz.`

## 📁 **Verzeichnisstruktur**

```
grafana/
├── compose.yml          # Docker-Konfiguration
├── prometheus.yml       # Prometheus Konfiguration
├── grafana_data/        # Grafana Daten
├── prometheus_data/     # Prometheus Daten
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **Grafana-Einstellungen**
```env
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=Gn9fe4cdz.
GF_DATABASE_TYPE=postgres
GF_DATABASE_HOST=postgresql:5432
GF_DATABASE_NAME=grafana_db
GF_DATABASE_USER=grafana
GF_DATABASE_PASSWORD=grafana_pass
```

### **Prometheus-Einstellungen**
```yaml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['localhost:8080']
```

## 📊 **Dashboard-Erstellung**

### **Dashboard erstellen**
1. "+" → "Dashboard"
2. Panel hinzufügen
3. Datenquelle auswählen
4. Query konfigurieren
5. Visualisierung anpassen

### **Panels**
- **Graph**: Zeitreihen-Daten
- **Stat**: Einzelne Werte
- **Table**: Tabellarische Daten
- **Heatmap**: Dichte-Visualisierung
- **Gauge**: Messinstrument

### **Queries**
```promql
# CPU-Auslastung
rate(cpu_usage_total[5m])

# Memory-Nutzung
process_resident_memory_bytes

# Docker Container Stats
container_cpu_usage_seconds_total
```

## 🔌 **Datenquellen**

### **Prometheus**
1. "Configuration" → "Data Sources"
2. Prometheus hinzufügen
3. URL: `http://prometheus:9090`
4. Speichern & Testen

### **PostgreSQL**
1. PostgreSQL hinzufügen
2. Host: `postgresql:5432`
3. Datenbank: `grafana_db`
4. Benutzer: `grafana`

### **Weitere Datenquellen**
- InfluxDB
- Elasticsearch
- MySQL
- Loki

## 🚨 **Alerting**

### **Alert-Regeln**
1. Dashboard → Alert
2. Bedingung definieren
3. Benachrichtigungskanäle konfigurieren

### **Benachrichtigungskanäle**
- Email
- Slack
- Webhook
- Telegram

### **Beispiel-Alert**
```promql
# CPU > 80%
cpu_usage_percent > 80

# Memory > 90%
memory_usage_percent > 90

# Disk Space < 10%
disk_space_percent < 10
```

## 👥 **Benutzerverwaltung**

### **Benutzer erstellen**
1. "Server Admin" → "Users"
2. "New User"
3. Rolle zuweisen (Viewer, Editor, Admin)

### **Rollen**
- **Admin**: Vollzugriff
- **Editor**: Dashboards erstellen/bearbeiten
- **Viewer**: Nur Lesen

### **Teams**
1. "Teams" → "New Team"
2. Mitglieder hinzufügen
3. Berechtigungen zuweisen

## 📊 **Monitoring**

### **System-Metriken**
- CPU-Auslastung
- Memory-Nutzung
- Disk-Speicher
- Network-Traffic

### **Docker-Metriken**
- Container-Statistiken
- Image-Nutzung
- Volume-Größen
- Network-Stats

### **Anwendungs-Metriken**
- Response-Zeiten
- Error-Rates
- Throughput
- User-Aktivität

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Grafana-Daten sichern
tar -czf grafana_backup.tar.gz grafana_data/

# Prometheus-Daten sichern
tar -czf prometheus_backup.tar.gz prometheus_data/
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

### **Datenbank-Optimierung**
```sql
-- Alte Daten löschen
DELETE FROM data_blob WHERE created_at < NOW() - INTERVAL '30 days';

-- Indexe neu erstellen
REINDEX DATABASE grafana_db;
```

## 🚨 **Fehlerbehandlung**

### **Dashboard nicht ladbar**
1. Datenquelle prüfen
2. Query-Syntax prüfen
3. Logs ansehen

### **Datenquelle nicht erreichbar**
1. Netzwerkverbindung prüfen
2. Anmeldedaten prüfen
3. Firewall prüfen

### **Performance-Probleme**
1. Query-Optimierung
2. Daten-Reduktion
3. Caching aktivieren

## 📚 **Nützliche Links**

- [Grafana Dokumentation](https://grafana.com/docs/)
- [Prometheus Dokumentation](https://prometheus.io/docs/)
- [Grafana Labs](https://grafana.com/grafana/)
- [Community Dashboards](https://grafana.com/grafana/dashboards/)

---

*Grafana - Beautiful Analytics & Monitoring* 📊
