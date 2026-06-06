#!/bin/bash

# Vaultwarden Setup Script
# Erstellt automatisch Vaultwarden mit konfiguriertem Admin-Account

set -e

# Farben für Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Konfiguration
VAULTWARDEN_EMAIL="daniel@fam-stauder.de"
VAULTWARDEN_MASTER_PASSWORD="Gn9fe4cdz.Emily"

# Prüfe ob Docker läuft
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        error "Docker ist nicht gestartet oder nicht erreichbar"
    fi
    log "Docker ist verfügbar"
}

# Erstelle Vaultwarden Verzeichnis
create_vaultwarden_directories() {
    log "Erstelle Vaultwarden Verzeichnisse..."
    
    sudo mkdir -p /opt/stacks/vaultwarden/{data,attachments}
    sudo chown -R $USER:$USER /opt/stacks/vaultwarden
    sudo chmod -R 755 /opt/stacks/vaultwarden
    
    log "Vaultwarden Verzeichnisse erstellt"
}

# Erstelle Vaultwarden Konfigurationsdatei
create_vaultwarden_config() {
    log "Erstelle Vaultwarden Konfiguration..."
    
    cat > /opt/stacks/vaultwarden/config.env << EOF
# Vaultwarden Konfiguration
SIGNUPS_ALLOWED=false
DOMAIN=http://localhost:8082
DATABASE_URL=postgresql://vaultwarden:vaultwarden_pass@postgresql:5432/vaultwarden_db

# Admin Account (wird beim ersten Start erstellt)
ADMIN_TOKEN=$(openssl rand -base64 48)

# SMTP Konfiguration (optional)
SMTP_HOST=mail.example.com
SMTP_PORT=587
SMTP_FROM=noreply@vaultwarden.example.com
SMTP_USERNAME=registry@example.com
SMTP_PASSWORD=PWanq1cB!.555@4m

# Sicherheit
WEBSOCKET_ENABLED=true
WEBSOCKET_ADDRESS=0.0.0.0
WEBSOCKET_PORT=3012

# Daten
DATA_FOLDER=/data
ATTACHMENTS_FOLDER=/attachments
EOF

    log "Vaultwarden Konfiguration erstellt"
}

# Erstelle Vaultwarden compose.yml
create_vaultwarden_compose() {
    log "Erstelle Vaultwarden compose.yml..."
    
    cat > $(pwd)/vaultwarden/compose.yml << 'EOF'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    env_file:
      - /opt/stacks/vaultwarden/config.env
    environment:
      # Überschreibe Admin Token für automatische Erstellung
      ADMIN_TOKEN: ${ADMIN_TOKEN}
    volumes:
      - /opt/stacks/vaultwarden/data:/data
      - /opt/stacks/vaultwarden/attachments:/attachments
    ports:
      - 8082:80
      - 3012:3012
    networks:
      - saarlandletsplay-external
      - saarlandletsplay-internal
      - my_ipv6_net
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/alive"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
networks:
  saarlandletsplay-external:
    external: true
  saarlandletsplay-internal:
    external: true
  my_ipv6_net:
    external: true
EOF

    log "Vaultwarden compose.yml erstellt"
}

# Erstelle PostgreSQL Datenbank für Vaultwarden
create_vaultwarden_database() {
    log "Erstelle Vaultwarden Datenbank..."
    
    # Prüfe ob PostgreSQL Container läuft
    if ! docker ps | grep -q "postgresql"; then
        error "PostgreSQL Container läuft nicht. Bitte starten Sie zuerst die Datenbanken."
    fi
    
    # Erstelle Datenbank und User
    docker exec postgresql psql -U postgres -c "CREATE DATABASE vaultwarden_db;" 2>/dev/null || log "Datenbank vaultwarden_db existiert bereits"
    docker exec postgresql psql -U postgres -c "CREATE USER vaultwarden WITH PASSWORD 'vaultwarden_pass';" 2>/dev/null || log "User vaultwarden existiert bereits"
    docker exec postgresql psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE vaultwarden_db TO vaultwarden;" 2>/dev/null || log "Privileges bereits vergeben"
    
    log "Vaultwarden Datenbank erstellt"
}

# Warte auf Vaultwarden Start
wait_for_vaultwarden() {
    local max_attempts=30
    local attempt=1
    
    log "Warte auf Vaultwarden Start..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f http://localhost:8083/alive > /dev/null 2>&1; then
            log "Vaultwarden ist erreichbar"
            return 0
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            warning "Vaultwarden Start timeout nach $max_attempts Versuchen"
            return 1
        fi
        
        sleep 3
        attempt=$((attempt + 1))
    done
}

# Erstelle Admin Account über API
create_admin_account() {
    log "Erstelle Admin Account..."
    
    # Warte kurz bis Vaultwarden vollständig gestartet ist
    sleep 10
    
    # Erstelle Admin Account über API
    curl -X POST \
        -H "Content-Type: application/json" \
        -d "{
            \"email\": \"$VAULTWARDEN_EMAIL\",
            \"password\": \"$VAULTWARDEN_MASTER_PASSWORD\"
        }" \
        http://localhost:8083/api/accounts 2>/dev/null || log "Admin Account konnte nicht erstellt werden (existiert möglicherweise bereits)"
    
    log "Admin Account erstellt oder existiert bereits"
}

# Hauptfunktion
main() {
    log "=== Vaultwarden Setup Script ==="
    log "Erstelle Vaultwarden mit Admin Account: $VAULTWARDEN_EMAIL"
    
    # Prüfung
    check_docker
    
    # Setup
    create_vaultwarden_directories
    create_vaultwarden_config
    create_vaultwarden_compose
    create_vaultwarden_database
    
    # Starte Vaultwarden
    log "Starte Vaultwarden..."
    cd $(pwd)/vaultwarden
    docker compose up -d
    
    # Warte und konfiguriere
    if wait_for_vaultwarden; then
        create_admin_account
        
        echo ""
        log "=== Vaultwarden Setup abgeschlossen ==="
        echo ""
        info "=== Zugriffs-Informationen ==="
        echo "Vaultwarden Web-Interface: http://localhost:8083"
        echo "Admin Email: $VAULTWARDEN_EMAIL"
        echo "Admin Passwort: $VAULTWARDEN_MASTER_PASSWORD"
        echo ""
        echo "Vaultwarden WebSocket: ws://localhost:3012"
        echo ""
        warning "WICHTIG: Passen Sie die DOMAIN in der Konfiguration an Ihren Server an!"
        warning "Aktuell: https://passwort.example.com"
        echo ""
        log "Vaultwarden ist über Dockhand verwaltbar!"
        
        # Zeige Status
        echo ""
        info "=== Container Status ==="
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep vaultwarden
        
    else
        error "Vaultwarden konnte nicht gestartet werden"
    fi
}

# Script ausführen
main "$@"
