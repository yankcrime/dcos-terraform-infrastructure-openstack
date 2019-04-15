output "bootstrap.instance" {
  description = "Bootstrap instance ID"
  value       = "${module.dcos-bootstrap-instance.instance}"
}

output "bootstrap.public_ip" {
  description = "Public IP of the bootstrap instance"
  value       = "${module.dcos-bootstrap-instance.public_ip}"
}

output "bootstrap.private_ip" {
  description = "Private IP of the bootstrap instance"
  value       = "${module.dcos-bootstrap-instance.private_ip}"
}

output "masters.instances" {
  description = "Master instances IDs"
  value       = ["${module.dcos-master-instances.instances}"]
}

output "masters.public_ips" {
  description = "Master instances public IPs"
  value       = ["${module.dcos-master-instances.public_ips}"]
}

output "masters.private_ips" {
  description = "Master instances private IPs"
  value       = ["${module.dcos-master-instances.private_ips}"]
}

output "lb.public_agents" {
  description = "Public agents loadbalancer external IP address"
  value       = "${module.dcos-lb.lb_public_agents.public_ip}"
}
