#!/bin/bash

if [ -f ./dist/ca.pem ]; then
    echo "Certificate Authority already exists."
    exit 0
fi

{

cat > ./dist/ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ./dist/ca-csr.json << EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF

cd dist
cfssl gencert -initca ./ca-csr.json | cfssljson -bare ca

}

#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
#cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files

