# Illustrative network module — placeholder resources only.

variable "name" {
  type        = string
  description = "Logical name for this network."
}

variable "cidr_block" {
  type        = string
  description = "Address range for the network."
  default     = "10.0.0.0/16"
}

# Placeholder local — stands in for a real provider resource in this illustration.
locals {
  network_tag = "${var.name}-network"
}

output "network_tag" {
  value       = local.network_tag
  description = "Tag applied to network resources."
}
