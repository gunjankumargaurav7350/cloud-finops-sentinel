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
# FinOps Management Resource Group & Storage
# -------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "finops" {
  name     = var.resource_group_name
  location = var.location
  tags     = merge(var.default_tags, { "Workload" = "FinOps-Automation" })
}

resource "azurerm_storage_account" "finops_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.finops.name
  location                 = azurerm_resource_group.finops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true

  tags = var.default_tags
}

# -------------------------------------------------------------------------------------------------
# Serverless FinOps Waste Elimination Function App
# -------------------------------------------------------------------------------------------------
resource "azurerm_service_plan" "consumption" {
  name                = "asp-finops-sentinel-${var.environment}"
  resource_group_name = azurerm_resource_group.finops.name
  location            = azurerm_resource_group.finops.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = var.default_tags
}

resource "azurerm_linux_function_app" "finops_engine" {
  name                       = "func-finops-sentinel-${var.environment}"
  resource_group_name        = azurerm_resource_group.finops.name
  location                   = azurerm_resource_group.finops.location
  storage_account_name       = azurerm_storage_account.finops_storage.name
  storage_account_access_key = azurerm_storage_account.finops_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.consumption.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "AUTO_PURGE_ENABLED"             = var.auto_purge_enabled ? "true" : "false"
    "RETENTION_DAYS_SNAPSHOT"        = tostring(var.snapshot_retention_days)
    "ALERT_WEBHOOK_URL"              = var.alert_webhook_url
    "SUBSCRIPTION_IDS"               = join(",", var.target_subscription_ids)
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.finops_insights.connection_string
  }

  tags = var.default_tags
}

# -------------------------------------------------------------------------------------------------
# Application Insights & Log Analytics Telemetry Optimization
# -------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "finops_law" {
  name                = "law-finops-telemetry-${var.environment}"
  resource_group_name = azurerm_resource_group.finops.name
  location            = azurerm_resource_group.finops.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 5 # Telemetry cap preventing runaway log ingestion costs

  tags = var.default_tags
}

resource "azurerm_application_insights" "finops_insights" {
  name                = "appi-finops-${var.environment}"
  resource_group_name = azurerm_resource_group.finops.name
  location            = azurerm_resource_group.finops.location
  workspace_id        = azurerm_log_analytics_workspace.finops_law.id
  application_type    = "web"
  tags                = var.default_tags
}

# -------------------------------------------------------------------------------------------------
# Azure Consumption Enterprise Budgets & Dynamic Anomaly Alerts
# -------------------------------------------------------------------------------------------------
resource "azurerm_consumption_budget_subscription" "enterprise_budget" {
  name            = "budget-enterprise-cloud-${var.environment}"
  subscription_id = "/subscriptions/${var.primary_subscription_id}"
  amount          = var.monthly_budget_amount
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-11-01T00:00:00Z"
  }

  dynamic "notification" {
    for_each = var.budget_thresholds
    content {
      enabled        = true
      threshold      = notification.value.percent
      operator       = "GreaterThan"
      threshold_type = notification.value.type

      contact_emails = var.finops_stakeholder_emails
      contact_roles  = ["Owner", "Contributor"]
    }
  }
}
