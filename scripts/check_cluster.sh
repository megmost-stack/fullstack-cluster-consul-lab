#!/bin/bash

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}=== 1. Nodes & Contexts Status ===${NC}"
docker context ls | grep node

echo -e "\n${BLUE}=== 2. Consul Service Discovery (via Host) ===${NC}"
# Wir fragen von AUẞERHALB des Containers, da der Host die IP 172.18.0.2 kennt
curl -s http://172.18.0.2:8500/v1/catalog/services | jq 'keys'

echo -e "\n${BLUE}=== 3. Backend Health & IPs ===${NC}"
curl -s http://172.18.0.2:8500/v1/catalog/service/backend | \
jq -r '.[] | "Node: \(.Node) \t Service-IP: \(.ServiceAddress):\(.ServicePort)"'

echo -e "\n${BLUE}=== 4. Gateway Live Test (Internal) ===${NC}"
# Testet, ob das Gateway auf Node-01 (172.18.0.2) auf Port 80 antwortet
curl -I -s http://172.18.0.2:80 | grep HTTP
