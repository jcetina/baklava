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

variable "breakglass" {
  type        = bool
  description = "Allow all traffic through the firewall"
  default     = false
}

variable "user_allowed_network_rules" {
  type = list(object({
    name                  = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = list(string)
    destination_ports     = list(string)
  }))
  description = "Application rule collection for the firewall rule collection group"
  default     = []
}

variable "user_allowed_application_rules" {
  type = list(object({
    name = string
    protocols = list(object({
      type = string
      port = number
    }))
    source_addresses  = list(string)
    destination_fqdns = list(string)
  }))
  description = "Application rule collection for the firewall rule collection group"
  default     = []
}