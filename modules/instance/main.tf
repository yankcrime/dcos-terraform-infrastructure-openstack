data "openstack_compute_availability_zones_v2" "region" {}

resource "openstack_compute_instance_v2" "instance" {
  count           = "${var.num_instances}"
  name            = "${format(var.hostname_format, count.index + 1, data.openstack_compute_availability_zones_v2.region.id, var.cluster_name)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.key_pair}"
  user_data       = "${var.user_data}"
  security_groups = "${var.security_groups}"
  network         = {
    uuid = "${var.network_id}"
  }
}
