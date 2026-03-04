# Multi-Node Docker-in-Docker Cluster mit Consul & Logging
Dieses Projekt baut eine Fullstack-Umgebung auf vier virtuellen Docker-Nodes (Docker-in-Docker) innerhalb einer Multipass-VM auf. Es nutzt Consul für Service Discovery, Nginx als zentrales Gateway und einen zentralen Log-Collector.
## 📁 Projektstruktur
Plaintext
.
├── infra.yml               # Consul & Log-Collector (Node 01)
├── gateway.yml             # Nginx Gateway & Config (Node 01)
├── database.yml            # PostgreSQL & Adminer (Node 02)
├── app.yml                 # Backend & Frontend (Node 03-04)
├── logspout.yml            # Log-Forwarder für Nodes 02-04
├── agents/                 # Consul-Registrator Konfigurationen
│   ├── agent-1.yml
│   ├── ...
│   └── agent-4.yml
├── gateway/                # Nginx Konfigurationsdateien
│   └── nginx.conf
└── scripts/                # Automatisierungsskripte
    ├── up_cluster.sh       # Fährt das gesamte System hoch
    ├── check_cluster.sh    # Prüft Status & Healthchecks
    └── clean_cluster.sh    # Löscht alle Container, Volumes & Netze
## 🚀 Setup & Betrieb
### 1. Vorbereitung (Multipass & Nodes)
Bevor die Skripte laufen, müssen die Multipass-VM und die dind-Instanzen (node-01 bis node-04) gestartet sein.
* VM IP: 10.114.169.46 (Beispiel)
* Netzwerk: Alle Nodes müssen im cluster-net (172.18.0.0/16) erreichbar sein.
### 2. Cluster hochfahren
Das Skript up_cluster.sh startet die Komponenten in der logisch richtigen Reihenfolge (Infrastruktur -> DB -> Apps).
Bash

chmod +x scripts/*.sh
./scripts/up_cluster.sh
### 3. Status prüfen
Um sicherzustellen, dass alle Services bei Consul registriert sind und die Logspouts laufen:
Bash

./scripts/check_cluster.sh
### 4. Hausputz (Reset)
Um den Cluster komplett zu löschen (inklusive Datenbank-Inhalten und Docker-Netzwerken) und von vorne zu beginnen:
Bash

./scripts/clean_cluster.sh
## 🛠 Wichtige Hinweise zum Networking & Logging
* Zentrales Logging: Der log-collector auf Node-01 läuft im network_mode: host, um UDP-Pakete von allen Nodes auf 172.18.0.2:514 zu empfangen.
* Log-Loops: Auf Node-01 ist kein Logspout installiert, um Endlosschleifen mit dem Collector zu verhindern. Der Collector selbst ist mit logspout.exclude=true markiert.
* Adminer: Der Zugriff erfolgt über http://<VM-IP>/adminer/. Das Gateway kümmert sich um das Rewrite der Pfade und die Korrektur der Session-Cookies (proxy_cookie_path).

## Ein kleiner Tipp für dein Git:
Bevor du das File pushst, stelle sicher, dass die Dateipfade in deinen Skripten wirklich mit der neuen Struktur (z.B. agents/agent-1.yml) übereinstimmen.
Soll ich dir noch die passenden scp-Befehle aufschreiben, falls du das gesamte Verzeichnis von Ubuntu auf den Mac synchronisieren willst, um die neue Struktur dort direkt zu übernehmen?
