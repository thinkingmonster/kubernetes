#!/bin/bash
echo '#!/bin/bash' > /vagrant/centos/node-bootstrap.sh
kubeadm token create $(kubeadm token generate) --print-join-command --ttl=0 >> /vagrant/centos/node-bootstrap.sh
chmod 777 /vagrant/centos/node-bootstrap.sh
