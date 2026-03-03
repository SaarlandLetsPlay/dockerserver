# 🏭 **Factorio Server Docker Setup**

## 📋 **Übersicht**

Dieser Docker-Setup ermöglicht es dir, einen voll konfigurierbaren Factorio Server mit automatischen Updates, Mods und Backups zu betreiben.

## 🚀 **Schnellstart**

1. **Konfiguration anpassen:**
   ```bash
   # .env Datei bearbeiten
   nano .env
   ```

2. **Server starten:**
   ```bash
   docker compose up -d
   ```

3. **Server-Logs ansehen:**
   ```bash
   docker compose logs -f factorio
   ```

## 🌐 **Verbindung zum Server**

- **IP**: `5.175.180.185`
- **Port**: `34197`
- **Web-Interface**: `http://5.175.180.185:80`

## ⚙️ **Konfiguration**

### **Server-Einstellungen**
```env
FACTORIO_SERVER_NAME=SaarlandLetsPlay Factorio
FACTORIO_SERVER_PASSWORD=geheimes_passwort
FACTORIO_MAX_PLAYERS=20
```

### **Welt-Einstellungen**
```env
FACTORIO_WORLD_SIZE=large
FACTORIO_WORLD_RESOURCES=rich
FACTORIO_WORLD_ENEMies=high
```

### **Performance**
```env
FACTORIO_MEMORY_LIMIT=8G
FACTORIO_CPU_LIMIT=4.0
```

## 📁 **Verzeichnisstruktur**

```
factorio/
├── compose.yml          # Docker-Konfiguration
├── .env                 # Umgebungsvariablen
├── data/               # Factorio Daten
│   ├── saves/          # Spielstände
│   ├── mods/           # Mods
│   └── config/         # Konfiguration
├── mods/               # Externe Mods
├── saves/              # Externe Saves
├── backups/            # Automatische Backups
└── README.md           # Diese Datei
```

## 🎮 **Spiel-Modi**

### **Standard-Modus**
```env
FACTORIO_GAME_TYPE=normal
FACTORIO_WORLD_ENEMIES=normal
FACTORIO_WORLD_RESOURCES=regular
```

### **Peaceful-Modus**
```env
FACTORIO_GAME_TYPE=peaceful
FACTORIO_WORLD_ENEMIES=none
FACTORIO_WORLD_RESOURCES=rich
```

### **Hardcore-Modus**
```env
FACTORIO_GAME_TYPE=normal
FACTORIO_WORLD_ENEMIES=very-high
FACTORIO_WORLD_RESOURCES=poor
FACTORIO_WORLD_EVOLUTION=1.0
```

## 📦 **Mods installieren**

### **Manuelle Installation**
1. Mods in `./mods/` Ordner kopieren
2. Server neustarten: `docker compose restart factorio`

### **Mod-Pack URL**
```env
FACTORIO_MODPACK_URL=https://mods.factorio.com/modpack/deine-pack-id
```

### **Beliebte Mods**
- **Bob's Mods**: Erweiterte Technologie
- **Angel's Mods**: Komplexe Produktionsketten
- **Space Exploration**: Raumfahrt-Erweiterung
- **Krastorio 2**: Überarbeitung des Spiels

## 🔧 **Admin-Funktionen**

### **Admin-Liste**
```env
FACTORIO_ADMINS=spieler1,spieler2
```

### **Whitelist**
```env
FACTORIO_WHITELIST=spieler1,spieler2,spieler3
```

### **RCON-Befehle**
```bash
# Server-Status
docker exec factorio rcon -c /config/rconpw --port 27015 /status

# Spieler kicken
docker exec factorio rcon -c /config/rconpw --port 27015 /kick spielername

# Server neustarten
docker exec factorio rcon -c /config/rconpw --port 27015 /restart
```

## 📊 **Performance-Optimierung**

### **Memory-Einstellungen**
```env
FACTORIO_MEMORY_LIMIT=8G
FACTORIO_MEMORY_RESERVATION=4G
```

### **CPU-Einstellungen**
```env
FACTORIO_CPU_LIMIT=4.0
FACTORIO_CPU_RESERVATION=2.0
```

### **Tick-Rate**
```env
FACTORIO_MAX_TICKS_PER_MINUTE=60
```

## 🗺️ **Welt-Generation**

