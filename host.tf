# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "kestra" {
  name     = "kestra-rg"
  location = "westus2"
}

resource "azurerm_virtual_network" "kestra" {
  name                = "kestra-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kestra.location
  resource_group_name = azurerm_resource_group.kestra.name
}

resource "azurerm_subnet" "kestra" {
  name                 = "kestra-subnet"
  resource_group_name  = azurerm_resource_group.kestra.name
  virtual_network_name = azurerm_virtual_network.kestra.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "kestra" {
  name                = "kestra-public-ip"
  location            = azurerm_resource_group.kestra.location
  resource_group_name = azurerm_resource_group.kestra.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "kestra" {
  name                = "kestra-nic"
  location            = azurerm_resource_group.kestra.location
  resource_group_name = azurerm_resource_group.kestra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kestra.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "kestra" {
  name                  = "kestra-vm"
  location              = azurerm_resource_group.kestra.location
  resource_group_name   = azurerm_resource_group.kestra.name
  network_interface_ids = [azurerm_network_interface.kestra.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "kestra-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
