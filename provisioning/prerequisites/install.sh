#!/bin/bash
yum update -y
yum install -y wget curl conntrack-tools vim net-tools telnet tcpdump bind-utils socat ntp kmod ceph-common dos2unix
yum -y install epel-release
yum -y install figlet
yum install -y ipset
yum install -y ipvsadm

figlet MASTER

echo "[TASK 1] Add hosts to etc/hosts"
cat >>/etc/hosts<<EOF
35.203.136.221 k8s-master
34.82.74.209 k8s-worker-1
34.83.100.159 k8s-worker-2
EOF

echo "[TASK 2] Disable SELINUX"
sed -i -e s/enforcing/disabled/g /etc/sysconfig/selinux
sed -i -e s/permissive/disabled/g /etc/sysconfig/selinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "[TASK 3] Disable Firewall"
systemctl disable firewalld
systemctl stop firewalld

echo "[TASK 4] Update iptables"
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "[TASK 5] Disable Swap"
swapoff -a && sed -i '/swap/d' /etc/fstab

echo "[TASK 6] Install Docker"
yum install -y yum-utils nfs-utils device-mapper-persistent-data lvm2
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum install -y docker-ce-18.06.1.ce-3.el7

echo "[TASK 7] Add Kubernetes Repositories"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "[TASK 8] Install kubelet/kubeadm/kubectl"
#yum install -y kubelet kubeadm kubectl
yum list --showduplicates kubeadm --disableexcludes=kubernetes
#yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
yum install -y kubeadm-1.15.0 --disableexcludes=kubernetes
yum install -y kubelet-1.15.0 kubectl-1.15.0 --disableexcludes=kubernetes

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
