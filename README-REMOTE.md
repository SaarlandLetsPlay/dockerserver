# Remote Deployment Guide

## 🚀 **One-Click Remote Deployment**

```bash
# Auf Ihrem lokalen System ausführen:
./deploy-remote.sh
```

## 🌐 **Server-Konfiguration**

### **Remote Server Details:**
- **IP Adresse**: `5.175.180.185`
- **SSH User**: `root`
- **SSH Key**: `~/.ssh/id_rsa` (Ihr Standard SSH Key)
- **Remote Verzeichnis**: `/opt/dockerserver`

### **Voraussetzungen:**
1. **SSH Key** `~/.ssh/id_rsa` muss existieren
2. **SSH Zugang** zu `root@5.175.180.185` muss funktionieren
3. **Port 22** muss offen sein

## 📋 **Deployment-Ablauf**

### **1. SSH Verbindung prüfen**
```bash
ssh -i ~/.ssh/id_rsa root@5.175.180.185 "echo 'OK'"
```

### **2. Dateien kopieren**
```bash
# Alle compose.yml Dateien und Scripts
rsync -avz -e "ssh -i ~/.ssh/id_rsa" ./ root@5.175.180.185:/opt/dockerserver/
```

### **3. Haupt-Deployment**
```bash
# Docker installieren + alle Services starten
ssh -i ~/.ssh/id_rsa root@5.175.180.185 "cd /opt/dockerserver && ./deploy-stacks.sh"
```

### **4. Vaultwarden Setup**
```bash
# Vaultwarden mit Admin-Account erstellen
ssh -i ~/.ssh/id_rsa root@5.175.180.185 "cd /opt/dockerserver && ./setup-vaultwarden.sh"
```

## 🌐 **Zugriff nach Deployment**

### **Management URLs:**
- **Dockhand**: `http://5.175.180.185:3000`
- **phpMyAdmin**: `http://5.175.180.185:8080`
- **pgAdmin**: `http://5.175.180.185:5050`
- **NPM Admin**: `http://5.175.180.185:81`
- **Vaultwarden**: `http://5.175.180.185:8083`

### **Service Ports:**
- **Nginx Proxy Manager**: 80, 443, 81
- **Authentik**: 9000, 9443
- **GitLab SSH**: 2222
- **OwnCloud**: 85
- **Satisfactory**: Host Networking

## 🔑 **Zugangsdaten**

### **Datenbanken:**
- **MySQL Root**: `R7x2!vBfP9qK`
- **PostgreSQL**: `PgR7x2!vBfP9qK`

### **Verwaltungstools:**
- **phpMyAdmin**: `root` / `R7x2!vBfP9qK`
- **pgAdmin**: `admin@saarlandletsplay.de` / `PgR7x2!vBfP9qK`
- **Vaultwarden Admin**: `daniel@fam-stauder.de` / `Gn9fe4cdz.Emily`

## 🛠️ **Nach Deployment**

### **1. Domains konfigurieren**
In **Nginx Proxy Manager** (`http://5.175.180.185:81`):
- `git.saarlandletsplay.de` → GitLab (Port 2222)
- `cloud.saarlandletsplay.de` → OwnCloud (Port 85)
- `passwort.saarlandletsplay.de` → Vaultwarden (Port 8083)
- `auth.saarlandletsplay.de` → Authentik (Port 9000)

### **2. Firewall prüfen**
```bash
# Auf dem Server ausführen:
ufw status
# Ports 80, 443, 81, 3000, 8080, 8083 erlauben
```

### **3. SSL Zertifikate**
In **Nginx Proxy Manager** SSL-Zertifikate für alle Domains einrichten.

## 📁 **Volume-Struktur auf Server**

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
├── vaultwarden/data
└── satisfactory-server/
```

## 🔄 **Updates**

### **Services aktualisieren:**
```bash
# Per SSH auf Server
ssh -i gn9fe4cdz root@5.175.180.185

# Verzeichnis wechseln
cd /opt/dockerserver

# Einzelne Services aktualisieren
cd authentik && docker compose pull && docker compose up -d
cd ../gitlab && docker compose pull && docker compose up -d

# Oder über Dockhand UI
```

## 🚨 **Troubleshooting**

### **SSH Verbindung fehlgeschlagen:**
```bash
# SSH Key Berechtigungen prüfen
chmod 600 ~/.ssh/id_rsa

# Manuelles SSH testen
ssh -i ~/.ssh/id_rsa -v root@5.175.180.185
```

### **Services nicht erreichbar:**
```bash
# Auf Server prüfen
docker ps
docker logs [container_name]

# Netzwerke prüfen
docker network ls
```

### **Docker Probleme:**
```bash
# Docker Service prüfen
systemctl status docker

# Docker neu starten
systemctl restart docker
```

## 🎯 **Management**

### **Über Dockhand:**
1. **Dockhand aufrufen**: `http://5.175.180.185:3000`
2. **Alle Services sind sichtbar**
3. **Container starten/stoppen/neu starten**
4. **Logs einsehen**
5. **Compose-Dateien bearbeiten**

### **Per SSH:**
```bash
# Direkter Zugriff
ssh -i ~/.ssh/id_rsa root@5.175.180.185
cd /opt/dockerserver
```

**Ihr kompletter Docker-Server ist mit einem Befehl deploybar!** 🚀
