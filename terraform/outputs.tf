output "log_analytics_workspace_id" {
  description = "ID of the telemetry-optimized Log Analytics Workspace"
  value       = module.finops_monitoring.log_analytics_workspace_id
}

output "finops_engines" {
  description = "FinOps Function App engines provisioned via modular for_each"
  value = {
    for k, v in module.finops_engine : k => {
      function_app_name         = v.function_app_name
      function_app_principal_id = v.function_app_principal_id
      storage_account_name      = v.storage_account_name
    }
  }
}

output "consumption_budgets" {
  description = "IDs of the enterprise monthly budgets provisioned via modular for_each"
  value       = module.consumption_budgets.budget_ids
}
