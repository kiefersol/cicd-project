!/bin/bash

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

# ssh key 생성 - pub, pri key
# -b 2048 : 키 길이를 비트 단위로 지정하는 옵션 
# -t rsa : 생성할 키의 타입을 지정. RSA(Rivest-Shamir-Adleman) 알고리즘을 사용
# -f ~/.ssh/id_rsa : 생성된 키 쌍의 파일 경로 및 이름을 지정 (비공개 키는 ~/.ssh/id_rsa에 저장되고, 공개 키는 ~/.ssh/id_rsa.pub에 저장)
# -q "Quiet mode"로, 명령 실행 중 진행 상태 메시지를 출력하지 않는다.
# -N '' : 빈 문자열('')은 비밀번호 없이 키를 생성
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''

USER="sol"
SUDOERS_FILE="/etc/sudoers.d/$USER"
# sudoers.d 파일 생성
echo "$USER ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
# 파일 권한 설정
chmod 0440 "$SUDOERS_FILE"

# cfssl 설치 - cert 만들기 위해
# CFSSL 바이너리 다운로드 및 바로 /usr/local/bin/에 이동
wget -qO /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget -qO /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

# 실행 권한 부여
chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson

# Kubernetes repository set up
echo "[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key" | sudo tee /etc/yum.repos.d/kubernetes.repo

# Yum clean all
sudo yum clean all

# Yum makecache
sudo yum makecache

# Kubernetes install (kubeadm, kubelet, kubectl) - YUM 사용
sudo yum install -y kubectl

# install argocd cli
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/v2.7.9/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/