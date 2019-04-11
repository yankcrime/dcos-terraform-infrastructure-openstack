output "network_id" {
  description = "UUID of the network"
  value = "${openstack_networking_network_v2.dcos_network.id}"
}

