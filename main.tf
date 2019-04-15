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
  associate_public_ip_address = true
  floating_ip_pool            = "${var.floating_ip_pool}"
}

module "dcos-master-instances" {
  source = "./modules/masters"

  network_id   = "${module.dcos-network.network_id}"
  cluster_name = "${var.cluster_name}"
  num_masters  = "${var.num_masters}"
}

module "dcos-public-agent-instances" {
  source = "./modules/public-agents"

  network_id                  = "${module.dcos-network.network_id}"
  cluster_name                = "${var.cluster_name}"
  associate_public_ip_address = true
  floating_ip_pool            = "internet"
  num_public_agents           = "${var.num_public_agents}"
}

module "dcos-private-agent-instances" {
  source = "./modules/private-agents"

  network_id         = "${module.dcos-network.network_id}"
  cluster_name       = "${var.cluster_name}"
  num_private_agents = "${var.num_private_agents}"
}

module "dcos-lb-masters" {
  source = "./modules/lb-masters"

  dcos_masters_ip_addresses = "${module.dcos-master-instances.private_ips}"
  network_id                = "${module.dcos-network.network_id}"
  subnet_id                 = "${module.dcos-network.subnet_id}"
  security_group_id         = ["${module.dcos-security-groups.security_group_id}"]
  num_masters               = "${var.num_masters}"
}

module "dcos-lb-public-agents" {
  source = "./modules/lb-public-agents"

  dcos_public_agents_ip_addresses = "${module.dcos-public-agent-instances.public_agents.private_ips}"
  network_id                      = "${module.dcos-network.network_id}"
  subnet_id                       = "${module.dcos-network.subnet_id}"
  security_group_id               = ["${module.dcos-security-groups.security_group_id}"]
  num_public_agents               = "${var.num_public_agents}"
}

module "dcos-lb-masters-internal" {
  source = "./modules/lb-masters-internal"

  dcos_masters_ip_addresses = "${module.dcos-master-instances.private_ips}"
  network_id                = "${module.dcos-network.network_id}"
  subnet_id                 = "${module.dcos-network.subnet_id}"
  security_group_id         = ["${module.dcos-security-groups.security_group_id}"]
  num_masters               = "${var.num_masters}"
}
