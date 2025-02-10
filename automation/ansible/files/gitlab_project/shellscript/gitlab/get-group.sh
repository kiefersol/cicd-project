#!/usr/bin/env bash
# gitlab 환경에서 username 값으로 조회
set -x

GROUPNAME=$1

if [ "${GROUPNAME}" == "" ]; then
  echo "GROUPNAME(\$1) is required."
  exit 1;
fi

if [ "${GITLAB_TOKEN}" == "" ]; then
  echo "GITLAB_TOKEN is required."
  exit 1;
fi
if [ "${GITLAB_URL}" == "" ]; then
  echo "GITLAB_URL is required."
  exit 1;
fi

RESPONSE=$(curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" -H "Content-Type:application/json" https://${GITLAB_URL}/api/v4/groups?search=${GROUPNAME}&order_by=id)

# 리스트 형태의 json 응답에서 [] 및 {} 괄호를 제거하고 첫번째 항목 선택
ID_FIELD=$(echo $RESPONSE | cut -c 3- | rev | cut -c 3- | rev | cut -d "," -f 1)
echo "${ID_FIELD/\"id\"\:/''}"
