#!/bin/bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR

kubectl apply -f ./loki-pvc.yaml

helm install -f ./loki-distributed/values.yaml loki-distributed --namespace=istio-system ./loki-distributed

helm install -f ./promtail/values.yaml promtail --namespace=istio-system ./promtail