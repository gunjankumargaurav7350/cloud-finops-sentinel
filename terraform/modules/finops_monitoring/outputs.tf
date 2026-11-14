output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.finops_law.id
}

output "application_insights_connection_string" {
  description = "Application Insights Connection String"
  value       = azurerm_application_insights.finops_insights.connection_string
  sensitive   = true
}
