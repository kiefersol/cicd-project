#!/usr/bin/env bash
set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VALUES_DIR="${BASEDIR}/cilium/"

echo "----------------------------${CILIUM_PODCIDR}"
echo "----------------------------${CILIUM_SUBNETMASK}"
echo "----------------------------${CILIUM_P8S_ENABLE}"
echo "----------------------------${CILIUM_OPERATOR_P8S_ENABLE}"
echo "----------------------------${HUBBLE_ENABLE}"
echo "----------------------------${HUBBLE_OPEN_METRICS_ENABLE}"
echo "----------------------------${HUBBLE_RELAY_ENABLE}"
echo "----------------------------${HUBBLE_UI_ENABLE}"
echo "----------------------------${HUBBLE_UI_SVC_TYPE}"

if [ "${CILIUM_PODCIDR}" == "" ]; then
  CILIUM_PODCIDR="20.0.0.0/10"
fi
if [ "${CILIUM_SUBNETMASK}" == "" ]; then
  CILIUM_SUBNETMASK="24"
fi
if [ "${CILIUM_P8S_ENABLE}" == "" ]; then
  CILIUM_P8S_ENABLE="true"
fi
if [ "${CILIUM_OPERATOR_P8S_ENABLE}" == "" ]; then
  CILIUM_OPERATOR_P8S_ENABLE="true"
fi
if [ "${HUBBLE_ENABLE}" == "" ]; then
  HUBBLE_ENABLE="true"
fi
if [ "${HUBBLE_OPEN_METRICS_ENABLE}" == "" ]; then
  HUBBLE_OPEN_METRICS_ENABLE="true"
fi
if [ "${HUBBLE_RELAY_ENABLE}" == "" ]; then
  HUBBLE_RELAY_ENABLE="true"
fi
if [ "${HUBBLE_UI_ENABLE}" == "" ]; then
  HUBBLE_UI_ENABLE="true"
fi
if [ "${HUBBLE_UI_SVC_TYPE}" == "" ]; then
  HUBBLE_UI_SVC_TYPE="NodePort"
fi

VALUES="values_template.yaml"
NEW_VALUES="${VALUES_DIR}/cilium_values.yaml"

cd $BASEDIR
cp ./${VALUES} ${NEW_VALUES}

sed -i "s|\[CILIUM_PODCIDR]|${CILIUM_PODCIDR}|g" ${NEW_VALUES}
sed -i "s|\[CILIUM_SUBNETMASK]|${CILIUM_SUBNETMASK}|g" ${NEW_VALUES}
sed -i "s|\[CILIUM_P8S_ENABLE]|${CILIUM_P8S_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[CILIUM_OPERATOR_P8S_ENABLE]|${CILIUM_OPERATOR_P8S_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[HUBBLE_ENABLE]|${HUBBLE_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[HUBBLE_OPEN_METRICS_ENABLE]|${HUBBLE_OPEN_METRICS_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[HUBBLE_RELAY_ENABLE]|${HUBBLE_RELAY_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[HUBBLE_UI_ENABLE]|${HUBBLE_UI_ENABLE}|g" ${NEW_VALUES}
sed -i "s|\[HUBBLE_UI_SVC_TYPE]|${HUBBLE_UI_SVC_TYPE}|g" ${NEW_VALUES}

helm upgrade -i cilium ./cilium -n kube-system -f ${NEW_VALUES}  --set image.tag=v1.14.2 