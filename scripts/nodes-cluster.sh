#!/bin/bash
# Netzwerk für die Kommunikation der Nodes untereinander
docker network create --subnet=172.18.0.0/16 cluster-net
# Erstellung der 4 Nodes (Docker-in-Docker)
for i in {1..4}; do
    docker run --privileged --name node-0$i -d \
    --network cluster-net --network-alias node-0$i \
    --ip 172.18.0.$((i+1)) \
    -e DOCKER_TLS_CERTDIR="" \
    docker:dind
done