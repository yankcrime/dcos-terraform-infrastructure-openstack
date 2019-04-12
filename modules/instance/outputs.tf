output "private_ips" {
  description = "List of private IP addresses created by this module"
  value = ["${openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4}"]
}

