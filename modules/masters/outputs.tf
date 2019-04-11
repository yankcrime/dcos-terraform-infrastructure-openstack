output "private_ips" {
  description = "List of private IP addresses created by this module"
  value = ["${module.dcos-master-instances.private_ips}"]
}
