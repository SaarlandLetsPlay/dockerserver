# 🔐 **Login-Daten - Übersicht aller Dienste**

## 🚀 **Server-Informationen**
- **Server IP**: `5.175.180.185`
- **SSH User**: `root`
- **SSH Key**: `~/.ssh/id_rsa`
- **SSH Passphrase**: `gn9fe4cdz`

---

## 🗄️ **Datenbanken**

### **MySQL (Zentrale Datenbank)**
- **Host**: `mysql` (intern) / `5.175.180.185:3306` (extern)
- **Root User**: `root`
- **Root Passwort**: `R7x2!vBfP9qK`
- **Datenbanken**:
  - `npm_db` (Nginx Proxy Manager)
  - `owncloud` (OwnCloud)
  - `grafana_db` (Grafana - wenn benötigt)

### **PostgreSQL (Zentrale Datenbank)**
- **Host**: `postgresql` (intern) / `5.175.180.185:5432` (extern)
- **Root User**: `postgres`
- **Root Passwort**: (keins gesetzt)
- **Datenbanken**:
  - `vaultwarden_db` - User: `vaultwarden` / Pass: `vaultwarden_pass`
  - `authentik` - User: `admin` / Pass: `Gn9fe4cdz.`
  - `gitlab_db` - User: `gitlab` / Pass: `gitlab_pass`
  - `grafana_db` - User: `grafana` / Pass: `grafana_pass`

---

## 🌐 **Web-Dienste**

### **Management Tools**

#### **Dockhand**
- **URL**: `http://5.175.180.185:3000`
- **Domain**: `dockhand.saarlandletsplay.de`
- **Login**: Keine Authentifizierung benötigt
- **Zweck**: Docker Container Management

#### **phpMyAdmin**
- **URL**: `http://5.175.180.185:8080`
- **Domain**: `db.mysql.saarlandletsplay.de`
- **Benutzer**: `root`
- **Passwort**: `R7x2!vBfP9qK`
- **Status**: ✅ **BEHOBEN** - Konfiguration repariert
- **Zweck**: MySQL Datenbank Management

#### **pgAdmin**
- **URL**: `http://5.175.180.185:5050`
- **Domain**: `db.postgres.saarlandletsplay.de`
- **Email**: `admin@saarlandletsplay.de`
- **Passwort**: `PgR7x2!vBfP9qK`
- **Zweck**: PostgreSQL Datenbank Management

#### **Nginx Proxy Manager**
- **URL**: `http://5.175.180.185:81`
- **Domain**: (über Proxy konfiguriert)
- **Email**: `admin@example.com`
- **Passwort**: `changeme` (nach erstem Login ändern)
- **Zweck**: Reverse Proxy & SSL Management

---

### **Anwendungen**

#### **Vaultwarden (Passwort-Manager)**
- **URL**: `http://5.175.180.185:8083`
- **Domain**: `passwort.saarlandletsplay.de`
- **Admin Email**: `daniel@fam-stauder.de`
- **Admin Passwort**: `Gn9fe4cdz.Emily`
- **Registrierung**: `SIGNUPS_ALLOWED=true`
- **Zweck**: Passwort-Management (Bitwarden-kompatibel)

#### **Grafana**
- **URL**: `http://5.175.180.185:3000`
- **Domain**: `grafana.saarlandletsplay.de`
- **Admin User**: `admin`
- **Admin Passwort**: (bei erstem Login festlegen)
- **Zweck**: Monitoring & Visualisierung

#### **Authentik (Identity & Access Management)**
- **URL**: `http://5.175.180.185:9000`
- **Domain**: `auth.saarlandletsplay.de`
- **Admin User**: `admin`
- **Admin Passwort**: `Gn9fe4cdz.Emily` (wenn erstellt)
- **Zweck**: SSO & Authentifizierung

#### **GitLab**
- **URL**: `http://5.175.180.185:2222`
- **Domain**: `git.saarlandletsplay.de`
- **Root User**: `root`
- **Root Passwort**: (bei erstem Login festlegen)
- **Zweck**: Git Repository Management

#### **OwnCloud**
- **URL**: `http://5.175.180.185:85`
- **Domain**: `cloud.saarlandletsplay.de`
- **Admin User**: `admin`
- **Admin Passwort**: `Y7uK3pL9xF2vN6mT`
- **Zweck**: Cloud Storage & File-Sharing

#### **Satisfactory (Game Server)**
- **URL**: `http://5.175.180.185:7777` (Game Port)
- **Domain**: (nicht für Web-Zugriff)
- **Admin Passwort**: (im Spiel konfigurieren)
- **Zweck**: Game Server

---

## 🔧 **Interne Dienste**

### **Prometheus**
- **URL**: `http://5.175.180.185:9090`
- **Domain**: `prometheus.saarlandletsplay.de`
- **Auth**: Keine (intern)
- **Zweck**: Metrics Collection

### **Node Exporter**
- **URL**: `http://5.175.180.185:9100`
- **Auth**: Keine (intern)
- **Zweck**: System Metrics

