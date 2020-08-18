#!/bin/bash
master_ip=192.168.7.11
function create {
    if [[ -f "Vagrantfile" ]];then
        vagrant up
    else
        echo "Vagrantfile not found"
    fi
    
}

function destroy {
    if [[ -f "Vagrantfile" ]];then
        vagrant destroy -f
    else
        echo "Vagrantfile not found"
    fi
    
}

function stop {
    if [[ -f "Vagrantfile" ]];then
        vagrant halt -f
    else
        echo "Vagrantfile not found"
    fi
    
}

function status {
    if [[ -f "Vagrantfile" ]];then
        vagrant status
    else
        echo "Vagrantfile not found"
    fi
}
function config {
    sudo mkdir -p "${HOME}"/.kube
    current_dir=$(pwd)
    key_loc="${current_dir}"/.vagrant/machines/master-1/virtualbox/private_key
    scp -i "${key_loc}" vagrant@"${master_ip}":~/.kube/config "${HOME}"/admin.conf
    echo "Do you want overwrite "${HOME}"/.kube/config(y/n)"
    read -r response
    if [[ "$response" == "y" ]];then
        cat "${HOME}"/admin.conf > "${HOME}"/.kube/config
    else
        echo "admin.conf copied to "${HOME}"/.kube"
    fi
    
}

if [[ $1 == "config" ]];then
    config
    
    
    elif [[ $1 == "status" ]];then
    status
    
    
    elif [[ $1 == "stop" ]];then
    stop
    
    
    elif [[ $1 == "start" ]];then
    create
    
    
    elif [[ $1 == "create" ]];then
    create
    config
    
    elif [[ $1 == "destroy" ]];then
    destroy
    
else
    echo "Usages: <bash cluster.sh [start|stop|config|status|destroy"
fi