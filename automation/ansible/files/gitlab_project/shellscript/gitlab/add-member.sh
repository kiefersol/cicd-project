#!/usr/bin/env bash
# gitlab 그룹에 사용자 추가(권한은 Maintainer 고정)

set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

GROUP_ID=$1
USER_ID=$2

if [ "${GROUP_ID}" == "" ]; then
  echo "GROUP_ID(\$1) is required."
  exit 1;
fi
if [ "${USER_ID}" == "" ]; then
  echo "USER_ID(\$2) is required."
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

FILE_NAME="gitlab-add-member-${USER_ID}.json"
JSON_FILE="${GITLAB_DIR}/${FILE_NAME}"

cp ${BASEDIR}/request-member.json ${JSON_FILE}

sed -i "s|\[GITLAB_GROUP_ID]|${GROUP_ID}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_USER_ID]|${USER_ID}|g" ${JSON_FILE}

pushd ${GITLAB_DIR}
  curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       -H "Content-Type:application/json" \
       -d @${FILE_NAME} \
       -X POST https://${GITLAB_URL}/api/v4/groups/${GROUP_ID}/members
popd
