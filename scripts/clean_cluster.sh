#!/bin/bash
# Wir springen ins Hauptverzeichnis, damit die Pfade zu den YMLs stimmen
cd "$(dirname "$0")/.."

echo ">>> Starte totalen Hausputz auf allen Nodes (inkl. Volumes & Networks)..."

# --- 1. APPS & DB (Nodes 04, 03, 02) ---
# Wir gehen rückwärts vor
for i in 4 3 2; do
  echo ">>> Räume Node 0$i auf..."
  # Hier nutzen wir 'down -v', um Volumes und Netzwerke zu löschen
  # Wir müssen die Dateien angeben, damit Compose weiß, was zu tun ist
  if [ $i -eq 2 ]; then
    docker --context node${i}-ctx compose -f database.yml -f agents/agent-${i}.yml -f logspout.yml down -v --remove-orphans
  elif [ $i -eq 3 ]; then
    docker --context node${i}-ctx compose -f app.yml -f agents/agent-${i}.yml -f logspout.yml down -v --remove-orphans
  elif [ $i -eq 4 ]; then
    docker --context node${i}-ctx compose -f app-node4.yml -f agents/agent-${i}.yml -f logspout.yml down -v --remove-orphans
  fi
  
  # Sicherheitshalber: Alles was noch übrig ist (z.B. manuell gestartete Container)
  docker --context node${i}-ctx system prune -a -f --volumes
done

# --- 2. INFRASTRUKTUR (Node 01) ---
echo ">>> Räume Infrastruktur auf Node 01 als Letztes auf..."
docker --context node1-ctx compose -f infra.yml -f gateway.yml -f agents/agent-1.yml down -v --remove-orphans

# Auch hier: Kompletter Wipe
docker --context node1-ctx system prune -a -f --volumes

echo -e "\n✅ Alle Nodes sind klinisch rein. Netzwerke, Volumes und Container wurden entfernt."
