#!/usr/bin/env bash
set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

GROUP_NAME=$1

if [ "${GROUP_NAME}" == "" ]; then
  echo "GROUP_NAME(\$1) is required."
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

FILE_NAME="gitlab-group-${GROUP_NAME}.json"
JSON_FILE="${GITLAB_DIR}/${FILE_NAME}"

cp ${BASEDIR}/group.json ${JSON_FILE}

sed -i "s|\[GITLAB_GROUP_NAME]|${GROUP_NAME}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_GROUP_PATH]|${GROUP_NAME}|g" ${JSON_FILE}

pushd ${GITLAB_DIR}
  curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       -H "Content-Type:application/json" \
       -d @${FILE_NAME} \
       -X POST https://${GITLAB_URL}/api/v4/groups
popd
