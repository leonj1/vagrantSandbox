#!/bin/bash

export VM_HOST=$1
vagrant ssh ${VM_HOST} -c "hostname -I | cut -d' ' -f1" 2>/dev/null

