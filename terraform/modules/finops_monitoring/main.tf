resource "azurerm_log_analytics_workspace" "finops_law" {
  name                = "law-finops-telemetry-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb

  tags = var.tags
}

resource "azurerm_application_insights" "finops_insights" {
  name                = "appi-finops-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.finops_law.id
  application_type    = "web"
  tags                = var.tags
}
