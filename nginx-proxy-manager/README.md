# 🌐 **Nginx Proxy Manager**

## 📋 **Übersicht**

Nginx Proxy Manager ist ein Docker-basierter Reverse Proxy mit SSL-Termination, Load Balancing und Web-Interface für einfache Konfiguration.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f npm
   ```

## 🌐 **Zugriff**

- **Admin-Interface**: `http://5.175.180.185:81`
- **Standard-Login**: `admin@example.com` / `changeme`

## ⚙️ **Konfiguration**

### **Ports**
- `80`: HTTP
- `443`: HTTPS
- `81`: Admin-Interface

### **Datenbank-Verbindung**
- **Host**: `mysql`
- **Port**: `3306`
- **Datenbank**: `npm_db`
- **Benutzer**: `npm`
- **Passwort**: `NpM4@dA9#xP`

## 📁 **Verzeichnisstruktur**

```
nginx proxy manager/
├── compose.yml          # Docker-Konfiguration
├── data/               # NPM Daten
│   ├── nginx/          # Nginx Konfiguration
│   ├── ssl/            # SSL-Zertifikate
│   └── logs/           # Logs
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **Datenbank-Einstellungen**
```env
DB_MYSQL_HOST=mysql
DB_MYSQL_PORT=3306
DB_MYSQL_USER=npm
DB_MYSQL_PASSWORD=NpM4@dA9#xP
DB_MYSQL_NAME=npm_db
```

### **SSL-Einstellungen**
- Automatische Let's Encrypt Zertifikate
- Custom SSL-Zertifikate
- SSL-Forcing

### **Security-Einstellungen**
- HTTP/2 Support
- Security Headers
- Rate Limiting
- IP-Whitelist/Blacklist

## 🌐 **Proxy-Host Konfiguration**

### **HTTP Proxy**
1. "Hosts" → "Add Proxy Host"
2. **Domain**: `example.com`
3. **Scheme**: `http`
4. **Forward Host**: `container-name`
5. **Forward Port**: `container-port`

### **HTTPS Proxy**
1. SSL-Zertifikat hinzufügen
2. HTTP/HTTPS aktivieren
3. SSL-Zertifikat auswählen
4. HSTS aktivieren

### **Advanced Features**
- **Custom Locations**: Spezifische Pfade
- **Access List**: IP-Beschränkungen
- **Rate Limit**: Anfragen limitieren
- **Block Exploits**: Schutz vor Angriffen

## 🔐 **SSL-Zertifikate**

### **Let's Encrypt**
1. "SSL Certificates" → "Add SSL Certificate"
2. Domain eingeben
3. Email für Benachrichtigungen
4. "Force SSL" aktivieren

### **Custom SSL**
1. Private Key hochladen
2. Zertifikat hochladen
3. CA-Chain (optional)
4. Speichern

### **SSL-Einstellungen**
- **Force SSL**: HTTP zu HTTPS redirect
- **HSTS**: HTTP Strict Transport Security
- **HTTP/2**: Modernes Protokoll
- **OCSP Stapling**: Performance-Optimierung

## 📊 **Monitoring**

### **Logs ansehen**
```bash
# NPM Logs
docker compose logs -f npm

# Nginx Access Logs
docker exec npm tail -f /data/logs/default_host/access.log

# Nginx Error Logs
docker exec npm tail -f /data/logs/default_host/error.log
```

### **Statistiken**
- Request-Anzahl
- Bandwidth-Nutzung
- Response-Zeiten
- Error-Rates

### **Health-Check**
```bash
# Admin-Interface
curl -I http://localhost:81

# Proxy-Test
curl -I http://example.com
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# NPM-Daten sichern
tar -czf npm_backup.tar.gz data/

# Datenbank sichern
docker exec mysql mysqldump -u root -p<DEIN_MYSQL_PASSWORT> npm_db > npm_db_backup.sql
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

### **Konfiguration neu laden**
```bash
# Nginx neu laden
docker exec npm nginx -s reload

# NPM neustarten
docker compose restart npm
```

### **Log-Rotation**
```bash
# Alte Logs löschen
docker exec npm find /data/logs -name "*.log" -mtime +30 -delete

# Logs komprimieren
docker exec npm find /data/logs -name "*.log" -mtime +1 -exec gzip {} \;
```

## 🚨 **Fehlerbehandlung**

### **Proxy funktioniert nicht**
1. Container-Status prüfen
2. Netzwerkverbindung prüfen
3. DNS-Auflösung prüfen
4. Firewall prüfen

### **SSL-Probleme**
1. Zertifikat prüfen
2. Domain-Validierung prüfen
3. Let's Encrypt Rate-Limits prüfen

### **Performance-Probleme**
1. Nginx-Konfiguration optimieren
2. Cache-Einstellungen prüfen
3. Load Balancing konfigurieren

### **502 Bad Gateway**
1. Backend-Container prüfen
2. Port-Konfiguration prüfen
3. Health-Check prüfen

## 🔌 **Integrationen**

### **Docker-Netzwerke**
```yaml
networks:
  external:
    name: saarlandletsplay-external
  internal:
    name: saarlandletsplay-internal
```

### **Custom Nginx Konfiguration**
```nginx
# /data/nginx/custom/server_proxy.conf
location /api {
    proxy_pass http://backend:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### **Rate Limiting**
```nginx
# /data/nginx/custom/http_rate_limit.conf
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req zone=api burst=20 nodelay;
```

## 🔐 **Sicherheit**

### **Security Headers**
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
```

### **IP-Whitelist**
```nginx
allow 192.168.1.0/24;
allow 10.0.0.0/8;
deny all;
```

### **Fail2Ban Integration**
```bash
# Fail2Ban für Nginx
[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
```

## 📚 **Nützliche Links**

- [Nginx Proxy Manager Dokumentation](https://nginxproxymanager.com/)
- [Nginx Dokumentation](https://nginx.org/en/docs/)
- [Let's Encrypt](https://letsencrypt.org/)
- [SSL Labs](https://www.ssllabs.com/ssltest/)

---

*Nginx Proxy Manager - Easy Reverse Proxy* 🌐
