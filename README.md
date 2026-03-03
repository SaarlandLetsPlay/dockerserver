# Dockhand Server Deployment

## 🚀 Schnellstart mit Deployment Script

```bash
# Script ausführen (installiert automatisch Docker)
./deploy-stacks.sh
```

## 📋 Übersicht aller Services

### 🔧 Infrastructure
- **Dockhand** - Docker Management (Port 3000)
- **MySQL** - Zentrale MySQL-Datenbank
- **PostgreSQL** - Zentrale PostgreSQL-Datenbank

### 🗄️ Datenbank-Verwaltung
- **phpMyAdmin** - MySQL Verwaltung (Port 8080)
- **pgAdmin** - PostgreSQL Verwaltung (Port 5050)

### 🌐 Services
- **Nginx Proxy Manager** - Reverse Proxy (Ports 80, 443, 81)
- **Authentik** - Authentifizierung (Ports 9000, 9443)
- **GitLab** - Git Repository (Port 2222)
- **OwnCloud** - Cloud Storage (Port 85)
- **Satisfactory** - Game Server (host networking)

## 🏗️ Datenbank-Architektur

### Zentrale MySQL (Container: mysql)
- `npm_db` → Nginx Proxy Manager
- `owncloud_db` → OwnCloud
- `grafana_db` → Grafana

### Zentrale PostgreSQL (Container: postgresql)
- `authentik` → Authentik
- `gitlabhq_production` → GitLab
- `grafana_db` → Grafana (Alternative)

## 📁 Volume-Struktur

Alle Daten sind unter `/opt/stacks/` konsolidiert:

```
/opt/stacks/
├── mysql/data
├── postgresql/data
├── postgresql/init-scripts
├── nginx-proxy-manager/data
├── nginx-proxy-manager/letsencrypt
├── pgadmin/data
├── phpmyadmin/config
├── dockhand/
└── satisfactory-server/
```

## 🔑 Zugangsdaten

### Datenbanken
- **MySQL Root**: `R7x2!vBfP9qK`
- **PostgreSQL**: `PgR7x2!vBfP9qK`

### Verwaltungstools
- **phpMyAdmin**: `root` / `R7x2!vBfP9qK`
- **pgAdmin**: `admin@saarlandletsplay.de` / `PgR7x2!vBfP9qK`

## 🎯 Dockhand Integration

Alle Services sind über Dockhand verwaltbar:
1. Dockhand starten: `cd dockhand && docker compose up -d`
2. Zugriff: http://localhost:3000
3. Stacks können über die UI verwaltet werden

## 🔄 Manuelles Deployment

Falls das Script nicht verwendet wird:

```bash
# 1. Docker installieren (falls nicht vorhanden)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 2. Verzeichnisse erstellen
sudo mkdir -p /opt/stacks/{mysql,postgresql,nginx-proxy-manager,pgadmin,phpmyadmin,dockhand,satisfactory-server}
sudo chown -R $USER:$USER /opt/stacks

# 3. Netzwerke erstellen
docker network create saarlandletsplay-internal
docker network create saarlandletsplay-external
docker network create my_ipv6_net

# 4. Datenbanken starten
cd mysql && docker compose up -d
cd ../postgresql && docker compose up -d

# 5. Verwaltungstools starten
cd ../phpmyadmin && docker compose up -d
cd ../pgadmin && docker compose up -d
cd ../dockhand && docker compose up -d

# 6. Services starten
cd ../nginx-proxy-manager && docker compose up -d
cd ../authentik && docker compose up -d
cd ../gitlab && docker compose up -d
cd ../owncloud && docker compose up -d
```

## 🛠️ Script-Funktionen

Das `deploy-stacks.sh` Script übernimmt automatisch:

### ✅ **Docker Installation**
- Prüft ob Docker installiert ist
- Installiert neueste Docker CE Version
- Installiert Docker Compose Plugin
- Fügt Benutzer zur docker Gruppe hinzu

### ✅ **Infrastruktur Setup**
- Erstellt `/opt/stacks` Verzeichnisstruktur
- Erstellt alle notwendigen Docker Netzwerke
- Setzt korrekte Berechtigungen

### ✅ **Smart Deployment**
- Startet Services in korrekter Reihenfolge
- Wartet auf Health-Checks bei Datenbanken
- Zeigt Status und Versionen an

### ✅ **Fehlerbehandlung**
- Detailliertes Logging mit Farben
- Überprüft Abhängigkeiten
- Gibt klare Fehlermeldungen aus

## 🌐 Netzwerk-Architektur

### Standard-Netzwerke (alle Services außer Satisfactory)
- **saarlandletsplay-internal**: Interne Kommunikation
- **saarlandletsplay-external**: Externe Dienste
- **my_ipv6_net**: IPv6 Support

### Satisfactory
- **network_mode: host** für optimale Gaming-Performance
- Volume: `/opt/stacks/satisfactory-server`

## 🛠️ Wichtige Hinweise

- Die Datenbanken müssen vor den abhängigen Services gestartet werden
- Alle Services verwenden die Netzwerke `saarlandletsplay-internal` und `saarlandletsplay-external`
- Dockhand benötigt Zugriff auf `/var/run/docker.sock`
- Die init-Scripts für PostgreSQL werden beim ersten Start automatisch ausgeführt
- Nach Docker Installation evtl. neu einloggen oder `newgrp docker` ausführen
