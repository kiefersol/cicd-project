#!/usr/bin/env bash
# gitlab 서버에서 REST API 호출을 할 수 있는 토큰을 생성하여 파일에 저장

set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
GITLAB_DIR="${BASEDIR}/../generated/tokens"

USERNAME=$1
PASSWORD=$2

if [ "${USERNAME}" == "" ]; then
  USERNAME="root"
fi
if [ "${PASSWORD}" == "" ]; then
  PASSWORD="password"
fi

if [ "${GITLAB_URL}" == "" ]; then
  echo "GITLAB_URL is required."
  exit 1;
fi

# gitlab 처리용 결과물 따로 분리
mkdir -p ${GITLAB_DIR}/${USERNAME}

body_header=$(curl -k -c cookies.txt -i https://${GITLAB_URL}/users/sign_in -s)
trap "rm cookies.txt" EXIT

csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
curl -k -b cookies.txt -c cookies.txt -i https://${GITLAB_URL}/users/sign_in \
  --data "user[login]=${USERNAME}&user[password]=${PASSWORD}" \
  --data-urlencode "authenticity_token=${csrf_token}"

body_header=$(curl -k -H 'user-agent: curl' -b cookies.txt -i https://${GITLAB_URL}/profile/personal_access_tokens -s)
csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

body_header=$(curl -k -L -b cookies.txt https://${GITLAB_URL}/profile/personal_access_tokens \
  --data-urlencode "authenticity_token=${csrf_token}" \
  --data 'personal_access_token[name]=golab-generated&personal_access_token[expires_at]=&personal_access_token[scopes][]=api')

personal_access_token=$(echo $body_header | perl -ne 'print "$1\n" if /created-personal-access-token"[[:blank:]]value="(.+?)"/' | sed -n 1p)

GITLAB_TOKEN_FILE="${GITLAB_DIR}/${USERNAME}/gitlab_token"
echo "export GITLAB_TOKEN=\"${personal_access_token}\"" > ${GITLAB_TOKEN_FILE}

cat ${GITLAB_TOKEN_FILE}
