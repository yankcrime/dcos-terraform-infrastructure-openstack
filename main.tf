locals {
  ssh_public_key_file = "${var.ssh_public_key_file == "" ? format("%s/main.tf", path.module) : var.ssh_public_key_file}"
  ssh_key_content     = "${var.ssh_public_key_file == "" ? var.ssh_public_key : file(local.ssh_public_key_file)}"
}

resource "openstack_compute_keypair_v2" "deployer" {
  name       = "${var.cluster_name}-deployer-key"
  public_key = "${local.ssh_key_content}"
}

module "dcos-security-groups" {
  source = "./modules/security-groups"
}

module "dcos-network" {
  source = "./modules/network"

  cluster_name        = "${var.cluster_name}"
  external_network_id = "${var.external_network_id}"
}

module "dcos-bootstrap-instance" {
  source = "./modules/bootstrap"

  network_id                  = "${module.dcos-network.network_id}"
  cluster_name                = "${var.cluster_name}"
  floating_ip_pool            = "${var.floating_ip_pool}"
  key_pair                    = "${var.cluster_name}-deployer-key"
  associate_public_ip_address = true
}

module "dcos-master-instances" {
  source = "./modules/masters"

  network_id   = "${module.dcos-network.network_id}"
  cluster_name = "${var.cluster_name}"
  num_masters  = "${var.num_masters}"
  key_pair     = "${var.cluster_name}-deployer-key"
}

module "dcos-public-agent-instances" {
  source = "./modules/public-agents"

  network_id                  = "${module.dcos-network.network_id}"
  cluster_name                = "${var.cluster_name}"
  associate_public_ip_address = true
  floating_ip_pool            = "internet"
  num_public_agents           = "${var.num_public_agents}"
  key_pair                    = "${var.cluster_name}-deployer-key"
}

module "dcos-private-agent-instances" {
  source = "./modules/private-agents"

  network_id         = "${module.dcos-network.network_id}"
  cluster_name       = "${var.cluster_name}"
  num_private_agents = "${var.num_private_agents}"
  key_pair           = "${var.cluster_name}-deployer-key"
}

module "dcos-lb" {
  source = "./modules/lb-dcos"

  num_masters                        = "${var.num_masters}"
  num_public_agents                  = "${var.num_public_agents}"
  dcos_public_agents_ip_addresses    = "${module.dcos-public-agent-instances.public_agents.private_ips}"
  dcos_masters_ip_addresses          = "${module.dcos-master-instances.private_ips}"
  masters_lb_security_group_id       = "${module.dcos-security-groups.master_lb}"
  public_agents_lb_security_group_id = "${module.dcos-security-groups.public_agents}"
  network_id                         = "${module.dcos-network.network_id}"
  subnet_id                          = "${module.dcos-network.subnet_id}"
}
