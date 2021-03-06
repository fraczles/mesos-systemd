#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "proxy" ]; then
    exit 0
fi

export ETCDCTL_PEERS="http://$ETCDCTL_PEERS_ENDPOINT"

etcdctl set /images/capcom       "behance/capcom:latest"
etcdctl set /images/capcom2      "behance/capcom:latest"

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull behance/mesos-proxy-setup
docker pull $(etcdctl get /images/capcom)
docker pull $(etcdctl get /images/capcom2)
