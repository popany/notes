#!/bin/bash

set -e

if [[ -z "$1" ]]; then
    echo "must set remote_ip"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "must set ssh_port"
    exit 1
fi

if [[ -z "$3" ]]; then
    echo "must set user_name"
    exit 1
fi

if [[ -z "$4" ]]; then
    echo "must set password"
    exit 1
fi

remote_ip=$1
ssh_port=$2
user_name=$3
password=$4

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 groupadd ${user_name}

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 useradd ${user_name} -s /bin/bash -m -g ${user_name} -G sudo

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 chpasswd <<END
foo:${password}
END

scp -i ~/.ssh/id_ed25519 -P 22 ~/.ssh/id_ed25519.pub root@${remote_ip}:
ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 "mkdir /home/${user_name}/.ssh"
ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 "cat id_ed25519.pub > /home/${user_name}/.ssh/authorized_keys"
ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 "chown -R ${user_name}:${user_name} /home/${user_name}/.ssh"
ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 'rm id_ed25519.pub'

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 'sed -i -f - /etc/ssh/sshd_config' <<'SED_END'
s/^PasswordAuthentication yes/PasswordAuthentication no/
SED_END

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 'sed -i -f - /etc/ssh/sshd_config' <<'SED_END'
s/^PermitRootLogin yes/PermitRootLogin no/
SED_END

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 'sed -i -f - /etc/ssh/sshd_config' <<SED_END
s/^#Port 22/Port ${ssh_port}/
SED_END

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 ufw allow ${ssh_port}/tcp

ssh root@${remote_ip} -i ~/.ssh/id_ed25519 -p 22 -t systemctl restart sshd


