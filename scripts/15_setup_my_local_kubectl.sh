#!/bin/bash

cd dist

export LOAD_BALANCER="$(python ../ec2_inventory.py --host_type LoadBalancer --attributes public_dns)"

kubectl config set-cluster ${CLUSTER_NAME} \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://${LOAD_BALANCER}:6443

kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem

kubectl config set-context ${CLUSTER_NAME} \
  --cluster=${CLUSTER_NAME} \
  --user=admin

kubectl config use-context ${CLUSTER_NAME}

if ! openssl x509 -in kubernetes.pem -text -noout | grep -e "IP\|DNS"; then
  echo ERROR: Missing hosts from kubernetes.pem
fi

