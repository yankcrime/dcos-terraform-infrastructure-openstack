output "private_agents.instances" {
  description = "Private Agent instances IDs"
  value       = ["${module.dcos-private-agent-instances.instances}"]
}

output "private_agents.public_ips" {
  description = "Private Agent public IPs"
  value       = ["${module.dcos-private-agent-instances.public_ips}"]
}

output "private_agents.private_ips" {
  description = "Private Agent instances private IPs"
  value       = ["${module.dcos-private-agent-instances.private_ips}"]
}
