#!/bin/bash
# Mount directory
if [ ! -d "/data" ]; then
  mkdir -p /data
fi

# mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mount /dev/sdb /data

# docker restart
sed -i 's/dockerd -H fd\:\/\/$/dockerd -H fd\:\/\/ --bip=10.0.42.1\/24 --fixed-cidr=10.0.42.0\/24/' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker

git reset --hard
git clean -f
git checkout master
git pull

export COMPOSE_FILE=./docker-compose.yml
docker-compose up -d
