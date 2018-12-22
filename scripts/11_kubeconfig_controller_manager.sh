#!/bin/bash

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}

cp kube-controller-manager.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kube-control-plane/files/kube-controller-manager.kubeconfig
cp kube-controller-manager.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kube-controller-certs/files/kube-controller-manager.kubeconfig
cp kube-controller-manager.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files

