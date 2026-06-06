# 🦊 **GitLab Git Repository Manager**

## 📋 **Übersicht**

GitLab ist eine webbasierte DevOps Lifecycle Tool mit Git Repository Management, CI/CD, Monitoring und Security Features.

## 🚀 **Schnellstart**

1. **Konfiguration anpassen:**
   ```bash
   nano compose.yml
   ```

2. **Server starten:**
   ```bash
   docker compose up -d
   ```

3. **Logs ansehen:**
   ```bash
   docker compose logs -f gitlab
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://git.example.com`
- **SSH**: `ssh://git@git.example.com:2222`
- **Git HTTP**: `https://git.example.com/[username]/[project].git`

## ⚙️ **Konfiguration**

### **Ports**
- `2222`: SSH-Zugriff
- Web-Interface über Nginx Proxy Manager

### **Datenbank-Verbindung**
- **Host**: `postgresql`
- **Port**: `5432`
- **Datenbank**: `gitlabhq_production`
- **Benutzer**: `gitlab`
- **Passwort**: `gitlab_pass`

### **Redis-Verbindung**
- **Host**: `gitlab_redis`
- **Port**: `6379`

## 📁 **Verzeichnisstruktur**

```
gitlab/
├── compose.yml          # Docker-Konfiguration
├── config/             # GitLab Konfiguration
├── logs/               # GitLab Logs
├── data/               # GitLab Daten
├── redis/              # Redis Daten
└── README.md           # Diese Datein
```

## 🔧 **Konfigurationsoptionen**

### **GitLab Omnibus Konfiguration**
```yaml
external_url 'https://git.example.com'
gitlab_rails['gitlab_shell_ssh_port'] = 2222
```

### **PostgreSQL-Konfiguration**
```yaml
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_host'] = 'postgresql'
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = 'gitlab'
gitlab_rails['db_password'] = 'gitlab_pass'
gitlab_rails['db_database'] = 'gitlabhq_production'
```

### **SMTP-Einstellungen**
```yaml
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.example.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "registry@example.com"
gitlab_rails['smtp_password'] = "PWanq1cB!.555@4m"
```

## 👥 **Benutzerverwaltung**

### **Root-Benutzer**
1. Erster Login mit `root`
2. Passwort festlegen
3. E-Mail-Adresse konfigurieren

### **Benutzer erstellen**
1. Admin-Area → "Users" → "New User"
2. Benutzername und E-Mail eingeben
3. Passwort festlegen oder E-Mail senden

### **Gruppen und Projekte**
1. Gruppen erstellen für Organisationen
2. Projekte in Gruppen organisieren
3. Berechtigungen vergeben

## 🔐 **SSH-Schlüssel**

### **SSH-Schlüssel hinzufügen**
1. Profil → "SSH Keys"
2. Public Key einfügen
3. Titel vergeben

### **SSH-Konfiguration**
```bash
# ~/.ssh/config
Host git.example.com
  HostName git.example.com
  User git
  Port 2222
  IdentityFile ~/.ssh/id_rsa
```

## 🔄 **CI/CD Pipeline**

### **GitLab CI**
1. `.gitlab-ci.yml` im Repository erstellen
2. Runner konfigurieren
3. Pipeline auslösen

### **Beispiel-Pipeline**
```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - echo "Building..."
  only:
    - main

test:
  stage: test
  script:
    - echo "Testing..."
  only:
    - main

deploy:
  stage: deploy
  script:
    - echo "Deploying..."
  only:
    - main
```

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f gitlab
```

### **Health-Check**
```bash
curl -I https://git.example.com
```

### **System-Informationen**
- Admin-Area → "Monitoring"
- CPU, Memory, Disk Usage
- Background Jobs

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# GitLab Backup
docker exec gitlab gitlab-backup create

# Datenbank sichern
docker exec postgresql pg_dump gitlabhq_production > gitlab_db_backup.sql
```

### **Update durchführen**
```bash
# Image aktualisieren
docker compose pull

# Container neu starten
docker compose up -d
```

### **Konfiguration neu laden**
```bash
docker exec gitlab gitlab-ctl reconfigure
```

## 🚨 **Fehlerbehandlung**

### **Server startet nicht**
1. PostgreSQL-Verbindung prüfen
2. Redis-Verbindung prüfen
3. Logs ansehen: `docker compose logs gitlab`

### **SSH-Verbindungsprobleme**
1. SSH-Port prüfen (2222)
2. SSH-Schlüssel prüfen
3. Firewall prüfen

### **Web-Interface nicht erreichbar**
1. Nginx Proxy Manager prüfen
2. SSL-Zertifikat prüfen
3. DNS-Einstellung prüfen

### **Repository-Probleme**
1. Speicherplatz prüfen
2. Berechtigungen prüfen
3. GitLab-Status prüfen

## 📚 **Nützliche Links**

- [GitLab Dokumentation](https://docs.gitlab.com/)
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [GitLab API](https://docs.gitlab.com/ee/api/)
- [GitLab Runner](https://docs.gitlab.com/runner/)

---

*GitLab - Complete DevOps Platform* 🦊
