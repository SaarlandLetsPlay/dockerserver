# Nginx Proxy Manager - Container Anbindung

## 🚀 **Schnellstart**

1. **Nginx Proxy Manager aufrufen**: `http://5.175.180.185:81`
2. **Login**: `admin@example.com` / `changeme`
3. **Passwort ändern** nach erstem Login

## 📋 **Container-Übersicht & Ports**

### **Management Tools**
| Service | Port | Domain | Ziel |
|---------|------|--------|------|
| Dockhand | 3000 | `dockhand.saarlandletsplay.de` | `http://dockhand:3000` |
| phpMyAdmin | 8080 | `db.mysql.saarlandletsplay.de` | `http://phpmyadmin:80` |
| pgAdmin | 5050 | `db.postgres.saarlandletsplay.de` | `http://pgadmin:80` |

### **Anwendungen**
| Service | Port | Domain | Ziel |
|---------|------|--------|------|
| Vaultwarden | 8083 | `passwort.saarlandletsplay.de` | `http://vaultwarden:80` |
| Grafana | 3000 | `grafana.saarlandletsplay.de` | `http://grafana:3000` |
| Authentik | 9000 | `auth.saarlandletsplay.de` | `http://authentik:9000` |
| Authentik (HTTPS) | 9443 | `auth.saarlandletsplay.de` | `http://authentik:9443` |
| GitLab | 2222 | `git.saarlandletsplay.de` | `http://gitlab:80` |
| OwnCloud | 85 | `cloud.saarlandletsplay.de` | `http://owncloud:80` |

## 🔧 **Schritt-für-Schritt Anleitung**

### **1. Nginx Proxy Manager aufrufen**
```
http://5.175.180.185:81
```

### **2. Erster Login**
- **Email**: `admin@example.com`
- **Password**: `changeme`
- **Danach Passwort ändern**

### **3. SSL-Zertifikate erstellen**
1. **SSL Certificates** → **Add Certificate**
2. **Let's Encrypt** wählen
3. **Domain**: `*.saarlandletsplay.de` (Wildcard)
4. **Email**: `admin@saarlandletsplay.de`
5. **Terms of Service** akzeptieren
6. **Save**

### **4. Proxy Hosts erstellen**

#### **Dockhand**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `dockhand.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `dockhand`
   - **Forward Port**: `3000`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
   - **HTTP/2 Support**: ✅
4. **Save**

#### **Vaultwarden**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `passwort.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `vaultwarden`
   - **Forward Port**: `80`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
   - **HTTP/2 Support**: ✅
4. **Custom Locations** (für WebSocket):
   - **Location**: `/notifications/hub`
   - **Scheme**: `http`
   - **Forward Hostname**: `vaultwarden`
   - **Forward Port**: `80`
   - **Websocket Support**: ✅
5. **Save**

#### **phpMyAdmin**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `db.mysql.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `phpmyadmin`
   - **Forward Port**: `80`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Save**

#### **pgAdmin**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `db.postgres.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `pgadmin`
   - **Forward Port**: `80`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Save**

#### **Grafana**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `grafana.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `grafana`
   - **Forward Port**: `3000`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Save**

#### **Authentik**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `auth.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `authentik`
   - **Forward Port**: `9000`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Custom Locations** (für WebSocket):
   - **Location**: `/ws`
   - **Scheme**: `http`
   - **Forward Hostname**: `authentik`
   - **Forward Port**: `9000`
   - **Websocket Support**: ✅
5. **Save**

#### **GitLab**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `git.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `gitlab`
   - **Forward Port**: `80`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Custom Locations** (für Git SSH):
   - **Location**: `/`
   - **Scheme**: `http`
   - **Forward Hostname**: `gitlab`
   - **Forward Port**: `80`
5. **Save**

#### **OwnCloud**
1. **Hosts** → **Add Proxy Host**
2. **Details**:
   - **Domain Names**: `cloud.saarlandletsplay.de`
   - **Scheme**: `http`
   - **Forward Hostname**: `owncloud`
   - **Forward Port**: `80`
3. **SSL**:
   - **SSL Certificate**: `*.saarlandletsplay.de`
   - **Force SSL**: ✅
4. **Custom Headers** (für OwnCloud):
   - **Header**: `X-Forwarded-Host`
   - **Value**: `cloud.saarlandletsplay.de`
   - **Header**: `X-Forwarded-Proto`
   - **Value**: `https`
5. **Save**

## 🚨 **Troubleshooting - OwnCloud 502 Fehler**

### **Problem: 502 Bad Gateway bei OwnCloud**

**Ursache:** OwnCloud konnte nicht zur MySQL-Datenbank verbinden, weil der User nicht existierte.

