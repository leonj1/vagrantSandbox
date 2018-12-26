#!/bin/bash

python ec2_inventory.py --host_type $1 --attributes public_dns,private_ip

