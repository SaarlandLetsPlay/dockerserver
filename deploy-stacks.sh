#!/bin/bash

# Dockhand Stack Deployment Script
# Erstellt Container nacheinander und macht sie über Dockhand verwaltbar

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

# Prüfe und installiere Docker
install_docker() {
    log "Prüfe Docker Installation..."
    
    # Prüfe ob Docker installiert ist
    if ! command -v docker &> /dev/null; then
        log "Docker nicht gefunden - installiere Docker..."
        
        # Docker installieren
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg lsb-release
        
        # Docker GPG Key hinzufügen
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        
        # Docker Repository hinzufügen
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Docker installieren
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        # Docker Service starten und aktivieren
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Benutzer zur docker Gruppe hinzufügen
        sudo usermod -aG docker $USER
        
        log "Docker installiert - bitte neu einloggen oder 'newgrp docker' ausführen"
    else
        log "Docker ist bereits installiert"
        
        # Docker auf aktuelle Version aktualisieren
        log "Aktualisiere Docker auf neueste Version..."
        sudo apt-get update
        sudo apt-get install -y --only-upgrade docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
    
    # Prüfe Docker Compose Plugin
    if ! docker compose version &> /dev/null; then
        error "Docker Compose Plugin nicht verfügbar"
    fi
    
    log "Docker Version: $(docker --version)"
    log "Docker Compose Version: $(docker compose version)"
}

# Prüfe ob Docker läuft
check_docker() {
    log "Prüfe Docker Service..."
    
    # Warte kurz falls Docker gerade erst startet
    sleep 2
    
    if ! docker info > /dev/null 2>&1; then
        error "Docker ist nicht gestartet oder nicht erreichbar. Bitte starten Sie: sudo systemctl start docker"
    fi
    
    log "Docker ist verfügbar und läuft"
}

# Erstelle notwendige Verzeichnisse
create_directories() {
    log "Erstelle /opt/stacks Verzeichnisstruktur..."
    
    sudo mkdir -p /opt/stacks/{mysql,postgresql,nginx-proxy-manager,pgadmin,phpmyadmin,dockhand,satisfactory-server,starrapture,authentik,nextcloud,paperless,openarchiver,grafana,gaseous,gitlab,jitsi,minecraft,factorio}
    sudo mkdir -p /opt/stacks/postgresql/init-scripts
    sudo mkdir -p /opt/stacks/pgadmin/data
    
    # Berechtigungen setzen
    sudo chown -R $USER:$USER /opt/stacks
    sudo chmod -R 755 /opt/stacks
    
    # pgAdmin benötigt spezielle UID/GID-Berechtigungen (5050:5050)
    sudo chown -R 5050:5050 /opt/stacks/pgadmin
    
    # PostgreSQL benötigt spezielle UID/GID-Berechtigungen (70:70) für seine Datenbank-Dateien
    if [ -d "/opt/stacks/postgresql/data" ]; then
        sudo chown -R 70:70 /opt/stacks/postgresql/data
    fi
    
    log "Verzeichnisstruktur erstellt"
}

# Erstelle Docker Netzwerke
create_networks() {
    log "Erstelle Docker Netzwerke..."
    
    # Erstelle Netzwerke falls sie nicht existieren
    if ! docker network ls | grep -q "saarlandletsplay-internal"; then
        docker network create saarlandletsplay-internal
        log "Netzwerk saarlandletsplay-internal erstellt"
    else
        log "Netzwerk saarlandletsplay-internal existiert bereits"
    fi
    
    if ! docker network ls | grep -q "saarlandletsplay-external"; then
        docker network create saarlandletsplay-external
        log "Netzwerk saarlandletsplay-external erstellt"
    else
        log "Netzwerk saarlandletsplay-external existiert bereits"
    fi
    
    if ! docker network ls | grep -q "my_ipv6_net"; then
        docker network create my_ipv6_net
        log "Netzwerk my_ipv6_net erstellt"
    else
        log "Netzwerk my_ipv6_net existiert bereits"
    fi
    
    log "Alle Netzwerke bereit"
}

# Warte auf Container Health
wait_for_health() {
    local container_name=$1
    local max_attempts=${2:-30}
    local attempt=1
    
    log "Warte auf Health-Check von $container_name..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker inspect --format='{{.State.Health.Status}}' $container_name 2>/dev/null | grep -q "healthy"; then
            log "$container_name ist healthy"
            return 0
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            warning "$container_name Health-Check timeout nach $max_attempts Versuchen"
            return 1
        fi
        
        sleep 2
        attempt=$((attempt + 1))
    done
}

