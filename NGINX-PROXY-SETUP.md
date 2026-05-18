# Nginx Proxy Manager - Container Anbindung & SSL Setup

## 🚀 **Schnellstart**

1. **Nginx Proxy Manager aufrufen**: `http://5.175.180.185:81`
2. **Login**: `admin@example.com` / `changeme`
3. **Passwort ändern** nach erstem Login

## 📋 **Container-Übersicht & Ports**

### **Management Tools**
| Service | Interner Host | Port | Subdomain |
|---------|---------------|------|-----------|
| Nginx Proxy Manager | `npm` | 81 | `npm.saarlandletsplay.de` |
| Dockhand | `dockhand` | 3000 | `dockhand.saarlandletsplay.de` |
| phpMyAdmin | `phpmyadmin` | 80 | `db.mysql.saarlandletsplay.de` |
| pgAdmin | `pgadmin` | 80 | `db.postgres.saarlandletsplay.de` |

### **Anwendungen**
| Service | Interner Host | Port | Subdomain |
|---------|---------------|------|-----------|
| Vaultwarden | `vaultwarden` | 80 | `passwort.saarlandletsplay.de` |
| Nextcloud | `nextcloud` | 80 | `cloud.saarlandletsplay.de` |
| Authentik | `authentik` | 9000 | `auth.saarlandletsplay.de` |
| GitLab | `gitlab` | 80 | `git.saarlandletsplay.de` |
| Grafana | `grafana` | 3000 | `grafana.saarlandletsplay.de` |

---

## 🔧 **1. Wildcard-Zertifikat erstellen (Cloudflare DNS Challenge)**

Bevor die Proxy Hosts angelegt werden, erstellen wir **EIN zentrales Zertifikat** für alle Dienste.

1. Gehe zu **SSL Certificates** → **Add SSL Certificate** → **Let's Encrypt**
2. **Domain Names**: `*.saarlandletsplay.de` eintragen und Enter drücken
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
   - Wähle das Zertifikat `*.saarlandletsplay.de` aus dem Dropdown-Menü!
   - Aktiviere **Force SSL**
   - Aktiviere **HTTP/2 Support**

Hier sind die genauen Ziel-Daten (Subdomain, Hostname, Port) für alle deine Dienste:

### **Nginx Proxy Manager (sich selbst verwalten)**
- **Domain Names**: `npm.saarlandletsplay.de`
- **Forward Hostname**: `npm`
- **Forward Port**: `81`

### **Dockhand**
- **Domain Names**: `dockhand.saarlandletsplay.de`
- **Forward Hostname**: `dockhand`
- **Forward Port**: `3000`

### **Vaultwarden**
- **Domain Names**: `passwort.saarlandletsplay.de`
- **Forward Hostname**: `vaultwarden`
- **Forward Port**: `80`

### **Nextcloud**
- **Domain Names**: `cloud.saarlandletsplay.de`
- **Forward Hostname**: `nextcloud`
- **Forward Port**: `80`

### **Authentik**
- **Domain Names**: `auth.saarlandletsplay.de`
- **Forward Hostname**: `authentik`
- **Forward Port**: `9000`

### **phpMyAdmin**
- **Domain Names**: `db.mysql.saarlandletsplay.de`
- **Forward Hostname**: `phpmyadmin`
- **Forward Port**: `80`

### **pgAdmin**
- **Domain Names**: `db.postgres.saarlandletsplay.de`
- **Forward Hostname**: `pgadmin`
- **Forward Port**: `80`

### **GitLab**
- **Domain Names**: `git.saarlandletsplay.de`
- **Forward Hostname**: `gitlab`
- **Forward Port**: `80`

### **Grafana**
- **Domain Names**: `grafana.saarlandletsplay.de`
- **Forward Hostname**: `grafana`
- **Forward Port**: `3000`
