#!/bin/bash
terraform refresh >/dev/null

PUBLIC_IP=$(terraform output -raw public_ip)

cat <<EOF > inventory.ini
[web]
$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/kops-key.pem
EOF
