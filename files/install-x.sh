#!/bin/sh
rm -Rf /home/docker/data
mkdir -p /home/docker/data
chmod 776 /home/docker/data
chown docker:docker /home/docker/data
mkdir -p /home/docker/data/mongo-db-config
mkdir -p /home/docker/data/mongo-db-data
mkdir -p /home/docker/data/h2-db-data
mkdir -p /home/docker/data/rabbit-mq
chmod -Rf 776 /home/docker/data
exit 0
