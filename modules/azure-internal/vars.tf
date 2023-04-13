variable "vnet_location" {
  type        = string
  description = "Location for the site vnet"
}

variable "rg_name" {
  type        = string
  description = "Resource group name for the site vnet"
}

variable "cidr" {
  type        = list(string)
  description = "CIDR for the site vnet"
}

variable "gateway_subnet_prefixes" {
  type        = list(string)
  description = "CIDR for the site vnet gateway subnet"
}

variable "vm_subnet_prefixes" {
  type        = list(string)
  description = "CIDR for the site vnet vm subnet"
}

variable "firewall_subnet_prefixes" {
  type        = list(string)
  description = "CIDR for the site vnet firewall subnet"
}