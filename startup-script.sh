#!/bin/bash
# Mount directory
if [ ! -d "/data" ]; then
  mkdir -p /data
fi
# mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mount -o defaults /dev/sdb /data

if [[ ! -d /opt/mysql-db ]]; then
  git clone https://github.com/anrewkaka/mysql-db.git /opt/mysql-db
fi

# docker restart
sed -i 's/dockerd -H fd\:\/\/$/dockerd -H fd\:\/\/ --bip=10.0.42.1\/24 --fixed-cidr=10.0.42.0\/24/' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker

cd /opt/subversion
git reset --hard
git clean -f
git checkout master
git pull

export COMPOSE_FILE=/opt/subversion/docker-compose.yml
docker-compose up -d
