#!/usr/bin/env bash
DOMAIN_NAME=dev-host-infra-lb-05f7fb7aaac378fc.elb.ap-northeast-2.amazonaws.com:8443

echo ${DOMAIN_NAME}
git config --global http.sslverify false
git config --global user.name "Administrator"
git config --global user.email "admin@bxk.com"

git init
git remote add origin https://bxcp:bxcp!gen3@${DOMAIN_NAME}/bookinfo/productpage.git
git add .
git commit -m "Initial commit"
git push -u origin master

git config credential.helper store --global

rm -rf .git