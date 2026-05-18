#!/bin/bash

# Remote Deployment Script für Server 5.175.180.185
# Kopiert und führt alle Scripts auf dem Remote-Server aus

set -e

# Farben für Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Konfiguration
REMOTE_SERVER="5.175.180.185"
SSH_USER="root"
SSH_KEY="$HOME/.ssh/id_rsa"
REMOTE_DIR="/opt/dockerserver"

# Logging Funktion
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Prüfe SSH Verbindung
check_ssh() {
    log "Prüfe SSH Verbindung zu $REMOTE_SERVER..."
    log "SSH Key: $SSH_KEY"
    
    if ! ssh -i $SSH_KEY -o ConnectTimeout=10 -o BatchMode=yes $SSH_USER@$REMOTE_SERVER "echo 'SSH Verbindung erfolgreich'" 2>/dev/null; then
        error "SSH Verbindung zu $REMOTE_SERVER fehlgeschlagen. Prüfen Sie:"
        error "1. SSH Key: $SSH_KEY"
        error "2. Server IP: $REMOTE_SERVER"
        error "3. SSH User: $SSH_USER"
        error "4. Firewall/Port 22 erreichbar?"
    fi
    
    log "SSH Verbindung erfolgreich"
}

# Kopiere Dateien zum Remote-Server
copy_files() {
    log "Kopiere Dateien zum Remote-Server..."
    
    # Remote-Verzeichnis erstellen
    ssh -i $SSH_KEY $SSH_USER@$REMOTE_SERVER "mkdir -p $REMOTE_DIR"
    
    # Kopiere alle Verzeichnisse und Scripts
    rsync -avz -e "ssh -i $SSH_KEY" \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='data/' \
        --exclude='vw-data/' \
        --exclude='database/' \
        --exclude='mariadb_data/' \
        --exclude='owncloud_files/' \
        --exclude='grafana_data/' \
        --exclude='prometheus_data/' \
        --exclude='config/' \
        ./ \
        $SSH_USER@$REMOTE_SERVER:$REMOTE_DIR/
    
    log "Dateien kopiert"
}

# Führe Haupt-Deployment auf Remote-Server aus
deploy_remote() {
    log "Führe Haupt-Deployment auf Remote-Server aus..."
    
    ssh -i $SSH_KEY $SSH_USER@$REMOTE_SERVER << EOF
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:\$PATH"
        cd $REMOTE_DIR
        
        # Script ausführbar machen
        chmod +x deploy-stacks.sh
        chmod +x setup-vaultwarden.sh
        
        # Deployment ausführen
        echo "=== Starte Haupt-Deployment ==="
        ./deploy-stacks.sh
        
        echo ""
        echo "=== Haupt-Deployment abgeschlossen ==="
EOF
    
    log "Haupt-Deployment auf Remote-Server ausgeführt"
}

# Führe Vaultwarden Setup auf Remote-Server aus
deploy_vaultwarden_remote() {
    log "Führe Vaultwarden Setup auf Remote-Server aus..."
    
    ssh -i $SSH_KEY $SSH_USER@$REMOTE_SERVER << EOF
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:\$PATH"
        cd $REMOTE_DIR
        
        # Vaultwarden Setup ausführen
        echo "=== Starte Vaultwarden Setup ==="
        ./setup-vaultwarden.sh
        
        echo ""
        echo "=== Vaultwarden Setup abgeschlossen ==="
EOF
    
    log "Vaultwarden Setup auf Remote-Server ausgeführt"
}

# Zeige Remote-Status
show_remote_status() {
    log "Zeige Status auf Remote-Server..."
    
    ssh -i $SSH_KEY $SSH_USER@$REMOTE_SERVER << EOF
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:\$PATH"
        cd $REMOTE_DIR
        
        echo ""
        echo "=== Container Status auf $REMOTE_SERVER ==="
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        
        echo ""
        echo "=== Netzwerk-Übersicht ==="
        docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"
        
        echo ""
        echo "=== Volume-Übersicht ==="
        docker volume ls --format "table {{.Name}}\t{{.Driver}}"
        
        echo ""
        echo "=== Zugriffs-Informationen für $REMOTE_SERVER ==="
        echo "Dockhand: http://$REMOTE_SERVER:3000"
        echo "phpMyAdmin: http://$REMOTE_SERVER:8080"
        echo "pgAdmin: http://$REMOTE_SERVER:5050"
        echo "Nginx Proxy Manager: http://$REMOTE_SERVER:81"
        echo "Vaultwarden: http://$REMOTE_SERVER:8083"
        echo ""
        echo "Nutzerdaten für Verwaltungstools:"
        echo "phpMyAdmin: root / R7x2!vBfP9qK"
        echo "pgAdmin: admin@saarlandletsplay.de / PgR7x2!vBfP9qK"
        echo "Vaultwarden Admin: daniel@fam-stauder.de / Gn9fe4cdz.Emily"
EOF
}

# Hauptfunktion
main() {
    log "=== Remote Deployment Script für $REMOTE_SERVER ==="
    log "SSH User: $SSH_USER | SSH Key: $SSH_KEY"
    
    # Prüfung
    check_ssh
    
    # Deployment
    copy_files
    deploy_remote
    deploy_vaultwarden_remote
    
    # Status
    show_remote_status
    
    echo ""
    log "=== Remote Deployment abgeschlossen ==="
    echo ""
    info "=== Nächste Schritte ==="
    echo "1. Dockhand aufrufen: http://$REMOTE_SERVER:3000"
    echo "2. Services über Dockhand verwalten"
    echo "3. Nginx Proxy Manager für Domains konfigurieren: http://$REMOTE_SERVER:81"
    echo "4. Firewall prüfen (Ports 80, 443, 81, 3000, 8080, 8083)"
    echo ""
    warning "ACHTUNG: Passen Sie die DOMAIN-Konfigurationen an Ihre echten Domains an!"
    warning "Aktuell sind localhost-URLs konfiguriert"
    echo ""
    log "Alle Services laufen auf $REMOTE_SERVER und sind über Dockhand verwaltbar!"
}

# Script ausführen
main "$@"
