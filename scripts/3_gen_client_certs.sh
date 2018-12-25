#!/bin/bash

cd dist
rm -f ec2*.amazonaws.com*
python ../ec2_inventory.py --request kubelet_client_certificates > .3lines.txt
#for x in `cat .lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files; done

