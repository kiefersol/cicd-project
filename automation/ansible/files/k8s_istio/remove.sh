#!/usr/bin/env bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

cd ./istio-1.14.0

export PATH=$PWD/bin:$PATH

istioctl x uninstall --purge

# kubectl delete namespace istio-system

