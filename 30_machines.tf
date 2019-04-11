#module "dcos-instance" {
#  source          = "./modules/instance"
#  image_name      = "CentOS 7.6"
#  flavor_name     = "saveloy"
#  key_pair        = "deadline"
#  security_groups = ["dcos"]
#  network_id      = "${openstack_networking_network_v2.private.id}"
#  num_instances = "1"
#  cluster_name = "testing"
#}

module "dcos-security-groups" {
  source = "./modules/security-groups"
}

module "dcos-network" {
  cluster_name = "testing"
  source = "./modules/network"
  external_network_id = "c72d2f60-9497-48b6-ab4d-005995aa4b21"
}

module "dcos-bootstrap-instance" {
  source = "./modules/bootstrap"
  network_id = "${module.dcos-network.network_id}"
  cluster_name = "testing"
  associate_public_ip_address = true
  floating_ip_pool = "internet"
}

module "dcos-master-instances" {
  source = "./modules/masters"
  network_id = "${module.dcos-network.network_id}"
  cluster_name = "testing"
  num_masters = "1"
}

module "dcos-public-agent-instances" {
  source = "./modules/public-agents"
  network_id = "${module.dcos-network.network_id}"
  cluster_name = "testing"
  associate_public_ip_address = true
  floating_ip_pool = "internet"
  num_public_agents = "2"
}

module "dcos-private-agent-instances" {
  source = "./modules/private-agents"
  network_id = "${module.dcos-network.network_id}"
  cluster_name = "testing"
  num_private_agents = "5"
}

module "dcos-lb-masters" {
  dcos_masters_ip_addresses = "${module.dcos-master-instances.private_ips}"
  network_id = "${module.dcos-network.network_id}"
  subnet_id = "${module.dcos-network.subnet_id}"
  security_group_id = ["${module.dcos-security-groups.security_group_id}"]
  source = "./modules/lb-masters"
}
  
