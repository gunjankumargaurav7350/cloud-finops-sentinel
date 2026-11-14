variable "budgets" {
  type = map(object({
    subscription_id = string
    amount          = number
    time_grain      = optional(string, "Monthly")
    start_date      = optional(string, "2026-11-01T00:00:00Z")
    contact_emails  = list(string)
    contact_roles   = optional(list(string), ["Owner", "Contributor"])
    notifications = list(object({
      percent = number
      type    = string
    }))
  }))
  description = "Map of enterprise consumption budgets iterated with for_each"
  default     = {}
}
