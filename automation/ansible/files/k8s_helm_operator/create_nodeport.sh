#!/usr/bin/env bash
set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
VALUES_DIR="${BASEDIR}/helm-operator/"
KUBE_DIR="${BASEDIR}/helm-operator/templates"
ROOT_CA_DIR="/ansible/files/ssl_cert/rootCA.pem"

echo "----------------------------${HARBOR_ID}"
echo "----------------------------${HARBOR_PW}"
echo "----------------------------${HARBOR_IP}"
echo "----------------------------${HARBOR_DOMAIN}"
echo "----------------------------${HARBOR_PORT}"

if [ "${HARBOR_ID}" == "" ]; then
  HARBOR_ID="admin"
fi
if [ "${HARBOR_PW}" == "" ]; then
  HARBOR_PW="password"
fi
if [ "${HARBOR_IP}" == "" ]; then
  HARBOR_IP="15.152.252.25"
fi
if [ "${HARBOR_DOMAIN}" == "" ]; then
  HARBOR_DOMAIN="registry.bxcp.lab"
fi
if [ "${HARBOR_PORT}" == "" ]; then
  HARBOR_PORT="5443"
fi

VALUES="values_nodeport.yaml"
NEW_VALUES="${VALUES_DIR}/values.yaml"

KUBE="kube.yaml"
NEW_KUBE="${KUBE_DIR}/${KUBE}"

cd $BASEDIR
cp ./${VALUES} ${NEW_VALUES}
cp ./${KUBE} ${NEW_KUBE}

sed -i "s|\[HARBOR_ID]|${HARBOR_ID}|g" ${NEW_VALUES}
sed -i "s|\[HARBOR_PW]|${HARBOR_PW}|g" ${NEW_VALUES}
sed -i "s|\[HARBOR_IP]|${HARBOR_IP}|g" ${NEW_VALUES}
sed -i "s|\[HARBOR_DOMAIN]|${HARBOR_DOMAIN}|g" ${NEW_VALUES}
sed -i "s|\[HARBOR_PORT]|${HARBOR_PORT}|g" ${NEW_VALUES}

ROOT_CA=$(cat $ROOT_CA_DIR | sed ':a;N;$!ba;s|\n|\\n    |g' | sed 's|/|\\/|g')
echo $ROOT_CA
sed -i "s|\[ROOT_CA]|${ROOT_CA}|g" ${NEW_KUBE}
helm upgrade -i helm-operator ./helm-operator -n flux -f helm-operator/values.yaml --set helm.versions=v3 --set image.tag=1.4.4 
