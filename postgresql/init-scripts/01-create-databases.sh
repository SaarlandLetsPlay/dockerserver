#!/bin/bash
set -e

# Create additional databases and users
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Authentik database and user
    CREATE USER authentik WITH PASSWORD 'authentik_pass';
    GRANT ALL PRIVILEGES ON DATABASE authentik TO authentik;
    
    -- GitLab database and user
    CREATE USER gitlab WITH PASSWORD 'gitlabpass';
    GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production TO gitlab;
    
    -- Grafana database and user
    CREATE USER grafana WITH PASSWORD 'grafana_pass';
    GRANT ALL PRIVILEGES ON DATABASE grafana_db TO grafana;
    
    -- Vaultwarden database and user
    CREATE USER vaultwarden WITH PASSWORD 'vaultwarden_pass';
    GRANT ALL PRIVILEGES ON DATABASE vaultwarden_db TO vaultwarden;
EOSQL
