data "azurerm_network_interface" "Nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
}