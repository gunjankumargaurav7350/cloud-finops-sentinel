variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "environment" {
  type        = string
  description = "Deployment Tier"
}

variable "retention_in_days" {
  type        = number
  description = "Log Analytics retention days"
  default     = 30
}

variable "daily_quota_gb" {
  type        = number
  description = "Daily ingestion cap in GB"
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}
