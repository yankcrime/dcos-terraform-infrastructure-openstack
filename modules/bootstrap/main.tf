module "dcos-bootstrap-instance" {
  source = "../../modules/instance"
  
  cluster_name    = "${var.cluster_name}"
  hostname_format = "${var.hostname_format}"
  num             = "${var.num_bootstrap}"
  user_data       = "${var.user_data}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  network_id      = "${var.network_id}"

}

#resource "openstack_compute_instance_v2" "bootstrap" {
#  name            = "bootstrap"
#  image_name      = "CentOS 7.6"
#  flavor_name     = "saveloy"
#  key_pair        = "${var.ssh_key_pair}"
#  user_data       = "${file("user-data.conf")}"
#  security_groups = ["dcos"]
#
#  network {
#    uuid           = "${openstack_networking_network_v2.private.id}"
#    fixed_ip_v4    = "10.0.0.5"
#    access_network = true
#  }
#}
#
#resource "openstack_networking_floatingip_v2" "bootstrap_external_ip" {
#  pool       = "internet"
#  depends_on = ["openstack_networking_router_interface_v2.dcos_router_int"]
#}
#
#resource "openstack_compute_floatingip_associate_v2" "bootstrap_external_ip" {
#  floating_ip = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
#  instance_id = "${openstack_compute_instance_v2.bootstrap.id}"
#
#  provisioner "file" {
#    connection {
#      type = "ssh"
#      host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
#      user = "centos"
#    }
#    source      = "${path.module}/setup.sh"
#    destination = "/tmp/setup.sh"
#  }
#
#  provisioner "remote-exec" {
#    connection {
#      type = "ssh"
#      host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
#      user = "centos"
#    }
#
#    inline = ["sh /tmp/setup.sh > /tmp/setup.log"]
#  }
#}
