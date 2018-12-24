#!/bin/bash

{

cat > ca-config.json << EOF
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

cat > ca-csr.json << EOF
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

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

}

#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kube-control-plane/files/ca.pem
#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kube-controller-certs/files/ca.pem
#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kube-worker-certs/files/ca.pem
#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/etcd/files/ca.pem
#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kube-worker-host-certs/files/ca.pem
#cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kube-controller-host-certs/files/ca.pem
#
#cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kube-control-plane/files/ca-key.pem
#cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kube-worker-host-certs/files/ca-key.pem
#cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kube-controller-host-certs/files/ca-key.pem

cp ca.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files
cp ca-key.pem /home/jose/workarea/deployer/provisioning/roles/kubernetes_shared_files

