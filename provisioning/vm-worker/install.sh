#!/bin/bash

figlet WORKER

echo "[TASK 1] Start docker/kubelet"
systemctl start docker && systemctl enable docker
systemctl start kubelet && systemctl enable kubelet
sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet

echo "[TASK 2] Join master"
#Update the join token by executing the command on master node
#echo kubeadm join $(kubeadm config view | grep ^controlPlaneEndpoint | awk '{print $2}') --token $(kubeadm token create) --discovery-token-ca-cert-hash sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

#kubeadm token create --print-join-command
kubeadm join !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
