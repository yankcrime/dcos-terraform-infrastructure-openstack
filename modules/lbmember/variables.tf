variable "tags" {
  description = "Add custom tags to all resources"
  type = "map"
  default = {}
}

variable "address" {
  description = "IP address of loadbalancer member"
  type = "string"
  default = ""
}
