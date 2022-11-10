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
  source              = "/home/einfochips/Desktop/drupal/Terraform/vnet"
  location            = var.location

}

module "vm" {
  source              = "/home/einfochips/Desktop/drupal/Terraform/vm"
  location            = var.location
}
