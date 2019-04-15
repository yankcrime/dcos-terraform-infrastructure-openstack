output "master_lb" {
  description = "UUID of security group for masters load balacer"
  value       = "${openstack_compute_secgroup_v2.master_lb.*.id}"
}

output "public_agents" {
  description = "UUID of security group for public agents load balancer"
  value       = "${openstack_compute_secgroup_v2.public_agents.*.id}"
}
