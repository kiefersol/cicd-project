#!/usr/bin/env bash
DOMAIN_NAME=cicd-dev-infra-lb-4499acd5161accc0.elb.ap-northeast-2.amazonaws.com:8443

echo ${DOMAIN_NAME}
git config --global http.sslverify false
git config --global user.name "Administrator"
git config --global user.email "admin@example.com"

git init
git remote add origin https://sol:solsol1234!@${DOMAIN_NAME}/bookinfo/details.git
git add .
git commit -m "Initial commit"
git push -u origin master

git config credential.helper store --global

rm -rf .git