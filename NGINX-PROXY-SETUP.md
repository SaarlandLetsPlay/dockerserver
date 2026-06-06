# Nginx Proxy Manager - Container Anbindung & SSL Setup

## 🚀 **Schnellstart**

1. **Nginx Proxy Manager aufrufen**: `http://5.175.180.185:81`
2. **Login**: `admin@example.com` / `changeme`
3. **Passwort ändern** nach erstem Login

## 📋 **Container-Übersicht & Ports**

### **Management Tools**
| Service | Interner Host | Port | Subdomain |
|---------|---------------|------|-----------|
| Nginx Proxy Manager | `npm` | 81 | `npm.example.com` |
| Dockhand | `dockhand` | 3000 | `dockhand.example.com` |
| phpMyAdmin | `phpmyadmin` | 80 | `db.mysql.example.com` |
| pgAdmin | `pgadmin` | 80 | `db.postgres.example.com` |

### **Anwendungen**
| Service | Interner Host | Port | Subdomain |
|---------|---------------|------|-----------|
| Vaultwarden | `vaultwarden` | 80 | `passwort.example.com` |
| Nextcloud | `nextcloud` | 80 | `cloud.example.com` |
| Authentik | `authentik` | 9000 | `auth.example.com` |
| GitLab | `gitlab` | 80 | `git.example.com` |
| Grafana | `grafana` | 3000 | `grafana.example.com` |

---

## 🔧 **1. Wildcard-Zertifikat erstellen (Cloudflare DNS Challenge)**

Bevor die Proxy Hosts angelegt werden, erstellen wir **EIN zentrales Zertifikat** für alle Dienste.

1. Gehe zu **SSL Certificates** → **Add SSL Certificate** → **Let's Encrypt**
2. **Domain Names**: `*.example.com` eintragen und Enter drücken
3. **Email Address**: Deine E-Mail eintragen
4. Schalter aktivieren bei **Use a DNS Challenge**
5. **DNS Provider**: `Cloudflare`
6. Bei den Credentials den Cloudflare-Token eintragen:
   `dns_cloudflare_api_token=DEIN_TOKEN_HIER`
7. **Terms of Service** akzeptieren und **Save** klicken.
*(Nach ca. 10-30 Sekunden steht das Wildcard-Zertifikat zur Verfügung)*

---

## 🔧 **2. Proxy Hosts anlegen**

Gehe im Menü auf **Hosts -> Proxy Hosts -> Add Proxy Host**.
Gehe bei **jedem Dienst** immer nach diesem exakt gleichen Muster vor:

1. **Details:**
   - **Scheme**: `http`
   - Aktiviere immer **Block Common Exploits** und **Websockets Support**
2. **SSL:**
   - Wähle das Zertifikat `*.example.com` aus dem Dropdown-Menü!
   - Aktiviere **Force SSL**
   - Aktiviere **HTTP/2 Support**

Hier sind die genauen Ziel-Daten (Subdomain, Hostname, Port) für alle deine Dienste:

### **Nginx Proxy Manager (sich selbst verwalten)**
- **Domain Names**: `npm.example.com`
- **Forward Hostname**: `npm`
- **Forward Port**: `81`

### **Dockhand**
- **Domain Names**: `dockhand.example.com`
- **Forward Hostname**: `dockhand`
- **Forward Port**: `3000`

### **Vaultwarden**
- **Domain Names**: `passwort.example.com`
- **Forward Hostname**: `vaultwarden`
- **Forward Port**: `80`

### **Nextcloud**
- **Domain Names**: `cloud.example.com`
- **Forward Hostname**: `nextcloud`
- **Forward Port**: `80`

### **Authentik**
- **Domain Names**: `auth.example.com`
- **Forward Hostname**: `authentik`
- **Forward Port**: `9000`

### **phpMyAdmin**
- **Domain Names**: `db.mysql.example.com`
- **Forward Hostname**: `phpmyadmin`
- **Forward Port**: `80`

### **pgAdmin**
- **Domain Names**: `db.postgres.example.com`
- **Forward Hostname**: `pgadmin`
- **Forward Port**: `80`

### **GitLab**
- **Domain Names**: `git.example.com`
- **Forward Hostname**: `gitlab`
- **Forward Port**: `80`

### **Grafana**
- **Domain Names**: `grafana.example.com`
- **Forward Hostname**: `grafana`
- **Forward Port**: `3000`
