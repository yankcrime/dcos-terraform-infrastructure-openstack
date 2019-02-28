output "bootstrap external ip" {
  value = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
}

output "dcos master external ip" {
  value = "${openstack_networking_floatingip_v2.master_external_ip.address}"
}

output "dcos public agent external ip" {
  value = "${openstack_networking_floatingip_v2.public_agent_external_ip.address}"
}
