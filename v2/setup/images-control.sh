#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "control" ]; then
    exit 0
fi

etcdctl set /images/chronos      "mesosphere/chronos:chronos-2.4.0-0.1.20150828104228.ubuntu1404-mesos-0.23.0-1.0.ubuntu1404"
etcdctl set /images/fd           "behance/flight-director:latest"
etcdctl set /images/hud          "behance/flight-director-hud:latest"
etcdctl set /images/marathon     "mesosphere/marathon:v0.10.0"
etcdctl set /images/mesos-master "mesosphere/mesos-master:0.22.1-1.0.ubuntu1404"
etcdctl set /images/zk-exhibitor "behance/docker-zk-exhibitor:latest"

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull jenkins
docker pull behance/docker-dd-agent-mesos
docker pull $(etcdctl get /images/chronos)
docker pull $(etcdctl get /images/fd)
docker pull $(etcdctl get /images/hud)
docker pull $(etcdctl get /images/marathon)
docker pull $(etcdctl get /images/mesos-master)
docker pull $(etcdctl get /images/zk-exhibitor)
