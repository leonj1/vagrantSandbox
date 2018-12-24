#!/bin/bash

STRING=`python ec2_inventory.py --request api_server_certificate`
./.7_kube_api_server_certificate.sh ${STRING}

cp kubernetes.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/
cp kubernetes-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files/

