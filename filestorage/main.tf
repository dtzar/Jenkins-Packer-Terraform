resource "azurerm_resource_group" "azurefs" {
  name     = "azurefs-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "azurefs" {
  name                     = "azurefsstore"
  resource_group_name      = "${azurerm_resource_group.azurefs.name}"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "azurefs" {
  name = "myfiles"

  resource_group_name  = "${azurerm_resource_group.azurefs.name}"
  storage_account_name = "${azurerm_storage_account.azurefs.name}"

  quota = 50
}