#!/bin/bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR

helm uninstall loki-distributed --namespace=istio-system 

helm uninstall promtail --namespace=istio-system 

kubectl delete -f ./loki-pvc.yaml