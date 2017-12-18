# provider "azurerm" {
#   subscription_id = "${var.subscription_id}"
#   client_id       = "${var.client_id}"
#   client_secret   = "${var.client_secret}"
#   tenant_id       = "${var.tenant_id}"
# }

# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}

variable "rg_name" {
  default = "apache"
}

variable "packer_image" {
  default = ""
}

variable "location"{
  default = "eastus"
}

resource "azurerm_resource_group" "testrg" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

data "azurerm_image" "search" {
  name                = "${var.packer_image}"
  resource_group_name = "${var.rg_name}"
}

module "network" {
  source = "Azure/network/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "${var.location}"
}

module "loadbalancer" {
  source = "Azure/loadbalancer/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "${var.location}"
  prefix = "tflbtest"
  lb_port = {
    http = [ "80", "Tcp", "80" ]
  }
}

module "computegroup" {
  source = "Azure/computegroup/azurerm"
  resource_group_name = "${var.rg_name}"
  location = "${var.location}"
  cmd_extension = "echo hi"
  vm_os_id = "${data.azurerm_image.search.id}"
  load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
  vnet_subnet_id = "${module.network.vnet_subnets[0]}"
  lb_port = {
    http = [ "80", "Tcp", "80" ]
    https = [ "443", "Tcp", "443" ]
  }
  vm_size = "Standard_DS2_v2"
  # vm_os_publisher = "Open"
  # vm_os_offer = "CentOS"
  # vm_os_sku = "7.4"
}
