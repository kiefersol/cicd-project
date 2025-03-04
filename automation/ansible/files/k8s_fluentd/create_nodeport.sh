#!/usr/bin/env bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR

helm install -f ./elasticsearch/values.yaml sol-ela --namespace=kube-system ./elasticsearch

helm install -f ./kibana/values_nodeport.yaml sol-kib --namespace=kube-system ./kibana

kubectl apply -f $BASEDIR/fluentd/fluentd-configmap.yaml
kubectl apply -f $BASEDIR/fluentd/fluentd-rbac.yaml
kubectl apply -f $BASEDIR/fluentd/fluentd.yaml
