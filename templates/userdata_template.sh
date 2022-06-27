#!/bin/bash

export PATH=/bin:/usr/bin:$${PATH}

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent

# Install Ansible dependencies.
yum install -y unzip python-pip
pip install boto3

if [ ! -e /usr/bin/ansible ]; then
    yum -y install ansible
fi

if [[ ! -d "/var/log/ansible" ]]; then
    mkdir -p "/var/log/ansible"
fi

if [[ ! -d "/etc/ansible" ]]; then
    mkdir -p "/etc/ansible"
fi
    
cat << EOF > /etc/ansible/ansible.cfg
[defaults]
log_path = /var/log/ansible/localhost.log
EOF
