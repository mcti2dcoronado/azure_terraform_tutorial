resource "azurerm_virtual_network" "mynet" {
  name                = "mynet-mcti"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azureresourcegroup.location
  resource_group_name = azurerm_resource_group.azureresourcegroup.name
}

resource "azurerm_subnet" "sbnet-mcti" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.azureresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "mynic" {
  name                = "mynic-mcti"
  location            = azurerm_resource_group.azureresourcegroup.location
  resource_group_name = azurerm_resource_group.azureresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sbnet-mcti.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "myvm" {
  for_each 	      = local.windows_vm
  name                = each.key
  resource_group_name = azurerm_resource_group.azureresourcegroup.name
  location            = azurerm_resource_group.azureresourcegroup.location
  size                = each.value.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]

  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }
  
  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

}
