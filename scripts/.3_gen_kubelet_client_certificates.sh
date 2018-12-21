#!/bin/bash -x

# worker host should be the hostname for the workers
WORKER_HOST=$1
WORKER_IP=$2

{
cat > ${WORKER_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER_HOST}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${WORKER_IP},${WORKER_HOST} \
  -profile=kubernetes \
  ${WORKER_HOST}-csr.json | cfssljson -bare ${WORKER_HOST}
}

