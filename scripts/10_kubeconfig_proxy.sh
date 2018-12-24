#!/bin/bash

python ec2_inventory.py --request kubeconfig_for_loadbalancer > ./lines.txt
for x in `cat ./lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/; done

