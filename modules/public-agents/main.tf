/**
 * OpenStack DC/OS Public Agent Instances
 * ======================================
 * This module creates typical DC/OS public agent instances
 *
 */

module "dcos-master-instances" {
  source = "../../modules/instance"
  
  cluster_name                = "${var.cluster_name}"
  hostname_format             = "${var.hostname_format}"
  num                         = "${var.num_public_agents}"
  user_data                   = "${var.user_data}"
  image_name                  = "${var.image_name}"
  flavor_name                 = "${var.flavor_name}"
  network_id                  = "${var.network_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  floating_ip_pool            = "${var.floating_ip_pool}"

}

