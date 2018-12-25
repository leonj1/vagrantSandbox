#!/bin/bash

cd dist

cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
for x in `cat .3lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files; done
cp kubernetes.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/
cp kubernetes-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/
cp service-account.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp service-account-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
for x in `cat ./.9lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/; done
for x in `cat ./.10lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/; done
cp kube-controller-manager.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp kube-scheduler.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp admin.kubeconfig /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp encryption-config.yaml /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files

