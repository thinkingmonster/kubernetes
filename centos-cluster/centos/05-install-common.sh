#!/bin/bash
. /vagrant/centos/00-env.sh
#DOCKER RUN TIME INSTALLATION
#!/bin/bash
# (Install Docker CE)
## Set up the repository
### Install required packages
yum install -y yum-utils device-mapper-persistent-data lvm2
## Add the Docker repository
yum-config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker CE
yum update -y && yum install -y \
containerd.io-"${containerd_version}" \
docker-ce-"${docker_version}" \
docker-ce-cli-"${docker_cli_version}"

## Create /etc/docker
mkdir /etc/docker

# Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
# Restart Docker
systemctl daemon-reload
systemctl restart docker
systemctl enable docker.service


# KUBELET KUBEADM KUBECTL INSTALLATIONS
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum -y install vim epel-release cowsay ruby nfs-utils git

gem install lolcat



yum install -y kubelet kubeadm kubectl –disableexcludes=kubernetes
systemctl enable --now kubelet