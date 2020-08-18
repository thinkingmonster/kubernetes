#!/bin/bash
swapoff -a
sed -i '/centos-swap/d' /etc/fstab