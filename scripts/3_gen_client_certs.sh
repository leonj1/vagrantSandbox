#!/bin/bash

python ec2_inventory.py --request kubelet_client_certificates > .lines.txt
for x in `cat .lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kube-worker-certs/files; done
for x in `cat .lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kube-worker-host-certs/files; done
for x in `cat .lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files; done

