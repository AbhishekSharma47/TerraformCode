module "resource_group" {
  source                  = "../child_modules/RG_module"
  resource_group_name     = "abhitodo"
  resource_group_location = "Centralindia"
}

module "sql_server" {
  depends_on                   = [module.resource_group]
  source                       = "../child_modules/SQL_server_module"
  resource_group_name          = "abhitodo"
  location                     = "Centralindia"
  sql_server_name              = "abhitodoserver"
  administrator_login          = "abhiadmin"
  administrator_login_password = "Abhi@4791sh"
}

module "sql_db" {
  depends_on          = [module.sql_server]
  source              = "../child_modules/SQL_DB_module"
  sql_database_name   = "abhitododb"
  sql_server_name     = "abhitodoserver"
  resource_group_name = "abhitodo"
}

module "vnet" {
  depends_on               = [module.resource_group]
  source                   = "../child_modules/Vnet_module"
  virtual_network_location = "Centralindia"
  virtual_network_name     = "abhivnettodo"
  resource_group_name      = "abhitodo"
  address_space            = ["10.0.0.0/16"]
}

module "frontendsubnet" {
  depends_on           = [module.vnet]
  source               = "../child_modules/Subnet_module"
  subnet_name          = "frontendsubnettodo"
  virtual_network_name = "abhivnettodo"
  resource_group_name  = "abhitodo"
  address_prefixes     = ["10.0.1.0/24"]

}

module "backendsubnet" {
  depends_on           = [module.vnet]
  source               = "../child_modules/Subnet_module"
  subnet_name          = "backendsubnettodo"
  virtual_network_name = "abhivnettodo"
  resource_group_name  = "abhitodo"
  address_prefixes     = ["10.0.2.0/24"]

}

module "frontendpip" {
  depends_on          = [module.resource_group]
  source              = "../child_modules/PIP_module"
  public_ip_name      = "frontendpiptodo"
  resource_group_name = "abhitodo"
  location            = "Centralindia"
  allocation_method   = "Static"

}

module "backendpip" {
  depends_on          = [module.resource_group]
  source              = "../child_modules/PIP_module"
  public_ip_name      = "backendpiptodo"
  resource_group_name = "abhitodo"
  location            = "Centralindia"
  allocation_method   = "Static"

}

module "frontendnic" {
  depends_on = [ module.frontendsubnet ]
  source = "../child_modules/NIC_module"
  nic_name = "frontendnic"
  location = "Centralindia"
  resource_group_name = "abhitodo"
  frontend_ip_name = "frontendpiptodo"
  frontend_subnet_name = "frontendsubnettodo"
  vnet_name = "abhivnettodo"    
}

module "backendnic" {
  depends_on = [ module.backendsubnet ]
  source = "../child_modules/NIC_module"
  nic_name = "backendnic"
  location = "Centralindia"
  resource_group_name = "abhitodo"
  frontend_ip_name = "backendpiptodo"
  frontend_subnet_name = "backendsubnettodo"
  vnet_name = "abhivnettodo"    
}

module "frontendvm" {
  depends_on           = [module.frontendnic]
  source               = "../child_modules/VM_module"
  nic_name             = "frontendnic"
  location             = "Centralindia"
  resource_group_name  = "abhitodo"
  vm_name              = "frontendtodovm"
  vm_size              = "Standard_B1s"
  admin_username       = "abhiadmin"
  admin_password       = "Abhi@4791sh"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
}

module "backendvm" {
  depends_on           = [module.backendnic]
  source               = "../child_modules/VM_module"
  nic_name             = "backendnic"
  location             = "Centralindia"
  resource_group_name  = "abhitodo"
  vm_name              = "backendtodovm"
  vm_size              = "Standard_B1s"
  admin_username       = "abhiadmin"
  admin_password       = "Abhi@4791sh"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"

}