**Lösung:**
```bash
# Datenbank-User und Datenbank erstellen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "CREATE USER 'owncloud'@'%' IDENTIFIED BY 'Q5nT8yW3rU6pA1sD';"
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "CREATE DATABASE owncloud;"
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'%';"
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "FLUSH PRIVILEGES;"

# OwnCloud neu starten
docker restart owncloud
```

### **Apache Konfiguration (falls nötig):**
```bash
# Apache Konfiguration prüfen und reparieren
docker exec -u root owncloud sh -c 'echo "Listen 80" >> /etc/apache2/apache2.conf'
docker exec -u root owncloud sh -c 'mkdir -p /var/run/apache2 /var/lock/apache2 /var/log/apache2'
```

### **Verbindung prüfen:**
```bash
# OwnCloud Status prüfen
docker logs owncloud --tail 10

# Direkter Test
curl -I http://localhost:85

# Von NPM Container testen
docker exec npm curl -I http://owncloud:80
```

### **Ergebnis nach Fix:**
- ✅ OwnCloud erreichbar unter `http://5.175.180.185:85`
- ✅ Proxy-Konfiguration funktioniert
- ✅ Apache läuft auf Port 80 im Container

### **Wichtige Hinweise:**
- **Login-Daten**: `admin` / `Y7uK3pL9xF2vN6mT`
- **Weiterleitung**: Leitet zu `/login` weiter
- **Admin-Account**: Wird automatisch erstellt

## 🚨 **Troubleshooting - pgAdmin 504 Gateway Timeout**

### **Problem: 504 Gateway Time-out bei pgAdmin**

**Ursache:** pgAdmin konnte Verzeichnisse nicht erstellen wegen Berechtigungsproblemen.

**Lösung:**
```bash
# Verzeichnisse mit richtigen Berechtigungen erstellen
docker exec -u root pgadmin mkdir -p /var/lib/pgadmin/sessions
docker exec -u root pgadmin mkdir -p /var/lib/pgadmin/storage
docker exec -u root pgadmin mkdir -p /var/lib/pgadmin/azurecredentialcache
docker exec -u root pgadmin touch /var/lib/pgadmin/pgadmin4.db

# Berechtigungen setzen
docker exec -u root pgadmin chown -R pgadmin:root /var/lib/pgadmin

# pgAdmin neu starten
docker restart pgadmin
```

### **Verbindung prüfen:**
```bash
# pgAdmin Status prüfen
docker logs pgadmin --tail 10

# Direkter Test
curl -I http://localhost:5050

# Von NPM Container testen
docker exec npm curl -I http://pgadmin:80
```

### **Ergebnis nach Fix:**
- ✅ pgAdmin erreichbar unter `http://5.175.180.185:5050`
- ✅ Proxy-Konfiguration funktioniert
- ✅ Weiterleitung zu `/browser/` funktioniert

### **Wichtige Hinweise:**
- pgAdmin leitet automatisch zu `/browser/` weiter
- Erste Seite zeigt Login-Formular
- Login-Daten: `admin@saarlandletsplay.de` / `PgR7x2!vBfP9qK`

## 🚨 **Troubleshooting - Authentik 503 Service Unavailable**

### **Problem: 503 Service Unavailable bei Authentik**

**Ursache:** Authentik hat mehrere Probleme:
1. **Datenbank-Verbindung** - User `admin` mit falschem Passwort
2. **Datenbank-Schema** - Fehlende `last_updated` Spalte
3. **Migration-Probleme** - Unvollständige Tabellen
4. **Bootstrap-Prozess** - Startet nicht vollständig

**Lösung:**
```bash
# 1. Datenbank-User korrigieren
docker exec postgresql psql -U postgres -d postgres -c "ALTER USER admin WITH PASSWORD 'Gn9fe4cdz.';"

# 2. Fehlende Spalte hinzufügen
docker exec postgresql psql -U admin -d authentik -c "ALTER TABLE authentik_core_user ADD COLUMN last_updated timestamp with time zone DEFAULT now();"

# 3. Admin-User prüfen (existiert bereits)
docker exec postgresql psql -U admin -d authentik -c "SELECT username, email, is_active FROM authentik_core_user WHERE username = 'admin';"

# 4. Container neu starten
docker restart authentik && docker restart authentik-worker

# 5. Warten (90+ Sekunden für Bootstrap)
sleep 90
```

### **Alternative: Komplett-Reset**
Falls weiterhin Probleme:
```bash
# 1. Datenbank komplett zurücksetzen
docker exec postgresql psql -U postgres -d postgres -c "DROP DATABASE authentik; CREATE DATABASE authentik OWNER admin;"

# 2. Container neu starten
docker-compose down -v
docker-compose up -d

# 3. 3-5 Minuten warten für komplette Installation
```

