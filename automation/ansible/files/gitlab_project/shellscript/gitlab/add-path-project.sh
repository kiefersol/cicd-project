#!/usr/bin/env bash
# gitlab 환경에 사용자가 owner인 프로젝트 생성

set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

PROJECT_ID=$1
ADD_PATH=$2

if [ "${PROJECT_ID}" == "" ]; then
  echo "PROJECT_ID(\$1) is required."
  exit 1;
fi
if [ "${ADD_PATH}" == "" ]; then
  echo "ADD_PATH(\$2) is required."
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

ADD_PATH="${ADD_PATH}empty.txt"

# gitlab 처리용 결과물 따로 분리
mkdir -p ${GITLAB_DIR}

FILE_NAME="add-path-project.json"
JSON_FILE="${GITLAB_DIR}/${FILE_NAME}"

cp ${BASEDIR}/add-path-project.json ${JSON_FILE}

ENCODE_ADD_PATH=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${ADD_PATH}")

sed -i "s|\[GITLAB_PROJECT_ID]|${PROJECT_ID}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_ADD_PATH]|${ADD_PATH}|g" ${JSON_FILE}

pushd ${GITLAB_DIR}
  curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       -H "Content-Type:application/json" \
       -d @${FILE_NAME} \
       -X POST https://${GITLAB_URL}/api/v4/projects/${PROJECT_ID}/repository/commits
popd