### **cAdvisor**
- **URL**: `http://5.175.180.185:8080`
- **Auth**: Keine (intern)
- **Zweck**: Container Metrics

---

## 🌍 **Domain-Konfiguration**

### **DNS-Einträge (Wildcard)**
```
*.saarlandletsplay.de.    IN    A    5.175.180.185
```

### **Konfigurierte Domains**
| Domain | Service | Port | Status |
|--------|---------|------|--------|
| `dockhand.saarlandletsplay.de` | Dockhand | 3000 | ✅ |
| `db.mysql.saarlandletsplay.de` | phpMyAdmin | 8080 | ✅ |
| `db.postgres.saarlandletsplay.de` | pgAdmin | 5050 | ✅ |
| `passwort.saarlandletsplay.de` | Vaultwarden | 8083 | ✅ |
| `grafana.saarlandletsplay.de` | Grafana | 3000 | ✅ |
| `auth.saarlandletsplay.de` | Authentik | 9000 | ⚠️ |
| `git.saarlandletsplay.de` | GitLab | 2222 | ✅ |
| `cloud.saarlandletsplay.de` | OwnCloud | 85 | ⚠️ |

---

## � **Troubleshooting - phpMyAdmin**

### **Problem: mysqli::real_connect(): No such file or directory**

**Ursache:** phpMyAdmin hatte keine `config.inc.php` Datei mit MySQL-Verbindungseinstellungen.

**Lösung:**
```bash
# 1. Config-Datei erstellt (vereinfachte Syntax)
docker exec phpmyadmin rm -f /etc/phpmyadmin/config.inc.php
docker exec phpmyadmin sh -c 'cat > /etc/phpmyadmin/config.inc.php << "EOF"
<?php
\$cfg["blowfish_secret"] = "test12345";
\$cfg["Servers"][1]["host"] = "mysql";
\$cfg["Servers"][1]["auth_type"] = "cookie";
\$cfg["Servers"][1]["user"] = "root";
\$cfg["Servers"][1]["password"] = "R7x2!vBfP9qK";
EOF'

# 2. Container neu gestartet
docker restart phpmyadmin

# 3. Verbindung getestet
curl -I http://localhost:8080
docker exec phpmyadmin php -r '\$conn = new mysqli(\"mysql\", \"root\", \"R7x2!vBfP9qK\"); if (\$conn->connect_error) { echo \"Connection failed: \" . \$conn->connect_error . PHP_EOL; } else { echo \"Connection successful\" . PHP_EOL; } \$conn->close();'
```

### **Ergebnis:**
- ✅ phpMyAdmin erreichbar unter `http://5.175.180.185:8080`
- ✅ MySQL-Verbindung funktioniert
- ✅ Login mit `root` / `R7x2!vBfP9qK` möglich
- ✅ PHP-Syntax-Fehler behoben

---

## �� **Wichtige Hinweise**

### **Sicherheit**
- **Passwörter ändern**: Nach erstem Login alle Standard-Passwörter ändern
- **SSH Key**: Private Key sicher aufbewahren
- **Firewall**: Nur Ports 80, 443, 81 von außen erreichbar

### **Erste Schritte**
1. **Nginx Proxy Manager** aufrufen und Passwort ändern
2. **SSL-Zertifikate** für alle Domains erstellen
3. **Admin-Accounts** in den Anwendungen erstellen
4. **Domains** konfigurieren und testen

### **Troubleshooting**
- **Logs prüfen**: `docker logs [container_name]`
- **Container Status**: `docker ps`
- **Netzwerk-Verbindung**: `docker network ls`
- **Datenbank-Verbindung**: Über phpMyAdmin/pgAdmin testen

---

## 🔄 **Passwort-Änderungen**

### **Empfohlene Änderungen**
1. **Nginx Proxy Manager**: `changeme` → sicheres Passwort
2. **Vaultwarden Admin**: `Gn9fe4cdz.Emily` → persönliches Passwort
3. **MySQL Root**: `R7x2!vBfP9qK` → sicheres Passwort
4. **PostgreSQL Users**: Standard-Passwörter ändern
5. **SSH Key**: Passphrase `gn9fe4cdz` → persönliche Passphrase

### **Dokumentation**
Nach Änderungen dieses Dokument aktualisieren!

---

## 📞 **Support & Hilfe**

### **Nützliche Befehle**
```bash
# Alle Container anzeigen
docker ps

# Container Logs
docker logs [container_name]

# Container neu starten
docker restart [container_name]

# Datenbank-Verbindung testen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "SHOW DATABASES;"
docker exec postgresql psql -U postgres -c "\l"
```

### **Troubleshooting Guide**
Siehe `NGINX-PROXY-SETUP.md` für detaillierte Fehlerbehebung.

---

**📅 Letzte Aktualisierung**: 02.03.2026  
**🔐 Sicherheit**: Alle Passwörter bei erstem Login ändern!  
**🌐 Domains**: Wildcard-Zertifikat für `*.saarlandletsplay.de` verwenden
