variable "security_groups" {
  description = "The security groups (firewall rules) that will be applied to this loadbalancer"
  type        = "list"
  default     = ["default"]
}

# TODO: This shouldn't live here
variable "num_masters" {
  default = "1"
}

variable "network_id" {
  description = "The network ID in which the loadbalancer should sit"
  default = ""
}

variable "subnet_id" {
  description = "The subnet ID in which lb members should reside"
  default = ""
}

variable "dcos_masters_ip_addresses" {
  type = "list"
  default = [""]
}

