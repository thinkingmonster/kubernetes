#!/bin/bash
# Create ssh user for virtual machine
. /vagrant/centos/00-env.sh
useradd "${SSH_USER}"
echo "${SSH_USER}" | passwd "${SSH_USER}" --stdin

# add kube config to vagrat user home
HOME=/home/vagrant
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

# add ssh user
HOME=/home/"${SSH_USER}"
mkdir -p /home/"${SSH_USER}"/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/"${SSH_USER}"/.kube/config
sudo chown "${SSH_USER}":"${SSH_USER}" /home/"${SSH_USER}"/.kube/config
echo "${SSH_USER}	ALL=(ALL)	NOPASSWD: ALL" | sudo tee -a  /etc/sudoers > /dev/null

# add root
USER=root
HOME=/root
mkdir -p "${HOME}"/.kube
sudo cp -i /etc/kubernetes/admin.conf "${HOME}"/.kube/config
sudo chown "${USER}":"${USER}" "${HOME}"/.kube/config

sudo yum -y install vim epel-release cowsay ruby
sudo gem install lolcat

echo "cowsay  Welcome ${SSH_USER}! I am Jarvis and looks like a Cow. How may i help you today? Play nice,do not blow the servers.|/usr/local/bin/lolcat" | tee -a  /home/akash/.bashrc > /dev/null