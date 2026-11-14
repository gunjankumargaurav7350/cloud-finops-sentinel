output "budget_ids" {
  description = "Map of created subscription budget names to IDs"
  value       = { for k, b in azurerm_consumption_budget_subscription.budget : k => b.id }
}