# Warte auf Container Start
wait_for_container() {
    local container_name=$1
    local max_attempts=${2:-30}
    local attempt=1
    
    log "Warte auf Start von $container_name..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker inspect --format='{{.State.Running}}' $container_name 2>/dev/null | grep -q "true"; then
            log "$container_name läuft"
            sleep 5 # Extra Zeit für vollständigen Start
            return 0
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            warning "$container_name Start timeout nach $max_attempts Versuchen"
            return 1
        fi
        
        sleep 2
        attempt=$((attempt + 1))
    done
}

# Starte Stack mit Fehlerbehandlung
start_stack() {
    local stack_dir=$1
    local stack_name=$2
    local wait_for_health_check=${3:-true}
    
    log "Starte Stack: $stack_name"
    
    if [ ! -d "$stack_dir" ]; then
        error "Verzeichnis $stack_dir nicht gefunden"
    fi
    
    cd "$stack_dir"
    
    # Prüfe ob compose.yml existiert
    if [ ! -f "compose.yml" ]; then
        error "compose.yml in $stack_dir nicht gefunden"
    fi
    
    # Starte den Stack
    docker compose up -d
    
    # Warte auf Container (falls bekannt)
    case $stack_name in
        "mysql")
            wait_for_container "mysql"
            if [ "$wait_for_health_check" = "true" ]; then
                wait_for_health "mysql"
            fi
            ;;
        "postgresql")
            wait_for_container "postgresql"
            if [ "$wait_for_health_check" = "true" ]; then
                wait_for_health "postgresql"
            fi
            ;;
        "nginx-proxy-manager")
            wait_for_container "npm"
            ;;
        "pgadmin")
            wait_for_container "pgadmin"
            ;;
        "phpmyadmin")
            wait_for_container "phpmyadmin"
            ;;
        "dockhand")
            wait_for_container "dockhand"
            ;;
    esac
    
    log "Stack $stack_name erfolgreich gestartet"
    
    # Zurück zum Startverzeichnis
    cd - > /dev/null
}

# Hauptfunktion
main() {
    log "=== Dockhand Stack Deployment Script ==="
    log "Starte Deployment aller Services..."
    
    # Installation und Prüfung
    install_docker
    check_docker
    create_directories
    create_networks
    
    # Deployment-Reihenfolge (Datenbanken zuerst)
    local stacks=(
        "mysql:mysql:true"
        "postgresql:postgresql:true"
        "dockhand:dockhand:false"
        "phpmyadmin:phpmyadmin:false"
        "pgadmin:pgadmin:false"
        "nginx-proxy-manager:nginx-proxy-manager:false"
        "authentik:authentik:false"
        "nextcloud:nextcloud:false"
        "paperless:paperless:false"
        "openarchiver:openarchiver:false"
        "grafana:grafana:false"
        "gaseous:gaseous:false"
        "gitlab:gitlab:false"
        "jitsi:jitsi:false"
        "minecraft:minecraft:false"
        "factorio:factorio:false"
        "satisfactory:satisfactory:false"
        "starrapture:starrapture:false"
    )
    
    # Starte Stacks nacheinander
    for stack_config in "${stacks[@]}"; do
        IFS=':' read -r dir_name wait_health wait_for_health_check <<< "$stack_config"
        
        stack_path="$(pwd)/$dir_name"
        
        info "=== Nächster Stack: $dir_name ==="
        start_stack "$stack_path" "$wait_health" "$wait_for_health_check"
        
        # Pause zwischen Stacks
        sleep 3
        echo ""
    done
    
    log "=== Deployment abgeschlossen ==="
    
    # Zeige Status
    echo ""
    info "=== Container Status ==="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    info "=== Netzwerk-Übersicht ==="
    docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"
    
    echo ""
    info "=== Docker Versionen ==="
    docker --version
    docker compose version
    
    echo ""
    info "=== Zugriffs-Informationen ==="
    echo "Dockhand: http://localhost:3000"
    echo "phpMyAdmin: http://localhost:8080"
    echo "pgAdmin: http://localhost:5050"
    echo "Nginx Proxy Manager: http://localhost:81"
    echo ""
    echo "Nutzerdaten für Verwaltungstools:"
    echo "phpMyAdmin: root / R7x2!vBfP9qK"
    echo "pgAdmin: admin@saarlandletsplay.de / PgR7x2!vBfP9qK"
    
    echo ""
    log "Alle Services sind über Dockhand verwaltbar!"
    log "Dockhand kann über http://localhost:3000 erreicht werden"
    
    # Hinweis für Docker Gruppe
    if ! groups $USER | grep -q docker; then
        echo ""
        warning "ACHTUNG: Sie müssen sich neu einloggen oder 'newgrp docker' ausführen um Docker ohne sudo zu nutzen!"
    fi
}

# Script ausführen
main "$@"
