resource "openstack_networking_network_v2" "private" {
  name = "private"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name         = "private_subnet"
  network_id   = "${openstack_networking_network_v2.private.id}"
  cidr         = "10.0.0.0/24"
  ip_version   = 4
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
