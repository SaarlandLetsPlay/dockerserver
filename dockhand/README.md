# 🐳 **Dockhand Docker Management**

## 📋 **Übersicht**

Dockhand ist ein webbasiertes Docker Management Interface zur Überwachung und Verwaltung von Docker-Containern, Images und Volumes.

## 🚀 **Schnellstart**

1. **Server starten:**
   ```bash
   docker compose up -d
   ```

2. **Logs ansehen:**
   ```bash
   docker compose logs -f dockhand
   ```

## 🌐 **Zugriff**

- **Web-Interface**: `http://5.175.180.185:3000`

## ⚙️ **Konfiguration**

### **Ports**
- `3000`: Web-Interface

### **Volumes**
- `/var/run/docker.sock`: Docker Socket Zugriff

## 📁 **Verzeichnisstruktur**

```
dockhand/
├── compose.yml          # Docker-Konfiguration
└── README.md           # Diese Datei
```

## 🔧 **Funktionen**

### **Container Management**
- ✅ Container starten/stoppen/neustarten
- ✅ Logs ansehen
- ✅ Ressourcen-Überwachung
- ✅ Container-Statistiken

### **Image Management**
- ✅ Images auflisten
- ✅ Images löschen
- ✅ Image-Historie
- ✅ Pull/Push Operationen

### **Volume Management**
- ✅ Volumes auflisten
- ✅ Volumes erstellen/löschen
- ✅ Volume-Statistiken

### **Network Management**
- ✅ Netzwerke auflisten
- ✅ Netzwerke erstellen/löschen
- ✅ Netzwerk-Details

## 📊 **Monitoring**

### **System-Übersicht**
- CPU-Auslastung
- Memory-Nutzung
- Docker-Version
- Anzahl Container/Images/Volumes

### **Container-Statistiken**
- Laufzeit
- Ressourcenverbrauch
- Netzwerk-Traffic
- Speicher-Nutzung

## 🛠️ **Wartung**

### **Logs ansehen**
```bash
docker compose logs -f dockhand
```

### **Container neustarten**
```bash
docker compose restart dockhand
```

### **Update durchführen**
```bash
docker compose pull
docker compose up -d
```

## 🚨 **Fehlerbehandlung**

### **Kein Zugriff auf Docker**
1. Docker Socket prüfen: `/var/run/docker.sock`
2. Berechtigungen prüfen
3. Docker-Dienst prüfen

### **Web-Interface nicht erreichbar**
1. Port-Konflikt prüfen
2. Firewall prüfen
3. Container-Status prüfen

## 🔐 **Sicherheit**

### **Zugriffskontrolle**
- Docker Socket Zugriff
- Netzwerk-Isolation
- Keine externen Ports außer Web-Interface

### **Empfehlungen**
- Nur im internen Netzwerk verwenden
- Docker Socket nicht exponieren
- Regelmäßige Updates

---

*Dockhand - Einfache Docker Verwaltung* 🐳
