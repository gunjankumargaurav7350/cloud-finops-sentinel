terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# -------------------------------------------------------------------------------------------------
# FinOps Management Resource Group
# -------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "finops" {
  name     = var.resource_group_name
  location = var.location
  tags     = merge(var.default_tags, { "Workload" = "FinOps-Automation" })
}

# -------------------------------------------------------------------------------------------------
# Module: FinOps Observability & Telemetry Cap
# -------------------------------------------------------------------------------------------------
module "finops_monitoring" {
  source = "./modules/finops_monitoring"

  resource_group_name = azurerm_resource_group.finops.name
  location            = azurerm_resource_group.finops.location
  environment         = var.environment
  retention_in_days   = var.log_retention_days
  daily_quota_gb      = var.daily_log_quota_gb
  tags                = var.default_tags
}

# -------------------------------------------------------------------------------------------------
# Module: FinOps Automation Engines using for_each
# -------------------------------------------------------------------------------------------------
module "finops_engine" {
  source   = "./modules/finops_engine"
  for_each = var.finops_engines

  resource_group_name                    = azurerm_resource_group.finops.name
  location                               = azurerm_resource_group.finops.location
  environment                            = each.key
  storage_account_name                   = each.value.storage_account_name
  auto_purge_enabled                     = each.value.auto_purge_enabled
  snapshot_retention_days                = each.value.snapshot_retention_days
  alert_webhook_url                      = each.value.alert_webhook_url
  target_subscription_ids                = each.value.target_subscription_ids
  application_insights_connection_string = module.finops_monitoring.application_insights_connection_string
  tags                                   = merge(var.default_tags, each.value.tags)
}

# -------------------------------------------------------------------------------------------------
# Module: Enterprise Consumption Budgets using for_each
# -------------------------------------------------------------------------------------------------
module "consumption_budgets" {
  source  = "./modules/consumption_budgets"
  budgets = var.budgets
}
