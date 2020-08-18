#!/bin/bash
set -e
ETHO=$1
ADDRESS="$(ip -4 addr show "${ETHO}" | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts


# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.7.11  master-1  master.local.com
192.168.7.21  worker-1 worker1.local.com
192.168.7.22  worker-2 worker2.local.com
192.168.7.30  proxy proxy.local.com
192.168.7.40  nfs nfs.local.com
EOF
