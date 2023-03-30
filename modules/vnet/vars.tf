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

variable "nat_gateway_name" {
  type        = string
  description = "NAT Gateway name"
}

variable "nat_gw_ip_count" {
  type        = number
  description = "Number of IP addresses to allocate"
  validation {
    condition = contains([1, 2, 4, 8, 16], var.nat_gw_ip_count)
    error     = "nat_gw_ip_count must be one of 1, 2, 4, 8, 16"
  }
  default = 1
}

variable "nat_gw_idle_timeout" {
  type        = number
  description = "Idle timeout for NAT Gateway"
  default     = 4
  validation {
    condition = var.nat_gw_idle_timeout >= 4 && var.nat_gw_idle_timeout <= 120
    error     = "nat_gw_idle_timeout must be between 4 and 120"
  }
}