variable "rg_name" {
  type        = string
  description = "Resource group name for the vm"
}

variable "location" {
  type        = string
  description = "Location for the vm"
}


variable "vm_name" {
  type        = string
  description = "Name for the vm"
}

variable "ssh_key" {
  type        = string
  description = "SSH key for the vm"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the vm"
}

variable "create_public_ip" {
  type        = bool
  description = "Create a public IP for the vm"
  default     = false
}

variable "zones" {
  type        = list(string)
  description = "Zones for the vm"
  default     = []
}