### **Verbindung prüfen:**
```bash
# Authentik Status prüfen
docker logs authentik --tail 10
docker logs authentik-worker --tail 10

# Direkter Test
curl -I http://localhost:9000

# Von NPM Container testen
docker exec npm curl -I http://authentik:9000
```

### **Ergebnis nach Fix:**
- ✅ Authentik erreichbar unter `http://5.175.180.185:9000`
- ✅ Proxy-Konfiguration funktioniert
- ✅ Bootstrap abgeschlossen

### **Wichtige Hinweise:**
- **Bootstrap dauert**: 3-5 Minuten beim ersten Start
- **Admin-Account**: `admin` / `Gn9fe4cdz.Emily` (wenn erstellt)
- **Enterprise-Features**: Möglicherweise Tabellen-Probleme
- **Logs prüfen**: Auf "Finished authentik bootstrap" warten

## 🚨 **Troubleshooting - OwnCloud Weiße Seite**

### **Problem: Seite bleibt weiß / 502 Bad Gateway**

**Ursache:** OwnCloud hat mehrere Probleme:
1. **Datenbank-Verbindung** wurde behoben
2. **Apache Konfiguration** hatte Probleme mit Umgebungsvariablen
3. **Config-Datei** war beschädigt
4. **Container restartet** ständig

**Lösung:**
```bash
# 1. Container zurücksetzen
docker stop owncloud && docker rm owncloud
rm -rf /opt/stacks/owncloud/*

# 2. Neu starten
cd /opt/dockerserver/owncloud && docker compose up -d

# 3. Installation abwarten (90+ Sekunden)
sleep 90

# 4. Status prüfen
docker logs owncloud --tail 10
```

### **Alternative: Manuelles Setup**
Falls OwnCloud weiterhin Probleme macht:
```bash
# 1. Datenbank-User sicherstellen
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "CREATE USER 'owncloud'@'%' IDENTIFIED BY 'Q5nT8yW3rU6pA1sD';"
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "CREATE DATABASE owncloud;"
docker exec mysql mysql -u root -pR7x2!vBfP9qK -e "GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'%';"

# 2. OwnCloud komplett zurücksetzen
docker-compose down -v
docker-compose up -d
```

### **Verbindung prüfen:**
```bash
# OwnCloud Status prüfen
docker logs owncloud --tail 10

# Direkter Test
curl -I http://localhost:85

# Von NPM Container testen
docker exec npm curl -I http://owncloud:80
```

### **Ergebnis nach Fix:**
- ✅ OwnCloud erreichbar unter `http://5.175.180.185:85`
- ✅ Proxy-Konfiguration funktioniert
- ✅ Installation abgeschlossen

### **Wichtige Hinweise:**
- **Installation dauert**: 60-90 Sekunden beim ersten Start
- **Login-Daten**: `admin` / `Y7uK3pL9xF2vN6mT`
- **Admin-Account**: Wird während der Installation erstellt

## 🚨 **Troubleshooting - Vaultwarden Account Erstellung**

### **Problem: Account existiert nicht**

**Lösung 1: Über Web-Interface (empfohlen)**
1. Vaultwarden aufrufen: `http://5.175.180.185:8083`
2. **Create Account** klicken
3. **Email**: `daniel@fam-stauder.de`
4. **Password**: `Gn9fe4cdz.Emily`
5. **Confirm Password**: `Gn9fe4cdz.Emily`
6. **Create Account** klicken

**Lösung 2: Über CLI (falls Web nicht funktioniert)**
```bash
# User über Vaultwarden CLI erstellen
docker exec vaultwarden /vaultwarden create-user daniel@fam-stauder.de Gn9fe4cdz.Emily

# User prüfen
docker exec vaultwarden /vaultwarden list-users

# Oder Invite senden
docker exec vaultwarden /vaultwarden invite daniel@fam-stauder.de
```

### **Konfiguration prüfen:**
```bash
# Signups erlauben (sollte true sein)
docker exec vaultwarden env | grep SIGNUPS_ALLOWED

# Admin Token prüfen
docker exec vaultwarden env | grep ADMIN_TOKEN
```

### **Ergebnis nach erfolgreicher Erstellung:**
- **Login möglich mit `daniel@fam-stauder.de` / `Gn9fe4cdz.Emily`**
- **Account ist Admin-Account (erster Account = Admin)**
- **Alle Vaultwarden-Funktionen verfügbar**

## **Troubleshooting - Vaultwarden 502 Fehler**

### **Problem: 502 Bad Gateway bei Vaultwarden**

**Ursache:** Vaultwarden konnte nicht zur PostgreSQL-Datenbank verbinden, weil der User nicht existierte.

