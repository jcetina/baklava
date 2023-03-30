variable "name" {
  type        = string
  description = "IP name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "IP location"
}

variable "sku" {
  type        = string
  description = "Public IP sku"
  default     = "Standard"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones where the Azure Firewall should be deployed"
  default     = []
}