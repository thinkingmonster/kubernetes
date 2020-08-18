#! /bin/bash
. /vagrant/centos/00-env.sh
echo "[TASK 1] Download and install NFS server"
yum install -y nfs-utils

echo "[TASK 2] Create a kubedata directory"
mkdir /"${nfs_volume_name}"
chgrp nfsnobody /"${nfs_volume_name}"/
chmod g+w /"${nfs_volume_name}"/

echo "[TASK 3] Update the shared folder access"
chmod -R 777 /"${nfs_volume_name}"

echo "[TASK 4] Make the kubedata directory available on the network"
cat >>/etc/exports<<EOF
/${nfs_volume_name}   *(rw,sync,no_subtree_check,no_root_squash)
EOF

echo "[TASK 5] Export the updates"
sudo exportfs -rav

echo "[TASK 6] Enable NFS Server"
sudo systemctl enable nfs-server

echo "[TASK 7] Start NFS Server"
sudo systemctl start nfs-server
