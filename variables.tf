variable "ssh_key_pair" {
  type = "string"
  default = "deadline"
}

variable "number_of_masters" {
  type = "string"
  default = "1"
}

variable "internal_services" {
  type = "list"
  default = [ "80", "443","2181", "5050", "8080", "8181" ]
}

