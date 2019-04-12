resource "openstack_lb_loadbalancer_v2" "masters_internal_lb" {
  description        = "DC/OS Master Loadbalancer (Internal)"
  vip_subnet_id      = "${var.subnet_id}"
  security_group_ids = ["${var.security_group_id}"]
}

resource "openstack_lb_listener_v2" "masters_internal_lb_listener" {
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.masters_internal_lb.id}"
}

resource "openstack_lb_pool_v2" "masters_internal_lb_pool" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.masters_internal_lb_listener.id}"
}

resource "openstack_lb_member_v2" "masters_internal_lb_members" {
  count         = "${var.num_masters}"
  address       = "${var.dcos_masters_ip_addresses[count.index]}"
  protocol_port = 80
  pool_id       = "${openstack_lb_pool_v2.masters_internal_lb_pool.id}"
  subnet_id     = "${var.subnet_id}"
}

resource "openstack_networking_floatingip_v2" "masters_internal_lb_flip" {
  pool    = "internet"
  port_id = "${openstack_lb_loadbalancer_v2.masters_internal_lb.vip_port_id}"
}