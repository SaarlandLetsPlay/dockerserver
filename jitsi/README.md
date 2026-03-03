# 📹 **Jitsi Meet Video Conferencing**

## 📋 **Übersicht**

Jitsi Meet ist eine Open-Source Video-Konferenzlösung mit WebRTC-basierter Kommunikation, Screen-Sharing und Chat-Funktionen.

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
   docker compose logs -f
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `https://meet.saarlandletsplay.de`
- **Test-URL**: `https://meet.jit.si`

## ⚙️ **Konfiguration**

### **Ports**
- `8081`: Web-Interface (HTTP)
- `8443`: Web-Interface (HTTPS)

### **Services**
- **Prosody**: XMPP Server
- **JVB**: Jitsi Videobridge
- **Web**: Web-Interface

### **Authentifizierung**
- `ENABLE_AUTH: 1`: Authentifizierung aktiviert
- `JVB_AUTH_USER`: `jvb`
- `JVB_AUTH_PASSWORD`: `jvb-pass`

## 📁 **Verzeichnisstruktur**

```
jitsi/
├── compose.yml          # Docker-Konfiguration
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **XMPP-Einstellungen**
```env
XMPP_DOMAIN=meet.example.com
XMPP_BOSH_URL_BASE=http://jitsi-prosody:5280
XMPP_MUC_DOMAIN=muc.meet.example.com
```

### **Web-Einstellungen**
```env
PUBLIC_URL=https://meet.example.com
ENABLE_AUTH=1
```

### **Videobridge-Einstellungen**
```env
JVB_AUTH_USER=jvb
JVB_AUTH_PASSWORD=jvb-pass
JVB_BREWERY_MUC=jvbbrewery@internal-muc.meet.example.com
```

## 🎥 **Features**

### **Video-Konferenzen**
- ✅ HD-Video-Qualität
- ✅ Multi-Participant-Video
- ✅ Screen-Sharing
- ✅ Desktop-Sharing
- ✅ Audio-Konferenzen

### **Kollaboration**
- ✅ Live-Chat
- ✅ Datei-Sharing
- ✅ Whiteboard (mit Plugin)
- ✅ Recording (mit Plugin)

### **Sicherheit**
- ✅ Ende-zu-Ende-Verschlüsselung
- ✅ Passwort-Schutz für Räume
- ✅ LDAP-Authentifizierung
- ✅ JWT-Authentifizierung

## 🎛️ **Admin-Funktionen**

### **Raum-Management**
1. Raum erstellen mit Namen
2. Passwort-Schutz aktivieren
3. Teilnehmer-Limits festlegen

### **Benutzer-Management**
1. Gast-Zugriff konfigurieren
2. Authentifizierte Benutzer verwalten
3. Berechtigungen zuweisen

### **Quality-Settings**
1. Video-Qualität anpassen
2. Audio-Einstellungen konfigurieren
3. Bandwidth-Limits festlegen

## 🔌 **Integrationen**

### **LDAP-Authentifizierung**
```env
ENABLE_AUTH=1
AUTH_TYPE=ldap
LDAP_URL=ldap://ldap.example.com:389
LDAP_BASE_DN=ou=users,dc=example,dc=com
```

### **JWT-Authentifizierung**
```env
ENABLE_AUTH=1
JWT_AUTH_TYPE=token
JWT_APP_ID=your_app_id
JWT_APP_SECRET=your_app_secret
```

### **Recording**
```env
ENABLE_RECORDING=1
RECORDING_SERVICE=recording
RECORDING_SERVICE_URL=http://recording:8080
```

## 📊 **Monitoring**

### **Logs ansehen**
```bash
# Prosody Logs
docker compose logs -f jitsi-prosody

# JVB Logs
docker compose logs -f jitsi-jvb

# Web Logs
docker compose logs -f jitsi-web
```

### **Performance-Metriken**
- Teilnehmer-Anzahl
- Video-Qualität
- Bandwidth-Nutzung
- CPU/Memory-Auslastung

### **Health-Checks**
```bash
# Web-Interface
curl -I https://meet.saarlandletsplay.de

# XMPP-Verbindung
telnet localhost 5222
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Konfiguration sichern
tar -czf jitsi_config_backup.tar.gz ./

# Logs sichern
docker compose logs --no-color > jitsi_logs.txt
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

### **Performance-Optimierung**
```env
# JVB Performance
JVB_MAX_MEMORY=3072m
JVB_SYSTEM_MEMORY=256m

# Video-Qualität
VIDEO_QUALITY=720
```

## 🚨 **Fehlerbehandlung**

### **Verbindungsprobleme**
1. Firewall prüfen (Ports 80/443, 10000 UDP)
2. STUN/TURN Server prüfen
3. DNS-Einstellung prüfen

### **Audio-Probleme**
1. Mikrofon-Berechtigungen prüfen
2. Browser-Einstellungen prüfen
3. Netzwerk-Verbindung prüfen

### **Video-Probleme**
1. Kamera-Berechtigungen prüfen
2. Bandwidth prüfen
3. Browser-Kompatibilität prüfen

### **Authentifizierungsprobleme**
1. LDAP-Verbindung prüfen
2. JWT-Token prüfen
3. Benutzer-Daten prüfen

## 🔐 **Sicherheit**

### **Netzwerk-Sicherheit**
- HTTPS erzwingen
- STUN/TURN Server konfigurieren
- Firewall-Regeln einrichten

### **Authentifizierung**
- Gast-Zugriff limitieren
- Starke Passwörter verwenden
- 2FA aktivieren (wenn möglich)

### **Datenschutz**
- Ende-zu-Ende-Verschlüsselung
- Recording-Berechtigungen
- Data-Retention-Policy

## 📚 **Nützliche Links**

- [Jitsi Meet Dokumentation](https://jitsi.github.io/handbook/)
- [Jitsi Meet GitHub](https://github.com/jitsi/jitsi-meet)
- [WebRTC Dokumentation](https://webrtc.org/)
- [XMPP Protokoll](https://xmpp.org/)

---

*Jitsi Meet - Secure Video Conferencing* 📹
