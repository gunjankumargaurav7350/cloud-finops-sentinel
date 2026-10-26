output "function_app_name" {
  description = "Name of the FinOps engine Linux Function App"
  value       = azurerm_linux_function_app.finops_engine.name
}

output "function_app_principal_id" {
  description = "System-assigned managed identity principal ID for RBAC assignment"
  value       = azurerm_linux_function_app.finops_engine.identity[0].principal_id
}

output "log_analytics_workspace_id" {
  description = "ID of the telemetry-optimized Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.finops_law.id
}

output "consumption_budget_id" {
  description = "ID of the enterprise monthly budget"
  value       = azurerm_consumption_budget_subscription.enterprise_budget.id
}
