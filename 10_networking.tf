resource "openstack_networking_network_v2" "private" {
  name = "private"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name       = "private_subnet"
  network_id = "${openstack_networking_network_v2.private.id}"
  cidr       = "10.0.0.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "dcos_router" {
  name                = "dcos_router"
  admin_state_up      = true
  external_network_id = "c72d2f60-9497-48b6-ab4d-005995aa4b21"
}

resource "openstack_networking_router_interface_v2" "dcos_router_int" {
  router_id = "${openstack_networking_router_v2.dcos_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

resource "openstack_lb_loadbalancer_v2" "admin_lb" {
  description   = "DC/OS Admin Router Loadbalancer"
  vip_subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

resource "openstack_lb_listener_v2" "admin_lb_listener" {
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.admin_lb.id}"
}

resource "openstack_lb_pool_v2" "admin_lb_pool" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.admin_lb_listener.id}"
}

resource "openstack_lb_member_v2" "admin_lb_members" {
  count         = "${var.number_of_masters}"
  address       = "10.0.0.10${count.index}"
  protocol_port = 80
  pool_id       = "${openstack_lb_pool_v2.admin_lb_pool.id}"
  subnet_id     = "${openstack_networking_subnet_v2.private_subnet.id}"
}

resource "openstack_networking_floatingip_v2" "admin_lb_flip" {
  pool    = "internet"
  port_id = "${openstack_lb_loadbalancer_v2.admin_lb.vip_port_id}"
}

resource "openstack_lb_loadbalancer_v2" "public_agent_lb" {
  description   = "DC/OS Public Agent Loadbalancer"
  vip_subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

resource "openstack_lb_listener_v2" "public_agent_lb_listener" {
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.public_agent_lb.id}"
}

resource "openstack_lb_pool_v2" "public_agent_lb_pool" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.public_agent_lb_listener.id}"
}

resource "openstack_lb_member_v2" "public_agent_lb_members" {
  address       = "10.0.0.150"
  protocol_port = 80
  pool_id       = "${openstack_lb_pool_v2.public_agent_lb_pool.id}"
  subnet_id     = "${openstack_networking_subnet_v2.private_subnet.id}"
}

resource "openstack_networking_floatingip_v2" "public_agent_lb_flip" {
  pool    = "internet"
  port_id = "${openstack_lb_loadbalancer_v2.public_agent_lb.vip_port_id}"
}
