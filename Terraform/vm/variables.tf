variable "resource_group_name" {
  type        = string
  description = "Resource Group"
  default     = "myazrg"
}

variable "location" {
  description = "Location"
  default     = "South India"
}

variable "network_interfaces" {
  description = "Network interfaces"
  default     = ["Dbnic", "Webnic"]
}


variable "vnet_name" {
  description = "Virtual Network"
  default     = "Myazvnet"
}

variable "address_space" {
  description = "Address for vnet"
  default     = "10.0.0.0/16"
}
/*
variable "network_interface_ids" {
  description = "Network interface ids"
  default     = ["subscriptions/573fc463-a743-481f-8688-28a35876fa68/resourceGroups/myazrg/providers/Microsoft.Network/networkInterfaces/Dbnic", "subscriptions/573fc463-a743-481f-8688-28a35876fa68/resourceGroups/myazrg/providers/Microsoft.Network/networkInterfaces/Webnic"]
} */

variable "publicip_name" {
  description = "Public IPs name"
  default     = ["DBip", "Webip"]
}


variable "subnet_name" {
  default = ["Dbsubnet", "Websubnet"]
}

variable "subnet_prefix" {
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "vm" {
  description = "Virtual Machines"
  default     = ["DBVM", "WebVM"]
}

variable "sshkey" {
  description = "ssh_key_private"
  default     = "~/.ssh/id_rsa"
}

variable "disk" {
  default = ["myosdisk1", "myosdisk2"]
}

