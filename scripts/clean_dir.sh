#!/bin/bash

cd dist
cp ca.pem ..
cp ca-key.pem ..
cp ca-config.json ..
cp ca-csr.json ..
rm -f *.csr *.json *.pem *.kubeconfig foo.sh *.yaml foo.sh .lines.txt lines.txt
mv ../ca.pem .
mv ../ca-key.pem .
mv ../ca-config.json .
mv ../ca-csr.json .

