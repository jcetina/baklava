variable "name" {
  type        = string
  description = "NAT Gateway name"
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
  description = "NAT gateway sku"
  default     = "Standard"
  validation {
    condition     = contains(["Standard"], var.sku)
    error_message = "Only Standard is supported at the moment"
  }
}

variable "ip_count" {
  type        = number
  description = "Number of IP addresses to allocate"
  validation {
    condition     = contains([1, 2, 4, 8, 16], var.ip_count)
    error_message = "ip_count must be one of 1, 2, 4, 8, 16"
  }
  default = 1
}

variable "tags" {
  type        = map(string)
  description = "Tags for vnet"
  default = {
  }
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones where the NAT Gateway should be deployed"
  default     = []
}

variable "idle_timeout" {
  type        = number
  description = "Idle timeout for NAT Gateway"
  default     = 4
  validation {
    condition     = var.idle_timeout >= 4 && var.idle_timeout <= 120
    error_message = "idle_timeout must be between 4 and 120"
  }
}