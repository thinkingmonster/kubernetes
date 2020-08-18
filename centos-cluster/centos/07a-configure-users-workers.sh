#!/bin/bash
# Create ssh user for virtual machine
. /vagrant/centos/00-env.sh
useradd "${SSH_USER}"
echo "${SSH_USER}" | passwd "${SSH_USER}" --stdin
echo "${SSH_USER}	ALL=(ALL)	NOPASSWD: ALL" | sudo tee -a  /etc/sudoers > /dev/null


sudo yum -y install vim epel-release cowsay ruby
sudo gem install lolcat

echo "cowsay  Welcome ${SSH_USER}! I am Jarvis and looks like a Cow. How may i help you today? Play nice,do not blow the servers.|/usr/local/bin/lolcat" | sudo tee -a /home/akash/.bashrc > /dev/null

