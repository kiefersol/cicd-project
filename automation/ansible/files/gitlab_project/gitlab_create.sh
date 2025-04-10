#!/bin/bash
export GITLAB_URL=cicd-dev-infra-lb-4499acd5161accc0.elb.ap-northeast-2.amazonaws.com:8443
export FW_NAMESPACE="sol"

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo $BASEDIR

cd ${BASEDIR}/shellscript/gitlab

if [ $(curl --connect-timeout 600 -k -I "https://cicd-dev-infra-lb-4499acd5161accc0.elb.ap-northeast-2.amazonaws.com:8443" 2>/dev/null | head -n 1 | cut -d$' ' -f2) -eq "302" ];
then  
  personal_access_token=$(./token --username 'sol' --password 'solsol1234!' --base-url https://${GITLAB_URL}) 
  GITLAB_TOKEN_DIR="${BASEDIR}/shellscript/generated/tokens"
  GITLAB_TOKEN_FILE="${GITLAB_TOKEN_DIR}/gitlab_token"
  echo "export GITLAB_TOKEN=\"${personal_access_token}\"" > ${GITLAB_TOKEN_FILE}
  cat ${GITLAB_TOKEN_FILE}
  source ../generated/tokens/gitlab_token
  ./create-group.sh bookinfo
  ./create-group.sh bookinfo-k8s
else
  echo gitlab is not working
  exit 1
fi