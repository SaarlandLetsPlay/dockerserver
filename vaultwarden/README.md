# 🔐 **Vaultwarden Password Manager**

## 📋 **Übersicht**

Vaultwarden ist ein Open-Source Password Manager, kompatibel mit Bitwarden Clients, mit Self-Hosting und Ende-zu-Ende-Verschlüsselung.

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
   docker compose logs -f vaultwarden
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://passwort.saarlandletsplay.de`
- **Admin-Panel**: `https://passwort.saarlandletsplay.de/admin`

## ⚙️ **Konfiguration**

### **Ports**
- `8083`: Web-Interface (intern)
- Extern über Nginx Proxy Manager

### **Datenbank-Verbindung**
- **Host**: `postgresql`
- **Port**: `5432`
- **Datenbank**: `vaultwarden_db`
- **Benutzer**: `vaultwarden`
- **Passwort**: `vaultwarden_pass`

### **Admin-Zugang**
- **Admin-Token**: `T06WiChPFKbyYYTd6oWHfGvt37vt1blLcPKUJIX+H4=`

## 📁 **Verzeichnisstruktur**

```
vaultwarden/
├── compose.yml          # Docker-Konfiguration
├── data/               # Vaultwarden Daten
│   ├── attachments/    # Datei-Anhänge
│   ├── icons/          # Website-Icons
│   └── sends/          # Sends
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **Vaultwarden-Einstellungen**
```env
WEBSOCKET_ENABLED=true
DOMAIN=https://passwort.saarlandletsplay.de
ADMIN_TOKEN=T06WiChPFKbyYYTd6oWHfGvt37vt1blLcPKUJIX+H4=
SIGNUPS_ALLOWED=true
DATABASE_URL=postgresql://vaultwarden:vaultwarden_pass@postgresql:5432/vaultwarden_db
```

### **Security-Einstellungen**
- Ende-zu-Ende-Verschlüsselung
- 2FA-Unterstützung
- Master-Passwort erforderlich

## 🔐 **Benutzerverwaltung**

### **Registrierung**
1. Web-Interface aufrufen
2. "Create Account" klicken
3. E-Mail und Master-Passwort eingeben
4. Account erstellen

### **Admin-Panel**
1. `/admin` aufrufen
2. Admin-Token eingeben
3. Benutzer verwalten
4. Einstellungen konfigurieren

### **Benutzer-Management**
- Benutzer auflisten
- Benutzer löschen
- Registrierung deaktivieren
- 2FA erzwingen

## 🔑 **Passwort-Management**

### **Passwörter speichern**
1. "Add Item" → "Login"
2. Website/Name eingeben
3. Benutzername und Passwort
4. Notizen hinzufügen
5. Speichern

### **Passwörter generieren**
1. Generator-Icon klicken
2. Länge und Zeichen-Typ wählen
3. "Generate" klicken
4. Passwort kopieren

### **Kategorien**
- Login
- Card
- Identity
- Secure Note

### **Collections**
- Passwörter organisieren
- Freigaben verwalten
- Team-Collections

## 📱 **Clients**

### **Browser-Extensions**
- Chrome
- Firefox
- Edge
- Safari

### **Mobile Apps**
- Android
- iOS

### **Desktop Apps**
- Windows
- macOS
- Linux

### **CLI-Tools**
```bash
# Bitwarden CLI installieren
npm install -g @bitwarden/cli

# Login
bw login

# Passwörter auflisten
bw list items

# Passwort holen
bw get password "example.com"
```

## 🔄 **Synchronisation**

### **Automatische Sync**
- Cloud-Synchronisation
- Geräte-Sync
- Real-time-Updates

### **Manual Sync**
1. Settings → "Sync"
2. "Sync Now" klicken
3. Status prüfen

### **Offline-Modus**
- Lokale Speicherung
- Offline-Zugriff
- Sync bei Verbindung

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f vaultwarden
```

### **Admin-Panel**
- Benutzer-Statistiken
- Storage-Nutzung
- Login-Aktivität
- Fehler-Logs

### **Health-Check**
```bash
curl -I https://passwort.saarlandletsplay.de
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Daten sichern
tar -czf vaultwarden_backup.tar.gz data/

# Datenbank sichern
docker exec postgresql pg_dump -U postgres vaultwarden_db > vaultwarden_db_backup.sql
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

### **Datenbank-Optimierung**
```sql
-- Alte Sends löschen
DELETE FROM sends WHERE expire_at < NOW();

-- Attachments aufräumen
VACUUM ANALYZE vaultwarden_db;
```

## 🚨 **Fehlerbehandlung**

### **Login-Probleme**
1. Master-Passwort prüfen
2. Browser-Cache leeren
3. 2FA-Status prüfen

### **Sync-Probleme**
1. Netzwerkverbindung prüfen
2. Server-Status prüfen
3. Client-Update prüfen

### **Performance-Probleme**
1. Storage-Nutzung prüfen
2. Datenbank optimieren
3. Cache leeren

### **Admin-Zugang**
1. Admin-Token prüfen
2. URL prüfen (`/admin`)
3. Browser-Entwickler-Tools prüfen

## 🔐 **Sicherheit**

### **Master-Passwort**
- Mindestens 12 Zeichen
- Groß/Kleinbuchstaben, Zahlen, Symbole
- Keine persönlichen Informationen
- Regelmäßige Änderung

### **2FA-Methoden**
- Authenticator App
- Email
- YubiKey
- Duo

### **Security-Settings**
- Login-Anforderungen
- Passwort-Anforderungen
- 2FA-Erzwingung
- Emergency Access

## 📚 **Nützliche Links**

- [Vaultwarden GitHub](https://github.com/dani-garcia/vaultwarden)
- [Bitwarden Clients](https://bitwarden.com/download/)
- [Password Security](https://www.password-depot.com/password-security/)
- [2FA Guide](https://2fa.directory/)

---

*Vaultwarden - Secure Password Management* 🔐
