#!/bin/bash
terraform output -raw public_ip > public_ip.txt
PUBLIC_IP=$(cat public_ip.txt)

cat <<EOF > inventory.ini
[web]
$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=.ssh/kops-key.pem
EOF
