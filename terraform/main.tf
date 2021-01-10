provider "azurerm" {
  features {}
}

#get the image that was create by the packer script
data "azurerm_image" "main" {
  name                = "myUdacityImage"
  resource_group_name = "udacity-rg"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg2"
  location = var.location
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
   tags =  var.tagging_policy
}


resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

#create a public IP for the Load Balancer
resource "azurerm_public_ip" "main" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"  
   tags =  var.tagging_policy
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
   tags =  var.tagging_policy

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
    
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "${var.prefix}-lb-backend-pool"
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
   tags =  var.tagging_policy

  security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Internet"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-${count.index}-nic"
  count               = var.vm_instances_count
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
   tags =  var.tagging_policy

  ip_configuration {
    primary                       = true
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-${count.index}-vm"
  count                           = var.vm_instances_count
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2_v3"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = azurerm_availability_set.main.id
  disable_password_authentication = false
  network_interface_ids           = [element(azurerm_network_interface.main.*.id, count.index)] 
  source_image_id = data.azurerm_image.main.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

   tags =  var.tagging_policy
}

#create a virtual disk for each VM created.
resource "azurerm_managed_disk" "main" {
  name                 = "${var.prefix}-managed-disk"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1
   tags =  var.tagging_policy
}


resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-availability_set"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
   tags =  var.tagging_policy
}
