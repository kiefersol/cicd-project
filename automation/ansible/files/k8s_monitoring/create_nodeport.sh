#!/bin/bash
if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR

#grafana config파일에 json파일 업로드
cd $BASEDIR/json
kubectl create configmap istio-services-grafana-dashboards --namespace=istio-system  --from-file=./prometheus_node_exporter.json --from-file=./k8s_all_cluster_monitoring.json --from-file=./k8s_cluster_summary.json --from-file=./loki_kubernetes_logs.json --from-file=./cilium_agent_metrics.json --from-file=./hubble_metrics.json --from-file=./sol_namespace.json

kubectl apply -f $BASEDIR/yaml_nodeport/



