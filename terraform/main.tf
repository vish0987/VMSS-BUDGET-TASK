provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vmss-demo"
  location = "uksouth"
}

resource "azurerm_consumption_budget_resource_group" "vmss_budget" {
  name                = "vmss-budget-alert"
  resource_group_name = azurerm_resource_group.rg.name
  amount              = 100
  time_grain          = "Monthly"
  time_period_start   = "2025-08-01T00:00:00Z"

  notification {
    enabled         = true
    operator        = "GreaterThan"
    threshold       = 80
    contact_emails  = ["alert-recipient@example.com"]
    contact_roles   = []
  }
}
