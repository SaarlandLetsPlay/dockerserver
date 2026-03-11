# Stalwart Mail Server + Roundcube Webmail

## Übersicht

All-in-One Mailserver-Stack mit **Stalwart** (SMTP, IMAP, POP3, Sieve, DKIM, SPF, DMARC) und **Roundcube** als Webmail-Client. Nutzt die zentrale MySQL-Instanz für beide Dienste.

## Services

| Service | Image | Beschreibung |
|---|---|---|
| **Stalwart** | `stalwartlabs/mail-server:latest` | Mailserver (SMTP, IMAP, POP3, Sieve, Webadmin) |
| **Roundcube** | `roundcube/roundcubemail:latest` | Webmail-Client mit Elastic Skin |

## Ports

### Stalwart
| Port | Protokoll | Beschreibung |
|---|---|---|
| 25 | SMTP | Eingehende Mails |
| 587 | Submission | Ausgehende Mails (STARTTLS) |
| 465 | SMTPS | Ausgehende Mails (SSL/TLS) |
| 143 | IMAP | Mailbox-Zugriff (STARTTLS) |
| 993 | IMAPS | Mailbox-Zugriff (SSL/TLS) |
| 110 | POP3 | Mailbox-Zugriff (STARTTLS) |
| 995 | POP3S | Mailbox-Zugriff (SSL/TLS) |
| 8443 | HTTPS | Stalwart Webadmin |
| 8880 | HTTP | Stalwart HTTP API |
| 4190 | Sieve | ManageSieve Filterregeln |

### Roundcube
| Port | Protokoll | Beschreibung |
|---|---|---|
| 8881 | HTTP | Roundcube Webmail |

## Domains

| Domain | Verwendung |
|---|---|
| `mail.saarlandletsplay.de` | Stalwart Webadmin + MX-Record |
| `webmail.saarlandletsplay.de` | Roundcube Webmail (über NPM) |

## DNS-Einträge (erforderlich)

```
; MX Record
@                   MX  10  mail.saarlandletsplay.de.

; A/AAAA Records
mail                A       5.175.180.185
mail                AAAA    2a0f:6284:4300:101::13a9

; SPF
@                   TXT     "v=spf1 mx a:mail.saarlandletsplay.de ~all"

; DKIM (Key aus Stalwart Webadmin kopieren)
default._domainkey  TXT     "v=DKIM1; k=rsa; p=<KEY>"

; DMARC
_dmarc              TXT     "v=DMARC1; p=quarantine; rua=mailto:postmaster@saarlandletsplay.de"

; Autodiscover/Autoconfig
autoconfig          CNAME   mail.saarlandletsplay.de.
autodiscover        CNAME   mail.saarlandletsplay.de.

; SRV Records (optional, für Auto-Konfiguration)
_submission._tcp    SRV     0 1 587 mail.saarlandletsplay.de.
_imaps._tcp         SRV     0 1 993 mail.saarlandletsplay.de.
```

## MySQL-Datenbanken

Vor dem Start auf der zentralen MySQL-Instanz anlegen:

```bash
docker exec mysql mysql -u root -p'R7x2!vBfP9qK' -e "
  CREATE DATABASE IF NOT EXISTS stalwart_db;
  CREATE DATABASE IF NOT EXISTS roundcube_db;
  CREATE USER IF NOT EXISTS 'stalwart'@'%' IDENTIFIED BY 'StW8!mK3qR7xP2vL';
  CREATE USER IF NOT EXISTS 'roundcube'@'%' IDENTIFIED BY 'RcB5!nW9pL3xK7mT';
  GRANT ALL PRIVILEGES ON stalwart_db.* TO 'stalwart'@'%';
  GRANT ALL PRIVILEGES ON roundcube_db.* TO 'roundcube'@'%';
  FLUSH PRIVILEGES;
"
```

## Quickstart

```bash
# 1. Datenbanken und User anlegen (siehe oben)
# 2. Stack starten
docker compose up -d

# 3. Stalwart Webadmin öffnen
# https://mail.saarlandletsplay.de:8443 (oder über NPM)

# 4. Roundcube Webmail (über NPM konfigurieren)
# https://webmail.saarlandletsplay.de
```

## Stalwart Ersteinrichtung

1. **Webadmin** aufrufen: `https://<server-ip>:8443`
2. Login: `admin` / Passwort aus `.env` (`STALWART_ADMIN_PASSWORD`)
3. **Domain** hinzufügen: `saarlandletsplay.de`
4. **DKIM-Key** generieren und DNS-Eintrag setzen
5. **Postfächer** anlegen
6. **TLS-Zertifikate** konfigurieren (Let's Encrypt oder über NPM)

## Wartung

```bash
# Logs anzeigen
docker logs stalwart --tail 50
docker logs roundcube --tail 50

# Mail-Queue prüfen
docker exec stalwart stalwart-cli queue list

# Container neustarten
docker compose restart
```

## Netzwerk

- **saarlandletsplay-internal**: Kommunikation mit MySQL, Stalwart ↔ Roundcube
- **saarlandletsplay-external**: Erreichbarkeit über NPM

## Sicherheit

- Stalwart unterstützt SPF, DKIM, DMARC, ARC nativ
- TLS wird für SMTP, IMAP, POP3 erzwungen
- Roundcube nutzt verschlüsselte Verbindung zu Stalwart (IMAPS/STARTTLS)
- Sieve-Filter für serverseitige Mailregeln
