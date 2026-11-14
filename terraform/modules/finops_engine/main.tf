resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true

  tags = var.tags
}

resource "azurerm_service_plan" "consumption" {
  name                = "asp-finops-sentinel-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "finops_engine" {
  name                       = "func-finops-sentinel-${var.environment}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
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
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "AUTO_PURGE_ENABLED"                    = var.auto_purge_enabled ? "true" : "false"
    "RETENTION_DAYS_SNAPSHOT"               = tostring(var.snapshot_retention_days)
    "ALERT_WEBHOOK_URL"                     = var.alert_webhook_url
    "SUBSCRIPTION_IDS"                      = join(",", var.target_subscription_ids)
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
  }

  tags = var.tags
}
