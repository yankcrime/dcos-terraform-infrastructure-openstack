variable "cluster_name" {
  description = "Name of the DC/OS cluster"
}

variable "tags" {
  description = "Add custom tags to all resources"
  type        = "map"
  default     = {}
}

variable "flavor_name" {
  description = "Flavor (compute, memory, storage capacity)  of instance"
  default     = "bratwurst"
}

variable "image_name" {
  description = "The operating system image to be used for the instance"
  default     = "CentOS 7.6"
}

variable "network_id" {
  description = "The UUID of the network to which the instance will be attached"
  default     = ""
}

variable "security_groups" {
  description = "The security groups (firewall rules) that will be applied to this instance"
  type        = "list"
  default     = ["default"]
}

variable "key_pair" {
  description = "The name of the SSH key pair to be associated with this instance"
  type        = "string"
  default     = ""
}

variable "user_data" {
  description = "User data to be used on this instance (cloud-init)"
  default     = ""
}

variable "hostname_format" {
  description = "Format the hostname inputs are index+1, region, cluster_name"
  default     = "%[3]s-publicagent%[1]d-%[2]s"
}

variable "num_public_agents" {
  description = "Specify the number of public agents.  These agents will host marathon-lb and edgelb"
  default     = "1"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instances"
  default     = true
}

variable "floating_ip_pool" {
  description = "Subnet from which a floating IP address should be assigned"
  default = ""
}
