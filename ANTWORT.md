# 🐘 pgAdmin erfolgreich repariert & online!

Das Problem mit dem **Permission Denied**-Fehler und dem anschließenden **502 Bad Gateway** wurde erfolgreich behoben. pgAdmin läuft jetzt voll funktionsfähig und stabil im Hintergrund!

---

## 🔍 Was war die Ursache?

1. **Rechteproblem (Permission Denied):**
   Der pgAdmin-Container läuft intern unter dem unprivilegierten Benutzer `pgadmin` (UID `5050`). Wenn Docker das Host-Verzeichnis `/opt/stacks/pgadmin/data` anlegt oder es dem standardmäßigen Host-User gehört, hat der Container-User keine Schreibrechte. pgAdmin konnte dadurch den Session-Ordner `/var/lib/pgadmin/sessions` nicht erstellen und stürzte in einer Dauerschleife ab.
   
2. **DNS-Cache (502 Bad Gateway):**
   Nachdem wir die Rechte korrigiert und pgAdmin neu gestartet hatten, änderte sich die interne IP-Adresse des Containers. Der Nginx Proxy Manager hatte jedoch noch die alte IP im DNS-Cache gespeichert. Ein Neustart des Nginx Proxy Managers hat diesen Cache gelöscht, sodass die Verbindung nun wieder steht.

---

## 🛠️ Was wurde im Code geändert?

Ich habe dein zentrales Installationsscript [deploy-stacks.sh](file:///home/saarlandletsplay/Dokumente/dockerserver/deploy-stacks.sh) angepasst. Bei zukünftigen Deployments wird der Datenordner nun automatisch mit den korrekten Rechten erstellt:

```bash
# In deploy-stacks.sh (Zeile 97-111)
create_directories() {
    ...
    sudo mkdir -p /opt/stacks/pgadmin/data
    
    # Berechtigungen setzen
    sudo chown -R $USER:$USER /opt/stacks
    sudo chmod -R 755 /opt/stacks
    
    # pgAdmin benötigt spezielle UID/GID-Berechtigungen (5050:5050)
    sudo chown -R 5050:5050 /opt/stacks/pgadmin
}
```

---

## 🌐 Zugriff & Login-Daten

Du kannst pgAdmin jetzt über beide Wege aufrufen:

### 1. Über deine sichere Domain (Empfohlen):
👉 **[https://db.postgres.saarlandletsplay.de](https://db.postgres.saarlandletsplay.de)**

### 2. Direkt über IP und Port (Bypass Proxy):
👉 **[http://5.175.180.185:5050](http://5.175.180.185:5050)**

### 🔐 Deine Zugangsdaten:
*   **Email-Adresse:** `admin@saarlandletsplay.de`
*   **Master-Passwort:** `PgR7x2!vBfP9qK`

---

## 🗄️ So verbindest du deine Datenbanken in pgAdmin

Nachdem du dich eingeloggt hast, kannst du deine PostgreSQL-Datenbanken wie folgt hinzufügen (Klicke links oben auf **Add New Server** ➕):

### 1. PostgreSQL Haupt-Server (Root-Zugriff)
*   **Name (General):** `PostgreSQL Main Server`
*   **Host (Connection):** `postgresql` *(Der Docker-Dienstname)*
*   **Port:** `5432`
*   **Username:** `postgres`
*   **Password:** `PgR7x2!vBfP9qK`
*   **Save password:** `Yes`

### 2. Authentik Datenbank
*   **Name (General):** `Authentik Database`
*   **Host (Connection):** `postgresql`
*   **Port:** `5432`
*   **Username:** `authentik`
*   **Password:** `authentik_pass`
*   **Database:** `authentik`
*   **Save password:** `Yes`

### 3. Vaultwarden Datenbank
*   **Name (General):** `Vaultwarden Database`
*   **Host (Connection):** `postgresql`
*   **Port:** `5432`
*   **Username:** `vaultwarden`
*   **Password:** `vaultwarden_pass`
*   **Database:** `vaultwarden_db`
*   **Save password:** `Yes`

### 4. Grafana Datenbank
*   **Name (General):** `Grafana Database`
*   **Host (Connection):** `postgresql`
*   **Port:** `5432`
*   **Username:** `grafana`
*   **Password:** `grafana_pass`
*   **Database:** `grafana_db`
*   **Save password:** `Yes`

---

Viel Erfolg beim Verwalten deiner Datenbanken! Wenn noch etwas zwickt, sag einfach Bescheid. 🐘💪
