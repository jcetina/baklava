variable "name" {
  type        = string
  description = "Subnet name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_name" {
  type        = string
  description = "Parent Vnet name"
}

variable "address_prefixes" {
  type        = list(string)
  description = "Vnet address space"
}

