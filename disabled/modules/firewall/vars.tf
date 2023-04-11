variable "name" {
  type        = string
  description = "Firewall name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "FW location"
}

variable "subnet_id" {
  type        = string
  description = "Resource ID of the Subnet where the Azure Firewall lives"
}

variable "sku_name" {
  type        = string
  description = "Resource ID of the Subnet where the Azure Firewall lives"
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  type        = string
  description = "Resource ID of the Subnet where the Azure Firewall lives"
  default     = "Standard"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones where the Azure Firewall should be deployed"
  default     = []
}

variable "policy_id" {
  type        = string
  description = "Resource ID of the Azure Firewall Policy to associate with the Azure Firewall"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for FW"
  default = {
  }
}