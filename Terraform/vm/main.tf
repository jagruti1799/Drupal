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

resource "azurerm_resource_group" "myazrg" {
  name     = var.resource_group_name
  location = var.location
} 


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
} 

resource "azurerm_public_ip" "publicip" {
  name                = var.publicip_name[count.index]
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  count               = length(var.publicip_name)
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["${var.subnet_prefix[count.index]}"]
  count                = length(var.subnet_name)

}

resource "azurerm_network_interface" "network_interfaces" {
  name                = var.network_interfaces[count.index]
  location            = var.location
  resource_group_name = var.resource_group_name
  count               = length(var.network_interfaces)

  ip_configuration {
    name                          = var.publicip_name[count.index]
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                = var.vm[count.index]
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = "Standard_B1s"
  count               = length(var.vm)

  network_interface_ids = [
    azurerm_network_interface.network_interfaces[count.index].id,
  ]

  storage_os_disk {
    name              = var.disk[count.index]
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm[count.index]
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("/home/einfochips/.ssh/id_rsa.pub")
    }
  }

      connection {
      type = "ssh"
      user = "adminuser"
      host = azurerm_public_ip.publicip[count.index].ip_address
      private_key = file(var.sshkey)
       } 
      
  provisioner "file" {

    source      = "/home/einfochips/Desktop/drupal/Terraform/web.sh"
    destination = "/home/adminuser/web.sh"
  }

  provisioner "local-exec" {
    command = "echo dbserver ansible_ssh_host=${azurerm_public_ip.publicip[0].ip_address} > /home/einfochips/Desktop/drupal/Ansible/inventory"
  }
  provisioner "local-exec" {
    command = "echo webserver ansible_ssh_host=${azurerm_public_ip.publicip[1].ip_address} >> /home/einfochips/Desktop/drupal/Ansible/inventory"
  }

  provisioner "remote-exec" {
    inline = [
      "ls -a",
      "sudo chmod +x web.sh",
      "sudo sh web.sh",
    ]
  }

  provisioner "local-exec" {
  command = "ansible-playbook -i '${azurerm_public_ip.publicip[count.index].ip_address},' --private-key ${var.sshkey} /home/einfochips/Desktop/drupal/Ansible/execute.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -r '172 s/.*/        /* AllowOverride All/' /etc/apache2/apache2.conf",
      "sudo a2enmod rewrite",
      "sudo systemctl restart apache2.service",
    ]
  }


}

