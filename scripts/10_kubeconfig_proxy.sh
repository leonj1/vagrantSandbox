#!/bin/bash

cd dist
python ../ec2_inventory.py --request kubeconfig_for_loadbalancer > ./.10lines.txt

