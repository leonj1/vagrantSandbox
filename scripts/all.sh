#!/bin/bash

set -e
unset KUBECONFIG

./1_gen_certificate_authority.sh
./2_gen_admin_client_certificate.sh
./3_gen_client_certs.sh
./4_kube_controller_manager.sh
./5_kube_proxy_client_certificate.sh
./6_kube_scheduler_client_certificate.sh
./7_kube_api_server_certificate.sh
./8_service_account_key_pair.sh
./9_kubeconfig_kubelet.sh
./9_kubeconfig_kubelet.sh
./10_kubeconfig_proxy.sh
./11_kubeconfig_controller_manager.sh
./12_kubeconfig_scheduler.sh
./13_kubeconfig_admin.sh
./14_gen_encryption_config.sh
./15_setup_my_local_kubectl.sh

