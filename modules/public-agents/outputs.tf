output "private_ips" {
  description = "List of private IP addresses created by this module"
  value = ["${module.dcos-public-agent-instances.private_ips}"]
}
