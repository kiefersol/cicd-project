#!/usr/bin/env bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR

helm delete bxcp-ela --namespace=kube-system
helm delete bxcp-elc --namespace=kube-system
helm delete bxcp-kib --namespace=kube-system

kubectl delete -f ./fluentd/fluentd-configmap.yaml
kubectl delete -f ./fluentd/fluentd-rbac.yaml
kubectl delete -f ./fluentd/fluentd.yaml
