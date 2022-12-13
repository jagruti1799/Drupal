terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}
module "vnet" {
  source              = "./vnet"
  location            = var.location

}

module "vm" {
  source              = "./vm"
  location            = var.location
}
