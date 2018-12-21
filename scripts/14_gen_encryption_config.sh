#!/bin/bash

# this is to support encrypting secrets at rest
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml << EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

cp encryption-config.yaml /home/jose/workarea/deployer/provisioning/roles/kube-control-plane/files/encryption-config.yaml
cp encryption-config.yaml /home/jose/workarea/deployer/provisioning/roles/kube-controller-certs/files/encryption-config.yaml

