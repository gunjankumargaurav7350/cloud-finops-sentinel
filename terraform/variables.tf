variable "resource_group_name" {
  description = "Name of the resource group for FinOps tooling"
  type        = string
  default     = "rg-finops-sentinel-prod"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment tier (e.g. prod, staging)"
  type        = string
  default     = "prod"
}

variable "log_retention_days" {
  description = "Log Analytics retention period in days"
  type        = number
  default     = 30
}

variable "daily_log_quota_gb" {
  description = "Daily telemetry ingestion quota in GB"
  type        = number
  default     = 5
}

variable "finops_engines" {
  type = map(object({
    storage_account_name    = string
    auto_purge_enabled      = optional(bool, false)
    snapshot_retention_days = optional(number, 90)
    alert_webhook_url       = optional(string, "https://outlook.office.com/webhook/sample-finops-webhook")
    target_subscription_ids = optional(list(string), ["00000000-0000-0000-0000-000000000000"])
    tags                    = optional(map(string), {})
  }))
  description = "FinOps waste-collector Function App engines instantiated via for_each"
  default = {
    "prod" = {
      storage_account_name    = "stfinopssentinelprod01"
      auto_purge_enabled      = false
      snapshot_retention_days = 90
      alert_webhook_url       = "https://outlook.office.com/webhook/sample-finops-webhook"
      target_subscription_ids = ["00000000-0000-0000-0000-000000000000"]
    }
  }
}

variable "budgets" {
  type = map(object({
    subscription_id = string
    amount          = number
    time_grain      = optional(string, "Monthly")
    start_date      = optional(string, "2026-11-01T00:00:00Z")
    contact_emails  = list(string)
    contact_roles   = optional(list(string), ["Owner", "Contributor"])
    notifications = list(object({
      percent = number
      type    = string
    }))
  }))
  description = "Enterprise consumption budgets with alerts managed via for_each"
  default = {
    "budget-enterprise-cloud-prod" = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
      amount          = 25000
      time_grain      = "Monthly"
      start_date      = "2026-11-01T00:00:00Z"
      contact_emails  = ["gunjankumargaurav7@gmail.com", "cloud-governance@company.com"]
      contact_roles   = ["Owner", "Contributor"]
      notifications = [
        { percent = 50.0, type = "Actual" },
        { percent = 75.0, type = "Actual" },
        { percent = 90.0, type = "Actual" },
        { percent = 100.0, type = "Forecasted" }
      ]
    }
  }
}

variable "default_tags" {
  description = "Mandatory enterprise tags applied to all FinOps resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    CostCenter  = "CC-FinOps-Core"
    Owner       = "Gunjan Kumar Gaurav"
    Compliance  = "CIS-Azure-v2.0"
  }
}
