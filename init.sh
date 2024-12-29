#!/bin/bash

# Update and install required packages
# CentOS에서 사용 가능한 모든 패키지를 업데이트
# CentOS에 추가적인 패키지를 제공하는 EPEL(Extra Packages for Enterprise Linux)을 활성화
# 필요한 바이너리들 설치
# YUM 패키지 관리자가 사용하는 캐시 데이터를 정리
yum update -y && \
yum install -y epel-release && \
yum install -y gnupg2 python3-pip git openssh-clients vim bridge-utils iputils wget unzip curl && \
yum clean all

# Install sshpass
wget https://cbs.centos.org/kojifiles/packages/sshpass/1.06/8.el8/x86_64/sshpass-1.06-8.el8.x86_64.rpm
yum install -y ./sshpass-1.06-8.el8.x86_64.rpm
rm ./sshpass-1.06-8.el8.x86_64.rpm

# Upgrade pip and install Python packages
# python의 pip 모듈을 이용해서 pip 버전 업그레이드, cffi(C 코드와 Python 코드 간의 함수 호출을 가능하게 만들어, C 라이브러리를 Python에서 사용할 수 있도록 도움) 설치
# anisble 설치
# mitogen(ansible 속도향상) ansible-lint(문법오류 발견) jmespath(json 결과 쿼리) 설치
# ansible에서 Windows 원격 관리를 위한 Python 라이브러리 설치
# pip와 관련된 캐시 파일을 삭제
python3 -m pip install --upgrade pip==20.3.4 cffi && \
pip install ansible==2.9.24 && \
pip install mitogen ansible-lint jmespath && \
pip install --upgrade pywinrm && \
rm -rf /root/.cache/pip

# Install Terraform
wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/1.10.3/terraform_1.10.3_linux_amd64.zip" && \
unzip /terraform.zip -d /usr/local/bin && \
rm -f /terraform.zip

# python 경로 설정 
# .bashrc 설정 : Bash 쉘의 환경 설정 파일로, 사용자가 로그인할 때마다 Bash 셸이 시작될 때 자동으로 실행됩니다.
# 기본 로케일 C, UTF-8 인코딩을 사용하여 다국어 문자 처리에 문제가 없도록 한다.
ln -s /usr/bin/python3 /usr/bin/python && \
{
echo "alias k=kubectl"
echo "alias tf=terraform"
echo "export LC_ALL=C.UTF-8"
echo "export LANG=C.UTF-8"
} >> ~/.bashrc
source ~/.bashrc

# Export environment variables
# 시스템의 로케일을 C로 설정하여, 모든 시스템 출력 및 메시지가 영어로 표시되도록 합니다.
# 이는 디버깅, 영어 환경 설정 및 일관된 출력을 유지하려는 경우에 유용
export LC_ALL=C
