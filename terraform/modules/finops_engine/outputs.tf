output "function_app_name" {
  description = "Name of the FinOps engine Linux Function App"
  value       = azurerm_linux_function_app.finops_engine.name
}

output "function_app_principal_id" {
  description = "Principal ID of the Function App identity"
  value       = azurerm_linux_function_app.finops_engine.identity[0].principal_id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage.name
}
