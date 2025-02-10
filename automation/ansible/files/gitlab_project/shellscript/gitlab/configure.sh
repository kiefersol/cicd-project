#!/usr/bin/env bash
set -x
BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

ROOT_ID=$(${BASEDIR}/get-user.sh "root")

# 1. 프로젝트 생성(root 기반)
${BASEDIR}/create-project.sh ${ROOT_ID} "sol"

# 2. soluser 사용자 생성
${BASEDIR}/create-user.sh "soluser" "solsol1234!" "solsol@gamil.com"

# 3. sol 그룹 생성
${BASEDIR}/create-group.sh "sol"

BXCM_ID=$(${BASEDIR}/get-user.sh "soluser")

BXCM_GROUP_ID=$(${BASEDIR}/get-group.sh "sol")

# 4. soluser 사용자를 sol 그룹에 추가
${BASEDIR}/add-member.sh ${BXCM_GROUP_ID} ${BXCM_ID}

# 5. sol 그룹 하위에 bxframework-default-config 프로젝트 생성
${BASEDIR}/create-project.sh ${BXCM_ID} "sol-default-config" ${BXCM_GROUP_ID}

# 6. solproject 디렉토리 생성
${BASEDIR}/add-path-project.sh 43 "solproject/"