### **Welt-Größen**
- `none`: Unendlich
- `very-small`: 250x250
- `small`: 500x500
- `medium`: 1000x1000
- `large`: 2000x2000
- `very-large`: 4000x4000

### **Ressourcen-Dichte**
- `very-poor`: Sehr wenig Ressourcen
- `poor`: Wenig Ressourcen
- `regular`: Normal
- `rich`: Viele Ressourcen
- `very-rich`: Sehr viele Ressourcen

### **Feinde-Stärke**
- `none`: Keine Feinde
- `very-low`: Sehr wenige
- `low`: Wenige
- `normal`: Normal
- `high`: Viele
- `very-high`: Sehr viele

## 📁 **Backup-System**

### **Automatische Backups**
```env
FACTORIO_ENABLE_BACKUPS=true
FACTORIO_BACKUP_INTERVAL=6  # Alle 6 Stunden
FACTORIO_BACKUP_COUNT=24    # 24 Backups behalten
```

### **Manuelle Backups**
```bash
# Welt sichern
docker exec factorio cp /factorio/saves/current.zip /factorio/backups/manual-$(date +%Y%m%d_%H%M%S).zip
```

### **Backup-Wiederherstellung**
```bash
# Backup wiederherstellen
docker exec factorio cp /factorio/backups/backup-20240303_120000.zip /factorio/saves/current.zip
docker compose restart factorio
```

## 🌐 **Web-Interface**

Das Web-Interface bietet:
- 📊 Server-Statistiken
- 👥 Spielerliste
- 🗺️ Welt-Karte
- 📁 Download von Saves
- ⚙️ Konfiguration

**URL**: `http://5.175.180.185:80`

## 🛠️ **Wartung**

### **Server neustarten**
```bash
docker compose restart factorio
```

### **Server stoppen**
```bash
docker compose down
```

### **Logs ansehen**
```bash
# Live-Logs
docker compose logs -f factorio

# Letzte 100 Zeilen
docker compose logs --tail=100 factorio
```

### **Datenbank aufräumen**
```bash
# Alte Saves löschen
docker exec factorio find /factorio/saves -name "*.zip" -mtime +7 -delete

# Alte Backups löschen
docker exec factorio find /factorio/backups -name "*.zip" -mtime +30 -delete
```

## 🚨 **Fehlerbehandlung**

### **Server startet nicht**
1. Logs prüfen: `docker compose logs factorio`
2. Memory-Limit erhöhen
3. Port-Konflikte prüfen

### **Verbindungsprobleme**
1. Firewall prüfen (Port 34197 UDP)
2. Server-Passwort prüfen
3. Whitelist prüfen

### **Performance-Probleme**
1. Memory erhöhen (`FACTORIO_MEMORY_LIMIT`)
2. CPU-Limit erhöhen (`FACTORIO_CPU_LIMIT`)
3. Welt-Größe reduzieren (`FACTORIO_WORLD_SIZE`)

### **Mods funktionieren nicht**
1. Mod-Kompatibilität prüfen
2. Mods neu installieren
3. Server neustarten

## 📚 **Nützliche Befehle**

### **In-Game Admin-Befehle**
```
/admin            # Admin-Modus umschalten
/players          # Spielerliste
/time             # Spielzeit anzeigen
/seed             # Welt-Seed anzeigen
/discard-commands # Befehle verwerfen
```

### **Server-Konsole**
```bash
# In Server-Konsole
docker exec -it factorio bash

# Factorio-Konsole
docker exec -it factorio /factorio/bin/x64/factorio --console
```

## 🔐 **Sicherheit**

### **Server-Passwort**
```env
FACTORIO_SERVER_PASSWORD=dein_sicheres_passwort
```

### **RCON-Passwort**
```env
FACTORIO_RCON_PASSWORD=dein_rcon_passwort
```

### **Whitelist**
```env
FACTORIO_WHITELIST=spieler1,spieler2
FACTORIO_VERIFY_PLAYER_IDENTIFICATION=true
```

## 📞 **Hilfe & Support**

- [Factorio Wiki](https://wiki.factorio.com/)
- [Factorio Forums](https://forums.factorio.com/)
- [Factorio Mod Portal](https://mods.factorio.com/)
- [Docker Factorio Image](https://github.com/factoriotools/factorio-docker)

---

*Viel Spaß beim Bauen deiner Fabrik!* 🏭
