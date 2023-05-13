# Docker Container for Apache CloudStack Management Server

This repository maintains the Dockerfile and scripts to build docker image for Apache CloudStack Management Server.

## Steps

### (Optional) Build docker image

    docker build -f Dockerfile -t ustcweizhou/cloudstack-management .

### Update docker-compose configuration

Edit cloudstack-mgt01.yaml and update to proper configuration

### Install docker-compose

    apt install docker-compose -y

### Create the containers

    docker-compose -f cloudstack-mgt01.yaml up -d

### List the containers

    docker-compose -f cloudstack-mgt01.yaml ps

##  Advanced steps

### Access the containers via docker-compose

    docker-compose -f cloudstack-mgt01.yaml exec mgt01 bash

### Access the containers via IP (from container host)

The container IP is accessible from other hosts, except the container host.

To access container IP from the container host, or vice versa:

    ip link add cloudstack-nic link eth0 type macvlan mode bridge
    ip addr add 10.0.33.6/20 dev cloudstack-nic (only if the host IP is in different range as container IP)
    ip link set cloudstack-nic up
    ip route add 10.0.34.217/32 dev cloudstack-nic

### Install CloudStack database

You need to install mysql server in advance.
You can create a mariadb galera cluster, refer to https://github.com/ustcweizhou/docker-mariadb-cluster

Please note, GET_LOCK is not supported if WSREP_ON is ON.

    mysql> SELECT GET_LOCK('lock',10);
    ERROR 1235 (42000): This version of MariaDB doesn't yet support 'GET_LOCK in cluster (WSREP_ON=ON)'
    
To fix it, make the following change in the containers and restart them.

    sed -i "s/wsrep_on = ON/wsrep_on = OFF/g" /etc/mysql/conf.d/90-galera.cnf

### Setup CloudStack database

    cloudstack-setup-databases cloud:cloud@10.0.34.213:13306 \
        --deploy-as=root:cloudstack \
        -e file -m mgtkey -k dbkey -i 10.0.34.217

### Manage CloudStack services

To manage cloudstack management service:

    /usr/bin/cloudstack-management status/start/stop/restart

To manage cloudstack usage service:

    /usr/bin/cloudstack-usage status/start/stop/restart

