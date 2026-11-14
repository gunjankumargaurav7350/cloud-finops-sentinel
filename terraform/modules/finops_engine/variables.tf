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
  description = "Environment tier"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "auto_purge_enabled" {
  type        = bool
  default     = false
}

variable "snapshot_retention_days" {
  type        = number
  default     = 90
}

variable "alert_webhook_url" {
  type        = string
  default     = ""
}

variable "target_subscription_ids" {
  type        = list(string)
  default     = []
}

variable "application_insights_connection_string" {
  type        = string
  description = "App Insights Connection String"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  default     = {}
}
