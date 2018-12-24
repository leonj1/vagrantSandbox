#!/bin/bash

python ec2_inventory.py --request kubelet_kubeconfig_per_host > ./lines.txt
for x in `cat ./lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/; done

