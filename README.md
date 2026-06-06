# SaarlandLetsPlay Docker Server

## 🚀 Schnellstart

```bash
# Deployment Script ausführen (installiert automatisch Docker)
./deploy-stacks.sh
```

## 📋 Übersicht aller Services

### 🔧 Infrastructure
| Service | Image | Port | Beschreibung |
|---|---|---|---|
| **Dockhand** | `fnsys/dockhand` | 3000 | Docker Management UI |
| **MySQL** | `mysql:8.4` | 3306 (intern) | Zentrale MySQL-Datenbank |
| **PostgreSQL** | `postgres:16-alpine` | 5432 (intern) | Zentrale PostgreSQL-Datenbank |

### 🗄️ Datenbank-Verwaltung
| Service | Image | Port | Beschreibung |
|---|---|---|---|
| **phpMyAdmin** | `phpmyadmin:latest` | 8080 | MySQL Verwaltung |
| **pgAdmin** | `dpage/pgadmin4` | 5050 | PostgreSQL Verwaltung |

### 🌐 Web-Services
| Service | Domain | Beschreibung |
|---|---|---|
| **Nginx Proxy Manager** | `proxy.example.com` | Reverse Proxy (Ports 80, 443, 81) |
| **Nextcloud** | `cloud.example.com` | Cloud Storage (Port 85) |
| **Vaultwarden** | `passwort.example.com` | Passwort-Manager |
| **Grafana** | `mon.example.com` | Monitoring Dashboard |
| **Open Archiver** | `archiver.example.com` | E-Mail-Archivierung (Port 3100) |

### 📊 Monitoring
| Service | Image | Beschreibung |
|---|---|---|
| **Prometheus** | `prom/prometheus` | Metriken-Sammlung |
| **Grafana** | `grafana/grafana` | Dashboards & Visualisierung |
| **Node Exporter** | `prom/node-exporter` | Host-Metriken |
| **cAdvisor** | `gcr.io/cadvisor/cadvisor` | Container-Metriken |

### 🎮 Game Server
| Service | Image | Beschreibung |
|---|---|---|
| **Satisfactory** | `wolveix/satisfactory-server` | Game Server (host networking) |
| **Minecraft** | `itzg/minecraft-server` | Minecraft Server (Port 25565) |

## 🏗️ Datenbank-Architektur

### Zentrale MySQL 8.4 (Container: `mysql`)
| Datenbank | Service |
|---|---|
| `nextcloud_db` | Nextcloud |
| `npm_db` | Nginx Proxy Manager |
| `phpmyadmin` | phpMyAdmin Configuration Storage |

### Zentrale PostgreSQL 16 (Container: `postgresql`)
| Datenbank | Service |
|---|---|
| `authentik` | Authentik |
| `gitlabhq_production` | GitLab |

### Eigene PostgreSQL (Container: `oa-postgres`)
| Datenbank | Service |
|---|---|
| `open_archive` | Open Archiver |

## 📁 Verzeichnisstruktur

```
dockerserver/
├── README.md                # Diese Datei
├── deploy-stacks.sh         # Automatisches Deployment Script
├── dockhand/                # Docker Management UI
├── mysql/                   # MySQL 8.4 LTS
├── postgresql/              # PostgreSQL 16
├── nginx proxy manager/     # Reverse Proxy + SSL
├── nextcloud/               # Cloud Storage + Redis
├── vaultwarden/             # Passwort-Manager
├── grafana/                 # Monitoring (Grafana + Prometheus)
├── openarchiver/            # E-Mail-Archivierung
├── phpmyadmin/              # MySQL Verwaltung
├── pgadmin/                 # PostgreSQL Verwaltung
├── minecraft/               # Minecraft Server
├── satisfactory/            # Satisfactory Server
├── gaseous/                 # Gaseous Game Library
├── factorio/                # Factorio Server
├── authentik/               # Authentifizierung
├── gitlab/                  # Git Repository
└── jitsi/                   # Video-Konferenzen
```

## 🔑 Zugangsdaten

### Datenbanken
- **MySQL Root**: `<DEIN_MYSQL_PASSWORT>`
- **PostgreSQL**: `<DEIN_POSTGRES_PASSWORT>`

### Verwaltungstools
- **phpMyAdmin**: `root` / `<DEIN_MYSQL_PASSWORT>`
- **pgAdmin**: `admin@example.com` / `<DEIN_POSTGRES_PASSWORT>`
- **Nextcloud Admin**: `admin` / `<DEIN_NEXTCLOUD_PASSWORT>`

## � Netzwerk-Architektur

### Docker-Netzwerke
| Netzwerk | Typ | Verwendung |
|---|---|---|
| `saarlandletsplay-internal` | Bridge (extern) | Interne Service-Kommunikation (DB-Zugriff etc.) |
| `saarlandletsplay-external` | Bridge (extern) | Externe Erreichbarkeit über NPM |

### IPv6
- Server-IPv6: `<SERVER_IPV6>`
- AAAA-DNS-Einträge für `cloud.` und `dockhand.` vorhanden
- IPv6-Traffic wird über NPM terminiert

### Satisfactory / Minecraft
- **network_mode: host** für optimale Gaming-Performance

## 🎯 Dockhand Integration

Alle Services sind über Dockhand verwaltbar:
1. Zugriff: `https://dockhand.example.com`
2. Stacks können über die UI deployed und verwaltet werden
3. Update-Checks für alle Container verfügbar

## 🔄 Manuelles Deployment

```bash
# 1. Docker installieren
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 2. Verzeichnisse erstellen
sudo mkdir -p /opt/stacks/{mysql,postgresql,nginx-proxy-manager,pgadmin,phpmyadmin,dockhand,satisfactory-server}
sudo chown -R $USER:$USER /opt/stacks

# 3. Netzwerke erstellen
docker network create saarlandletsplay-internal
docker network create saarlandletsplay-external

# 4. Datenbanken zuerst starten
cd mysql && docker compose up -d && cd ..
cd postgresql && docker compose up -d && cd ..

# 5. Verwaltungstools starten
cd phpmyadmin && docker compose up -d && cd ..
cd pgadmin && docker compose up -d && cd ..
cd dockhand && docker compose up -d && cd ..

# 6. Services starten
cd "nginx proxy manager" && docker compose up -d && cd ..
cd nextcloud && docker compose up -d && cd ..
cd vaultwarden && docker compose up -d && cd ..
cd grafana && docker compose up -d && cd ..
cd openarchiver && docker compose up -d && cd ..
```

## 🛠️ Wichtige Hinweise

- **Datenbanken zuerst** starten, dann abhängige Services
- Alle Services nutzen `saarlandletsplay-internal` und `saarlandletsplay-external`
- Dockhand benötigt Zugriff auf `/var/run/docker.sock`
- PostgreSQL init-Scripts werden beim ersten Start automatisch ausgeführt
- Nach Docker-Installation ggf. `newgrp docker` ausführen
- SSL-Zertifikate werden über NPM mit Let's Encrypt verwaltet
