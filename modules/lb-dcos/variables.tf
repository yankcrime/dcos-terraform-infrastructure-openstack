variable "num_masters" {
  type    = "string"
  default = ""
}

variable "num_public_agents" {
  type    = "string"
  default = ""
}

variable "network_id" {
  type    = "string"
  default = ""
}

variable "subnet_id" {
  type    = "string"
  default = ""
}

variable "security_group_id" {
  type    = "list"
  default = [""]
}

variable "dcos_masters_ip_addresses" {
  type    = "list"
  default = [""]
}

variable "dcos_public_agents_ip_addresses" {
  type    = "list"
  default = [""]
}

variable "masters_lb_security_group_id" {
  type    = "list"
  default = [""]
}

variable "public_agents_lb_security_group_id" {
  type    = "string"
  default = ""
}

variable "public_agents_additional_ports" {
  description = "List of additional ports allowed for public access on public agents"
  default     = []
}
