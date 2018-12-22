#!/bin/bash

## selecting private ip address of load balancer (worker2 in my case)
#export KUBERNETES_ADDRESS=10.1.0.118
#
#{
#  kubectl config set-cluster kubernetes-the-hard-way \
#    --certificate-authority=ca.pem \
#    --embed-certs=true \
#    --server=https://${KUBERNETES_ADDRESS}:6443 \
#    --kubeconfig=kube-proxy.kubeconfig
#
#  kubectl config set-credentials system:kube-proxy \
#    --client-certificate=kube-proxy.pem \
#    --client-key=kube-proxy-key.pem \
#    --embed-certs=true \
#    --kubeconfig=kube-proxy.kubeconfig
#
#  kubectl config set-context default \
#    --cluster=kubernetes-the-hard-way \
#    --user=system:kube-proxy \
#    --kubeconfig=kube-proxy.kubeconfig
#
#  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
#}

python ec2_inventory.py --request kubeconfig_for_loadbalancer > ./lines.txt
for x in `cat ./lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kube-worker-certs/files/; done
for x in `cat ./lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/; done

