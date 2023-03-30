variable "tags" {
  type        = map(string)
  description = "Tags for vnet"
  default = {
  }
}

variable "name" {
  type        = string
  description = "Vnet name"
}

variable "firewall_name" {
  type        = string
  description = "Firewall name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Vnet location"
}

variable "address_space" {
  type        = list(string)
  description = "Vnet address space"
}

variable "firewall_subnet" {
  type        = list(string)
  description = "Vnet address space"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones where the Azure Firewall should be deployed"
  default     = []
}