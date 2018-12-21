#!/bin/bash

#IFS=$'\n'
#for x in `(cd /home/jose/workarea/deployer/provisioning && SERVICE=kube-workers PEM=foo IDENTITY=Worker /home/jose/workarea/deployer/provisioning/inventory/ec2_inventory.sh --list) | jq -r '._meta.hostvars | to_entries | map(.value)[] | .public_dns + "\t" + .private_ip'`; do (unset IFS; ./.3_gen_kubelet_client_certificates.sh $x); done
#unset IFS

#python ec2_inventory.py --host_type Worker --attributes public_dns,private_ip > .lines.txt
#for x in `cat .lines.txt`
#do 
#  IFS=', ' read -r -a array <<< "$x"
#  ./.3_gen_kubelet_client_certificates.sh ${array[0]} ${array[1]}
#done

python ec2_inventory.py --request kubelet_client_certificates > .lines.txt
for x in `cat .lines.txt`; do cp $x /home/jose/workarea/deployer/provisioning/roles/kube-worker-certs/files; done