**Lösung:**
```bash
# Datenbank-User und Datenbank erstellen
docker exec postgresql psql -U postgres -c "CREATE USER vaultwarden WITH PASSWORD 'vaultwarden_pass';"
docker exec postgresql psql -U postgres -c "CREATE DATABASE vaultwarden_db OWNER vaultwarden;"
docker exec postgresql psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE vaultwarden_db TO vaultwarden;"

# Vaultwarden neu starten
docker restart vaultwarden
```

### **Verbindung prüfen:**
```bash
# Vaultwarden Status prüfen
docker logs vaultwarden --tail 10

# Direkter Test
curl -I http://5.175.180.185:8083

# Von NPM Container testen
docker exec npm curl -I http://vaultwarden:80
```

### **Ergebnis nach Fix:**
- ✅ Vaultwarden erreichbar unter `http://5.175.180.185:8083`
- ✅ Datenbank-Verbindung hergestellt
- ✅ Proxy-Konfiguration funktioniert

## �� **Erweiterte Konfiguration**

### **WebSocket Support**
Für Vaultwarden und Authentik:
```nginx
# Vaultwarden WebSocket
location /notifications/hub {
    proxy_pass http://vaultwarden:80;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}

# Authentik WebSocket
location /ws {
    proxy_pass http://authentik:9000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}
```

### **Custom Headers**
Für OwnCloud und andere Anwendungen:
```nginx
# OwnCloud Headers
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

# Vaultwarden Headers
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Host $host;
```

## 🌐 **Domain-Zuordnung**

### **Management**
- `dockhand.saarlandletsplay.de` → Dockhand (Port 3000)
- `db.mysql.saarlandletsplay.de` → phpMyAdmin (Port 8080)
- `db.postgres.saarlandletsplay.de` → pgAdmin (Port 5050)

### **Anwendungen**
- `passwort.saarlandletsplay.de` → Vaultwarden (Port 8083)
- `grafana.saarlandletsplay.de` → Grafana (Port 3000)
- `auth.saarlandletsplay.de` → Authentik (Ports 9000/9443)
- `git.saarlandletsplay.de` → GitLab (Port 2222)
- `cloud.saarlandletsplay.de` → OwnCloud (Port 85)

### **Monitoring**
- `monitoring.saarlandletsplay.de` → Grafana (Port 3000)
- `prometheus.saarlandletsplay.de` → Prometheus (Port 9090)

## 🔑 **Zugangsdaten nach Einrichtung**

### **Management URLs**
- **Dockhand**: `https://dockhand.saarlandletsplay.de`
- **phpMyAdmin**: `https://db.mysql.saarlandletsplay.de`
- **pgAdmin**: `https://db.postgres.saarlandletsplay.de`

### **Anwendungs URLs**
- **Vaultwarden**: `https://passwort.saarlandletsplay.de`
- **Grafana**: `https://grafana.saarlandletsplay.de`
- **Authentik**: `https://auth.saarlandletsplay.de`
- **GitLab**: `https://git.saarlandletsplay.de`
- **OwnCloud**: `https://cloud.saarlandletsplay.de`

## 🚨 **Wichtige Hinweise**

### **DNS-Einträge**
Stellen Sie sicher, dass folgende DNS-Records existieren:
```
*.saarlandletsplay.de.    IN    A    5.175.180.185
```

### **Firewall**
Folgende Ports müssen von außen erreichbar sein:
- **80** (HTTP)
- **443** (HTTPS)
- **81** (Nginx Proxy Manager Admin)

### **SSL-Zertifikate**
- Wildcard-Zertifikat für `*.saarlandletsplay.de`
- Automatische Erneuerung durch Let's Encrypt
- HTTP/2 Support für bessere Performance

### **Sicherheit**
- Admin-Interface nur über Port 81 erreichbar
- Alle externen Dienste nur über HTTPS
- Force SSL für alle Domains aktivieren

## 🔄 **Testing**

### **Verbindung testen**
```bash
# Lokale Tests
curl -I https://dockhand.saarlandletsplay.de
curl -I https://passwort.saarlandletsplay.de
curl -I https://grafana.saarlandletsplay.de
```

### **Logs prüfen**
```bash
# Nginx Proxy Manager Logs
docker logs npm

# Container Logs
docker logs vaultwarden
docker logs authentik
docker logs gitlab
```

## 📞 **Support**

### **Häufige Probleme**
1. **502 Bad Gateway** → Container nicht erreichbar
2. **SSL-Fehler** → Zertifikat nicht gültig
3. **WebSocket nicht funktionierend** → Custom Location fehlt

### **Lösungen**
1. Container-Status prüfen: `docker ps`
2. Netzwerk-Verbindung testen: `docker network ls`
3. Logs einsehen: `docker logs [container_name]`

**Nach der Einrichtung sind alle Dienste über ihre jeweiligen Domains mit SSL-Verschlüsselung erreichbar!** 🎉
