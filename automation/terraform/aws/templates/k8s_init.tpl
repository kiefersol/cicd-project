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
chmod 700 ~/.ssh /home/sol/.ssh
echo "${file("~/.ssh/id_rsa.pub")}" >> ~/.ssh/authorized_keys
echo "${file("~/.ssh/id_rsa.pub")}" >> /home/sol/.ssh/authorized_keys
chown sol:sol /home/sol/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys /home/sol/.ssh/authorized_keys

sudo mount /dev/nvme1n1 /app
echo "${infra_ip} registry.sol.lab" >> /etc/hosts
echo "${infra_ip} gitlab.sol.lab" >> /etc/hosts
echo "${infra_ip} artifactory.sol.lab" >> /etc/hosts

sudo yum install -y python3
sudo timedatectl set-timezone Asia/Seoul
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service sshd restart

--==MYBOUNDARY==--