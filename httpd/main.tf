provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "rg_name" {
  default = "apache2"
}

resource "azurerm_resource_group" "testrg" {
  name     = "${var.rg_name}"
  location = "eastus"
}

module "network" {
  source = "Azure/network/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "eastus"
}

module "loadbalancer" {
  source = "Azure/loadbalancer/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "eastus"
  prefix = "tflbtest"
  lb_port = {
    http = [ "80", "Tcp", "80" ]
  }
}

module "computegroup" {
  source = "Azure/computegroup/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "eastus"
  load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
  vnet_subnet_id = "${module.network.vnet_subnets[0]}"
  lb_port = {
    http = [ "80", "Tcp", "80" ]
    https = [ "443", "Tcp", "443" ]
  }
  vm_size = "Standard_A0"
  vm_os_publisher = "OpenLogic"
  vm_os_offer = "CentOS"
  vm_os_sku = "7.4"
}
