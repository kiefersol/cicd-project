#!/usr/bin/env bash

if [ "${KUBECONFIG}" == "" ]; then
  echo "KUBECONFIG is required."
  exit 1;
fi
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $BASEDIR
pushd istio-1.14.0

export PATH=$PWD/bin:$PATH

istioctl install -y --set values.global.hub=docker.io/istio --set values.global.imagePullPolicy=IfNotPresent --set values.pilot.env.PILOT_HTTP10=1 --set profile=sol_nodeport --manifests manifests 

popd

### support http1.0 : --set values.pilot.env.PILOT_HTTP10=1 
### debugging : --set meshConfig.accessLogFile=/dev/stdout

