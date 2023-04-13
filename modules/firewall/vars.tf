variable "rg_name" {
  type        = string
  description = "Resource group name for the firewall"
}

variable "location" {
  type        = string
  description = "Location for the firewall"
}

variable "fw_name" {
  type        = string
  description = "Name for the firewall"
}

variable "zones" {
  type        = list(string)
  description = "Zones for the firewall"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the firewall"
}

var "breakglass" {
  type        = bool
  description = "Allow all traffic through the firewall"
  default     = false
}