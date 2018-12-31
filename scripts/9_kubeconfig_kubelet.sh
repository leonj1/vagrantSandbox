#!/bin/bash

cd dist

python ../ec2_inventory.py --request kubelet_kubeconfig_per_host > ./.9lines.txt

