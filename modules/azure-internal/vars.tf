variable "vnet_location" {
  type        = string
  description = "Location for the site vnet"
}

variable "vnet_rg" {
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