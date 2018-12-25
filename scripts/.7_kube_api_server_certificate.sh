#!/bin/bash -x

cd dist

# 10.32.0.1 is an ip that some PODs may use to contact the api server
# then private ip address of controllers
# then public hostname of controllers
# then private ip address of load balancer and public hostname of load balancer
# then kube specific vars
CERT_HOSTNAME=$1

{

cat > kubernetes-csr.json << EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
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
  -hostname=${CERT_HOSTNAME} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

}

