resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  default_node_pool {
    name                 = "systempool"
    vm_size              = "${var.node_size}"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = var.disk_size
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id = data.azurerm_subnet.subnet.id
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "${var.environment}"
      "nodepoolos"       = "linux"
      "app"              = "system-apps"
    }
    tags = {
      "nodepool-type"    = "system"
      "environment"      = "${var.environment}"
      "nodepoolos"       = "linux"
      "app"              = "system-apps"
    }
  }

  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  # Add On Profiles
  addon_profile {
    azure_policy {enabled =  true}
    oms_agent {
      enabled =  true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
    }
  }


  # Windows Profile
  #windows_profile {
  #  admin_username = var.windows_admin_username
  #  admin_password = var.windows_admin_password
  #}

  # Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  # Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = var.environment
  }
}
