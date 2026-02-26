#!/bin/bash

# --- 1. INFRASTRUKTUR (Node 01) ---
echo ">>> Starte Consul und Gateway auf Node 01..."
docker --context node1-ctx compose -f infra.yml up -d
docker --context node1-ctx compose -f gateway.yml up -d
docker --context node1-ctx compose -f agent-1.yml up -d
# HINWEIS: Logspout auf Node-01 lassen wir weg (Gefahr der Endlosschleife!)

# --- 2. DATENBANK (Node 02) ---
echo ">>> Starte Postgres und Adminer auf Node 02..."
docker --context node2-ctx compose -f database.yml up -d
docker --context node2-ctx compose -f agent-2.yml up -d
docker --context node2-ctx compose -f logspout.yml up -d

# --- 3. APPS (Node 03 & 04) ---
echo ">>> Starte Backend & Frontend auf Node 03..."
docker --context node3-ctx compose -f app.yml up -d
docker --context node3-ctx compose -f agent-3.yml up -d
docker --context node3-ctx compose -f logspout.yml up -d

echo ">>> Starte Backend-Replica auf Node 04..."
docker --context node4-ctx compose -f app-node4.yml up -d
docker --context node4-ctx compose -f agent-4.yml up -d
docker --context node4-ctx compose -f logspout.yml up -d

echo -e "\n✅ Cluster wird hochgefahren. Warte 5s auf Healthchecks..."
sleep 5
./check_cluster.sh
