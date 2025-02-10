MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
username=sol
password='solsol1234!'
adduser $username
chpasswd <<<"$username:$password"
echo "sol    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
mkdir ~/.ssh /home/sol/.ssh
chown sol:sol /home/sol/.ssh
chmod 600 ~/.ssh /home/sol/.ssh

mkdir -p /etc/containerd/certs.d/registry.sol.lab:5443
touch /etc/containerd/certs.d/registry.sol.lab:5443/ca.crt
echo "${file("/home/sol/cicd-project/automation/ansible/files/ssl_cert/rootCA.pem")}" >> /etc/containerd/certs.d/registry.sol.lab:5443/ca.crt

echo "${infra_ip} registry.sol.lab" >> /etc/hosts
echo "${infra_ip} gitlab.sol.lab" >> /etc/hosts

echo "${file("~/.ssh/id_rsa.pub")}" >> ~/.ssh/authorized_keys
echo "${file("~/.ssh/id_rsa.pub")}" >> /home/sol/.ssh/authorized_keys
chown sol:sol /home/sol/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys /home/sol/.ssh/authorized_keys

sudo yum install -y python3

sudo mkdir -p /etc/containerd/config.d/

touch /etc/containerd/config.d/registry.toml
cat >/etc/containerd/config.d/registry.toml <<EOF
[plugins]
[plugins."io.containerd.grpc.v1.cri".registry]
[plugins."io.containerd.grpc.v1.cri".registry.configs]
[plugins."io.containerd.grpc.v1.cri".registry.configs."registry.sol.lab:5443".tls]
insecure_skip_verify = true
EOF

sudo timedatectl set-timezone Asia/Seoul
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service sshd restart
systemctl restart sshd.service


--==MYBOUNDARY==--