variable "ssh_key_pair" {
  type = "string"
  default = "deadline"
}

variable "num_masters" {
  type = "string"
  default = "3"
}

variable "num_public_agents" {
  type = "string"
  default = "1"
}

variable "num_private_agents" {
  type = "string"
  default = "3"
}

variable "internal_services" {
  type = "list"
  default = [ "80", "443","2181", "5050", "8080", "8181" ]
}

variable "dcos_instance_os" {
  description = "Operating system to use."
  default     = "CentOS 7.6"
}

variable "subnet_range" {
  description = "Private IP space to be used in CIDR format"
  default     = "172.16.0.0/16"
}

variable "cluster_name" {
  description = "Name of the DC/OS cluster"
}

variable "external_network_id" {
  description = "The UUID of the external network"
}

variable "floating_ip_pool" {
  description = "The name of the pool of addresses from which floating IPs can be allocated"
}
