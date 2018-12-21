#!/bin/bash

## selecting private ip address of load balancer (worker2 in my case)
#export KUBERNETES_ADDRESS=10.1.0.118
#
## public DNS hostnames for workers
#for instance in ec2-3-82-112-51.compute-1.amazonaws.com ec2-54-166-223-187.compute-1.amazonaws.com ec2-54-172-28-230.compute-1.amazonaws.com; do
#  kubectl config set-cluster kubernetes-the-hard-way \
#    --certificate-authority=ca.pem \
#    --embed-certs=true \
#    --server=https://${KUBERNETES_ADDRESS}:6443 \
#    --kubeconfig=${instance}.kubeconfig
#
#  kubectl config set-credentials system:node:${instance} \
#    --client-certificate=${instance}.pem \
#    --client-key=${instance}-key.pem \
#    --embed-certs=true \
#    --kubeconfig=${instance}.kubeconfig
#
#  kubectl config set-context default \
#    --cluster=kubernetes-the-hard-way \
#    --user=system:node:${instance} \
#    --kubeconfig=${instance}.kubeconfig
#
#  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
#done

python ec2_inventory.py --request kubelet_kubeconfig_per_host > ./lines.txt
for x in `cat ./lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kube-worker-certs/files/; done

