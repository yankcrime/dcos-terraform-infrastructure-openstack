#!/usr/bin/env bash
PACKAGES="git gcc make python-virtualenv tmux wget vim xz unzip ipset ntpdate"
sudo yum -y update
sudo yum -y install $PACKAGES

sudo ntpdate -s ntp.cis.strath.ac.uk

cat > ~/.ssh/config << EOF
Host *
  UserKnownHostsFile=/dev/null
  StrictHostKeyChecking=no
EOF
chmod go-rw ~/.ssh/config

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# Docker installation
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod --append -G docker centos
sudo groupadd -r nogroup

# DC/OS common seed configuration
mkdir ~centos/genconf
cat > ~centos/genconf/ip-detect <<EOF
#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
EOF
chmod +x ~centos/genconf/ip-detect

if [ $(hostname -s) = "bootstrap" ]; then
   cat > ~centos/genconf/config.yaml <<EOF
bootstrap_url: http://10.0.0.5:80
cluster_name: njones
exhibitor_storage_backend: static
master_discovery: static
ip_detect_public_filename: ./genconf/ip-detect
enable_ipv6: false
master_list:
- 10.0.0.100
resolvers:
- 1.1.1.1
- 1.1.0.0
use_proxy: false
EOF
   virtualenv ~centos/venvs/ansible
   source ~centos/venvs/ansible/bin/activate
   pip install -U pip
   pip install ansible
   git clone git@github.com:yankcrime/dcos-ansible.git ~centos/dcos-ansible
   cd ~centos/dcos-ansible
   git checkout param_ip_detect
   cat ~centos/dcos-ansible/inventory <<EOF
[bootstraps]
bootstrap

[masters]
master0

[agents_private]
private0
private1
private2
private3

[agents_public]
public0

[bootstraps:vars]
node_type=bootstrap

[masters:vars]
node_type=master
dcos_legacy_node_type_name=master

[agents_private:vars]
node_type=agent
dcos_legacy_node_type_name=slave

[agents_public:vars]
node_type=agent_public
dcos_legacy_node_type_name=slave_public

[agents:children]
agents_private
agents_public

[common:children]
bootstraps
masters
agents
agents_public
EOF
   cat ~centos/dcos-ansible/group_vars/all/dcos.yaml <<EOF
---
dcos:
  download: "https://downloads.dcos.io/dcos/stable/1.12.2/dcos_generate_config.sh"
  version: "1.12.2"
  # image_commit: "acc9fe548aea5b1b5b5858a4b9d2c96e07eeb9de"
  enterprise_dcos: false

  selinux_mode: permissive

  config:
    # This is a direct yaml representation of the DC/OS config.yaml
    # Please see https://docs.mesosphere.com/1.12/installing/production/advanced-configuration/configuration-reference/
    # for parameter reference.
    cluster_name: "sausages"
    bootstrap_url: http://bootstrap:8080
    exhibitor_storage_backend: static
    master_discovery: static
    master_list:
      - 10.0.0.100
    resolvers:
      - 1.1.1.1
      - 1.1.0.0
EOF
   # Download the DC/OS installer
   # curl -s -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh
fi

