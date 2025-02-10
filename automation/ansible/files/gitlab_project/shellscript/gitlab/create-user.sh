#!/usr/bin/env bash
# gitlab 환경에 사용자 추가

set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

USERNAME=$1
PASSWORD=$2
EMAIL=$3

if [ "${USERNAME}" == "" ]; then
  echo "USERNAME(\$1) is required."
  exit 1;
fi
if [ "${PASSWORD}" == "" ]; then
  echo "PASSWORD(\$2) is required."
  exit 1;
fi
if [ "${EMAIL}" == "" ]; then
  echo "EMAIL(\$3) is required."
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

FILE_NAME="gitlab-user-${USERNAME}.json"
JSON_FILE="${GITLAB_DIR}/${FILE_NAME}"

cp ${BASEDIR}/user.json ${JSON_FILE}

sed -i "s|\[GITLAB_USERNAME]|${USERNAME}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_PASSWORD]|${PASSWORD}|g" ${JSON_FILE}
sed -i "s|\[GITLAB_USER_EMAIL]|${EMAIL}|g" ${JSON_FILE}

pushd ${GITLAB_DIR}
  curl -k -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       -H "Content-Type:application/json" \
       -d @${FILE_NAME} \
       -X POST https://${GITLAB_URL}/api/v4/users
popd
