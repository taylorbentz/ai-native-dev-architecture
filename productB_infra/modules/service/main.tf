# Illustrative service module — placeholder resources only.

variable "name" {
  type        = string
  description = "Logical name for this service."
}

variable "replicas" {
  type        = number
  description = "Desired number of running instances."
  default     = 2
}

# Placeholder local — stands in for a real provider resource in this illustration.
locals {
  service_label = "${var.name}-svc"
}

output "service_label" {
  value       = local.service_label
  description = "Label applied to service resources."
}
