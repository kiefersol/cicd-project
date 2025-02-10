#!/usr/bin/env bash
# gitlab 환경에 사용자가 owner인 프로젝트 생성

set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

USER_ID=$1
PROJECT_NAME=$2
GROUP_ID=$3

if [ "${USER_ID}" == "" ]; then
  echo "USER_ID(\$1) is required."
  exit 1;
fi
if [ "${PROJECT_NAME}" == "" ]; then
  echo "PROJECT_NAME(\$2) is required."
  exit 1;
fi

if [ "${FW_NAMESPACE}" == "" ]; then
  echo "FW_NAMESPACE is required."
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

GITLAB_DIR="${BASEDIR}/../generated/jsons/${FW_NAMESPACE}"

# gitlab 처리용 결과물 따로 분리
mkdir -p ${GITLAB_DIR}

FILE_NAME="gitlab-project-${PROJECT_NAME}-${USER_ID}.json"
JSON_FILE="${GITLAB_DIR}/${FILE_NAME}"

if [ "${GROUP_ID}" == "" ]; then
  cp ${BASEDIR}/project-without-group.json ${JSON_FILE}
else
  cp ${BASEDIR}/project.json ${JSON_FILE}
fi

sed -i "s|\[GITLAB_PROJECT_NAME]|${PROJECT_NAME}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_USER_ID]|${USER_ID}|g" ${JSON_FILE}
if [ "${GROUP_ID}" != "" ]; then
  sed -i "s|\[GITLAB_GROUP_ID]|${GROUP_ID}|g" ${JSON_FILE}
fi

pushd ${GITLAB_DIR}
  curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       -H "Content-Type:application/json" \
       -d @${FILE_NAME} \
       -X POST https://${GITLAB_URL}/api/v4/projects/user/${USER_ID}
popd
