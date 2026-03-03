# 🎮 **Minecraft Server Docker Setup**

## 📋 **Übersicht**

Dieser Docker-Setup ermöglicht es dir, einen Minecraft Server mit verschiedenen Server-Typen und Konfigurationen zu betreiben.

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
   docker compose logs -f minecraft
   ```

## 📦 **Unterstützte Server-Typen**

| Typ | Beschreibung | Image |
|-----|-------------|-------|
| **VANILLA** | Offizieller Minecraft Server | `itzg/minecraft-server` |
| **PAPER** | Optimierter Spigot-Server | `itzg/minecraft-server` |
| **PURPUR** | Noch besser optimiert | `itzg/minecraft-server` |
| **FORGE** | Mod-Server (Forge) | `itzg/minecraft-server` |
| **FABRIC** | Mod-Server (Fabric) | `itzg/minecraft-server` |
| **QUILT** | Mod-Server (Quilt) | `itzg/minecraft-server` |

## ⚙️ **Konfiguration**

### **Server-Typ ändern**
```bash
# In .env Datei:
MINECRAFT_TYPE=PAPER
MINECRAFT_VERSION=1.20.1
```

### **RAM anpassen**
```bash
# In .env Datei:
MEMORY=8G  # 8GB RAM
```

### **Spieleranzahl ändern**
```bash
# In .env Datei:
MAX_PLAYERS=50
```

## 📁 **Verzeichnisstruktur**

```
minecraft/
├── compose.yml          # Docker-Konfiguration
├── .env                 # Umgebungsvariablen
├── data/               # Welt-Daten
├── mods/               # Mods (Forge/Fabric)
├── plugins/            # Plugins (Paper/Spigot)
├── config/             # Konfigurationsdateien
└── README.md           # Diese Datei
```

## 🎯 **Beispiele**

### **Paper Server mit 8GB RAM**
```env
MINECRAFT_TYPE=PAPER
MINECRAFT_VERSION=1.20.1
MEMORY=8G
MAX_PLAYERS=50
```

### **Fabric Server mit Mods**
```env
MINECRAFT_TYPE=FABRIC
MINECRAFT_VERSION=1.20.1
MEMORY=6G
MODS=jei-1.20.1-fabric.jar,fabric-api-0.87.0+1.20.1.jar
```

### **Vanilla Server für kleine Gruppe**
```env
MINECRAFT_TYPE=VANILLA
MINECRAFT_VERSION=1.20.1
MEMORY=2G
MAX_PLAYERS=10
```

## 🔧 **Plugins & Mods**

### **Plugins (Paper/Purpur)**
1. Plugins in `./plugins/` Ordner kopieren
2. Oder über `PLUGINS` Variable in `.env`

### **Mods (Forge/Fabric)**
1. Mods in `./mods/` Ordner kopieren
2. Oder über `MODS` Variable in `.env`

## 🌐 **Network-Konfiguration**

- **Server-Port**: `25565` (Standard)
- **RCON-Port**: `25575`
- **Query-Port**: `25565` (UDP)

## 📊 **Monitoring**

### **Health-Check**
Der Container hat einen integrierten Health-Check, der alle 30 Sekunden prüft, ob der Server läuft.

### **Logs**
```bash
# Live-Logs ansehen
docker compose logs -f minecraft

# Letzte 100 Zeilen
docker compose logs --tail=100 minecraft
```

## 🛠️ **Wartung**

### **Server neustarten**
```bash
docker compose restart minecraft
```

### **Server stoppen**
```bash
docker compose down
```

### **Welt sichern**
```bash
# Welt-Verzeichnis kopieren
cp -r data/world backups/world-$(date +%Y%m%d)
```

### **Konfiguration neu laden**
```bash
# In Minecraft-Console: reload
docker exec minecraft rcon-cli reload
```

## 🚨 **Fehlerbehandlung**

### **Server startet nicht**
1. Logs prüfen: `docker compose logs minecraft`
2. RAM-Einstellung reduzieren
3. Version überprüfen

### **Verbindungsprobleme**
1. Firewall prüfen (Port 25565)
2. Online-Modus prüfen (`ONLINE_MODE=false` für Cracked)
3. Server-Port konfigurieren

### **Performance-Probleme**
1. RAM erhöhen (`MEMORY`)
2. View-Distance reduzieren (`VIEW_DISTANCE`)
3. Paper/Purpur statt Vanilla verwenden

## 📚 **Nützliche Befehle**

### **In-Game Admin-Befehle**
```
/op <player>     # Spieler zum Admin machen
/deop <player>   # Admin-Rechte entziehen
/gamemode <mode> # Spielmodus ändern
/weather <type>  # Wetter ändern
/time <value>    # Zeit ändern
```

### **RCON-Befehle**
```bash
# Server-Status prüfen
docker exec minecraft rcon-cli list

# Spieler kicken
docker exec minecraft rcon-cli kick <player>

# Server stoppen
docker exec minecraft rcon-cli stop
```

## 🔐 **Sicherheit**

### **RCON-Passwort ändern**
```env
RCON_PASSWORD=dein_sicheres_passwort
```

### **Whitelist aktivieren**
```env
ENFORCE_WHITELIST=true
```

### **Backup-Strategie**
```bash
# Automatisches Backup-Skript
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker run --rm -v minecraft_minecraft_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/minecraft_$DATE.tar.gz -C /data .
```

## 📞 **Hilfe & Support**

- [Docker Minecraft Server Dokumentation](https://github.com/itzg/docker-minecraft-server)
- [Minecraft Wiki](https://minecraft.fandom.com/wiki/Minecraft_Wiki)
- [PaperMC Dokumentation](https://papermc.io/)
- [FabricMC Dokumentation](https://fabricmc.net/)

---

*Viel Spaß auf deinem Minecraft Server!* 🎮
