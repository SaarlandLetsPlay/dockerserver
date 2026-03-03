# 🔐 **Authentik Identity Provider**

## 📋 **Übersicht**

Authentik ist ein Open-Source Identity Provider mit Unterstützung für SAML2, OAuth2 und OIDC. Es bietet Single Sign-On (SSO), Multi-Factor Authentication (MFA) und User Management.

## 🚀 **Schnellstart**

1. **Konfiguration anpassen:**
   ```bash
   nano .env
   ```

2. **Server starten:**
   ```bash
   docker compose up -d
   ```

3. **Logs ansehen:**
   ```bash
   docker compose logs -f
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `http://5.175.180.185:9000`
- **Admin-Login**: `akadmin` mit dem Secret Key aus `.env`

## ⚙️ **Konfiguration**

### **Datenbank-Verbindung**
```env
PG_DB=authentik
PG_USER=authentik
PG_PASS=authentik_pass
```

### **Ports**
```env
COMPOSE_PORT_HTTP=9000
COMPOSE_PORT_HTTPS=9443
```

### **Secret Key**
```env
AUTHENTIK_SECRET_KEY=dein_geheimer_schlüssel
```

## 📁 **Verzeichnisstruktur**

```
authentik/
├── compose.yml          # Docker-Konfiguration
├── .env                 # Umgebungsvariablen
├── data/               # Authentik Daten
├── custom-templates/   # Custom Templates
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **PostgreSQL-Einstellungen**
- `AUTHENTIK_POSTGRESQL__HOST`: PostgreSQL Host
- `AUTHENTIK_POSTGRESQL__NAME`: Datenbankname
- `AUTHENTIK_POSTGRESQL__USER`: Datenbankbenutzer
- `AUTHENTIK_POSTGRESQL__PASSWORD`: Datenbankpasswort

### **Security-Einstellungen**
- `AUTHENTIK_SECRET_KEY`: Geheimer Schlüssel für Tokens
- `AUTHENTIK_ERROR_REPORTING_ENABLE`: Fehlerberichte aktivieren

## 🌐 **Anwendungen konfigurieren**

### **OAuth2 Anwendung**
1. Im Admin-Panel: "Applications" → "New Application"
2. Provider: OAuth2
3. Client Type: Confidential
4. Redirect URIs: `http://deine-app/callback`

### **SAML2 Anwendung**
1. Provider: SAML2
2. ACS URL: `https://deine-app/saml/acs`
3. Entity ID: `https://deine-app/saml`

## 👥 **Benutzerverwaltung**

### **Benutzer erstellen**
1. "Directory" → "Users" → "Create User"
2. Benutzername und E-Mail eingeben
3. Passwort festlegen oder E-Mail senden

### **Gruppen erstellen**
1. "Directory" → "Groups" → "Create Group"
2. Gruppenname und Attribute festlegen
3. Benutzer zu Gruppen hinzufügen

## 🔐 **Security-Einstellungen**

### **MFA aktivieren**
1. "Directory" → "Users" → Benutzer auswählen
2. "MFA Devices" → "Enroll Device"
3. Methode wählen (TOTP, WebAuthn, Static)

### **Policies erstellen**
1. "Policies" → "New Policy"
2. Policy-Typ wählen (Password, Expression, etc.)
3. Bedingungen konfigurieren

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f authentik
docker compose logs -f authentik-worker
```

### **Health-Check**
```bash
curl http://localhost:9000/-/health/
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Datenbank sichern
docker exec postgresql pg_dump authentik > authentik_backup.sql

# Daten sichern
tar -czf authentik_data_backup.tar.gz data/
```

### **Update durchführen**
```bash
# Image aktualisieren
docker compose pull

# Container neu starten
docker compose up -d
```

## 🚨 **Fehlerbehandlung**

### **Server startet nicht**
1. PostgreSQL-Verbindung prüfen
2. Secret Key prüfen
3. Logs ansehen: `docker compose logs authentik`

### **Datenbank-Verbindungsfehler**
1. PostgreSQL-Container prüfen
2. Benutzerrechte prüfen
3. Netzwerkverbindung prüfen

### **Login-Probleme**
1. Admin-Benutzer `akadmin` verwenden
2. Secret Key prüfen
3. Firewall prüfen

## 📚 **Nützliche Links**

- [Authentik Dokumentation](https://docs.goauthentik.io/)
- [Authentik GitHub](https://github.com/goauthentik/authentik)
- [OAuth2 RFC](https://tools.ietf.org/html/rfc6749)
- [SAML2 RFC](https://tools.ietf.org/html/rfc7522)

---

*Authentik - Modern Identity Management* 🔐
