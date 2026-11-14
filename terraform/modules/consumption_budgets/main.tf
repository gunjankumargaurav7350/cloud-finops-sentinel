resource "azurerm_consumption_budget_subscription" "budget" {
  for_each        = var.budgets
  name            = each.key
  subscription_id = "/subscriptions/${each.value.subscription_id}"
  amount          = each.value.amount
  time_grain      = each.value.time_grain

  time_period {
    start_date = each.value.start_date
  }

  dynamic "notification" {
    for_each = each.value.notifications
    content {
      enabled        = true
      threshold      = notification.value.percent
      operator       = "GreaterThan"
      threshold_type = notification.value.type

      contact_emails = each.value.contact_emails
      contact_roles  = each.value.contact_roles
    }
  }
}
