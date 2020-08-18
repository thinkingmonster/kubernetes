#!/bin/bash
. /vagrant/centos/00-env.sh
kubeadm init --apiserver-advertise-address "${apiserver_advertise_address}" --pod-network-cidr "${pod_network_cidr}"/16



