MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash

sudo hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)

sudo yum install -y nfs-utils
sudo yum install -y python3
sudo timedatectl set-timezone Asia/Seoul

cat >/home/bx/worker.yaml <<EOF
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: "$(sshpass -p bxcp\!gen3 ssh -o StrictHostKeyChecking=no bx@${master_ip} "kubeadm token create")"
    apiServerEndpoint: "${k8s_lb}:6443"
    caCertHashes:
      - "sha256:$(sshpass -p bxcp\!gen3 ssh -o StrictHostKeyChecking=no bx@${master_ip} "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'")"
nodeRegistration:
  name: "$(uname -n)"
  kubeletExtraArgs:
    cloud-provider: external
EOF


sudo kubeadm join --config /home/bx/worker.yaml

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service sshd restart

--==MYBOUNDARY==--