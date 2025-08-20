resource "azurerm_consumption_budget_subscription" "budget" {
name = "vmss-budget"
subscription_id = data.azurerm_subscription.current.id


amount = 50
time_grain = "Monthly"
time_period {
start_date = "2025-01-01T00:00:00Z"
end_date = "2026-01-01T00:00:00Z"
}
category = "Cost"


filter {
tag {
name = "costScope"
operator = "In"
values = ["vmss-demo"]
}
}


notification {
enabled = true
threshold = 80
operator = "GreaterThan"
contact_emails = ["shaikhussain752@gmail.com"]
}
}
