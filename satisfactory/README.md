# 🏭 **Satisfactory Dedicated Server**

## 📋 **Übersicht**

Satisfactory ist ein 3D-Factory-Building-Spiel mit First-Person-Perspektive. Der Dedicated Server ermöglicht Multiplayer-Sessions.

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
   docker compose logs -f satisfactory
   ```

## 🌐 **Zugriff**

- **Game**: `5.175.180.185:7777`
- **Query**: `5.175.180.185:27015`

## ⚙️ **Konfiguration**

### **Ports**
- `7777`: Game-Port (UDP)
- `27015`: Query-Port (UDP)

### **Server-Einstellungen**
- Server-Name
- Maximale Spieler
- Spiel-Modus
- Welt-Seed

## 📁 **Verzeichnisstruktur**

```
satisfactory/
├── compose.yml          # Docker-Konfiguration
├── .env                 # Umgebungsvariablen
├── data/               # Spiel-Daten
│   ├── Config/         # Konfiguration
│   └── Save/           # Spielstände
└── README.md           # Diese Datei
```

## 🔧 **Konfigurationsoptionen**

### **Server-Einstellungen**
```env
SERVER_NAME=SaarlandLetsPlay Satisfactory
MAX_PLAYERS=4
GAME_MODE=Creative
```

### **Welt-Einstellungen**
```env
WORLD_SEED=12345
WORLD_NAME=SaarlandFactory
```

## 🎮 **Spiel-Features**

### **Factory Building**
- ✅ Automatisierte Produktionsketten
- ✅ Fördersysteme
- ✅ Energie-Management
- ✅ Forschung

### **Multiplayer**
- ✅ Kooperatives Bauen
- ✅ Ressourcen-Sharing
- ✅ Chat-System
- ✅ Spieler-Verwaltung

## 📊 **Monitoring**

### **Logs ansehen**
```bash
docker compose logs -f satisfactory
```

### **Server-Status**
```bash
# Spieler-Online
docker exec satisfactory query --port 27015

# Server-Info
docker exec satisfactory status
```

## 🛠️ **Wartung**

### **Backup erstellen**
```bash
# Spielstände sichern
tar -czf satisfactory_backup.tar.gz data/Save/
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

## 🚨 **Fehlerbehandlung**

### **Verbindungsprobleme**
1. UDP-Ports prüfen
2. Firewall prüfen
3. Server-Status prüfen

### **Performance-Probleme**
1. CPU/Memory prüfen
2. Spieler-Anzahl reduzieren
3. Welt-Komplexität prüfen

## 📚 **Nützliche Links**

- [Satisfactory Wiki](https://satisfactory.fandom.com/wiki/Satisfactory_Wiki)
- [Satisfactory Dedicated Server](https://satisfactory.fandom.com/wiki/Dedicated_servers)

---

*Satisfactory - Build Your Factory* 🏭
