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

variable "storage_account_name" {
  description = "Unique storage account name for FinOps function app"
  type        = string
  default     = "stfinopssentinelprod01"
}

variable "primary_subscription_id" {
  description = "Azure Subscription ID for enterprise consumption budget monitoring"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "target_subscription_ids" {
  description = "List of subscriptions to scan for orphaned resources and waste"
  type        = list(string)
  default     = ["00000000-0000-0000-0000-000000000000"]
}

variable "monthly_budget_amount" {
  description = "Monthly spending threshold in subscription currency"
  type        = number
  default     = 25000
}

variable "budget_thresholds" {
  description = "Dynamic list of budget notification trigger thresholds"
  type = list(object({
    percent = number
    type    = string
  }))
  default = [
    { percent = 50.0, type = "Actual" },
    { percent = 75.0, type = "Actual" },
    { percent = 90.0, type = "Actual" },
    { percent = 100.0, type = "Forecasted" }
  ]
}

variable "finops_stakeholder_emails" {
  description = "Email distribution list for financial alerts"
  type        = list(string)
  default     = ["gunjankumargaurav7@gmail.com", "cloud-governance@company.com"]
}

variable "auto_purge_enabled" {
  description = "If true, automatically deletes orphaned disks and unattached public IPs after grace period"
  type        = bool
  default     = false
}

variable "snapshot_retention_days" {
  description = "Maximum age in days before orphaned disk snapshots are flagged or purged"
  type        = number
  default     = 90
}

variable "alert_webhook_url" {
  description = "Slack or Microsoft Teams webhook URL for FinOps notifications"
  type        = string
  default     = "https://outlook.office.com/webhook/sample-finops-webhook"
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
