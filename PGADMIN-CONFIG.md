# 🐘 **pgAdmin Konfigurationsanleitung**

## 🔐 **Login-Daten für pgAdmin**

- **URL**: `http://5.175.180.185:5050`
- **Email**: `admin@saarlandletsplay.de`
- **Passwort**: `PgR7x2!vBfP9qK`

---

## 📋 **Datenbank-Verbindungen hinzufügen**

### 1. **Haupt-PostgreSQL Server (Root-Zugriff)**

**Server-Name**: `PostgreSQL Main Server`

**Connection-Tab:**
- **Host name/address**: `postgresql`
- **Port**: `5432`
- **Username**: `postgres`
- **Password**: *(leer lassen - kein Passwort gesetzt)*
- **Save password?**: `No`

**Zugriff auf**: Alle Datenbanken mit vollen Rechten

---

### 2. **Authentik Datenbank**

**Server-Name**: `Authentik Database`

**Connection-Tab:**
- **Host name/address**: `postgresql`
- **Port**: `5432`
- **Username**: `authentik`
- **Password**: `authentik_pass`
- **Database**: `authentik`
- **Save password?**: `Yes`

**Zugriff auf**: Nur Authentik-Datenbank

---

### 3. **GitLab Datenbank**

**Server-Name**: `GitLab Database`

**Connection-Tab:**
- **Host name/address**: `postgresql`
- **Port**: `5432`
- **Username**: `gitlab`
- **Password**: `gitlab_pass`
- **Database**: `gitlabhq_production`
- **Save password?**: `Yes`

**Zugriff auf**: Nur GitLab-Datenbank

---

### 4. **Vaultwarden Datenbank**

**Server-Name**: `Vaultwarden Database`

**Connection-Tab:**
- **Host name/address**: `postgresql`
- **Port**: `5432`
- **Username**: `vaultwarden`
- **Password**: `vaultwarden_pass`
- **Database**: `vaultwarden_db`
- **Save password?**: `Yes`

**Zugriff auf**: Nur Vaultwarden-Datenbank

---

### 5. **Grafana Datenbank**

**Server-Name**: `Grafana Database`

**Connection-Tab:**
- **Host name/address**: `postgresql`
- **Port**: `5432`
- **Username**: `grafana`
- **Password**: `grafana_pass`
- **Database**: `grafana_db`
- **Save password?**: `Yes`

**Zugriff auf**: Nur Grafana-Datenbank

---

## 🗄️ **MySQL Datenbanken (über phpMyAdmin)**

Für MySQL-Datenbanken verwende **phpMyAdmin**:
- **URL**: `http://5.175.180.185:8080`
- **Benutzer**: `root`
- **Passwort**: `R7x2!vBfP9qK`

**Verfügbare MySQL-Datenbanken:**
- `npm_db` (Nginx Proxy Manager)
- `owncloud_db` (OwnCloud)
- `grafana_db` (Grafana - alternative)

---

## 📝 **Schritt-für-Schritt Anleitung**

1. **pgAdmin öffnen**: `http://5.175.180.185:5050`
2. **Login**: Mit Admin-Daten einloggen
3. **Server hinzufügen**: 
   - Klicke auf "Add New Server" (➕ Wählsymbol)
   - Trage die oben genannten Daten ein
   - Klicke "Save"
4. **Datenbanken durchsuchen**: Nach Verbindung siehst du alle Tabellen

---

## 🔧 **Wichtige Hinweise**

- **Host**: Immer `postgresql` verwenden (Docker-Container-Name)
- **Netzwerk**: pgAdmin ist im selben Docker-Netzwerk wie die Datenbanken
- **Sicherheit**: Passwörter werden nur gespeichert wenn "Save password" aktiviert
- **Rechte**: Jeder Benutzer hat nur Zugriff auf seine eigene Datenbank

---

## 🚨 **Fehlerbehandlung**

**Fehler: "Connection refused"**
- Überprüfe, ob der PostgreSQL-Container läuft: `docker ps | grep postgresql`

**Fehler: "Password authentication failed"**
- Überprüfe Benutzername und Passwort aus dieser Anleitung

**Fehler: "Database does not exist"**
- Stelle sicher, dass die Datenbank erstellt wurde. Erstelle sie mit:
  ```sql
  CREATE DATABASE datenbankname;
  GRANT ALL PRIVILEGES ON DATABASE datenbankname TO benutzername;
  ```

---

## 📊 **Übersicht aller Datenbanken**

| Service | Typ | Host | Port | Benutzer | Passwort | Datenbank |
|---------|------|------|------|----------|-----------|-----------|
| Authentik | PostgreSQL | postgresql | 5432 | authentik | authentik_pass | authentik |
| GitLab | PostgreSQL | postgresql | 5432 | gitlab | gitlab_pass | gitlabhq_production |
| Vaultwarden | PostgreSQL | postgresql | 5432 | vaultwarden | vaultwarden_pass | vaultwarden_db |
| Grafana | PostgreSQL | postgresql | 5432 | grafana | grafana_pass | grafana_db |
| Nginx PM | MySQL | mysql | 3306 | npm | NpM4@dA9#xP | npm_db |
| OwnCloud | MySQL | mysql | 3306 | owncloud | owncloud_pass | owncloud_db |

---

*Letzte Aktualisierung: 03.03.2026*
