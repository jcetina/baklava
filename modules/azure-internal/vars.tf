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

variable "firewall_private_ip" {
  type        = string
  description = "Private IP for the site firewall"
}

variable "enable_firewall" {
  type        = bool
  description = "Enable the site firewall"
  default     = false
}