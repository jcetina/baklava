variable "name" {
  type        = string
  description = "Route table name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "IP location"
}

variable "tags" {
  type        = map(string)
  description = "Tags for route table"
  default = {
  }
}

variable "firewall_ip" {
  type        = string
  description = "Firewall IP"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Vnet address space"
}