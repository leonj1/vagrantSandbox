#!/bin/bash

cd dist
STRING=`python ../ec2_inventory.py --request api_server_certificate`
../.7_kube_api_server_certificate.sh ${STRING}

