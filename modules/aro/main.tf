data "azurerm_client_config" "cluster" {}

data "azuread_client_config" "cluster" {}

resource "azuread_application" "cluster" {
  display_name = var.azuread_application
}

resource "azuread_service_principal" "main" {
  client_id = azuread_application.cluster.client_id
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id
}

data "azuread_service_principal" "redhatopenshift" {
  // This is the Azure Red Hat OpenShift RP service principal id, do NOT delete it
  client_id = "f1dd0a37-89c6-4e07-bcd1-ffd3d43d8875"
}

resource "azurerm_role_assignment" "role_network1" {
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.main.object_id
}

resource "azurerm_role_assignment" "role_network2" {
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.redhatopenshift.object_id
}

resource "azurerm_resource_group" "cluster" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet
  address_space       = [var.virtual_network_cidr]
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.cluster.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.main_subnet_cidr]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_subnet" "worker_subnet" {
  name                 = "worker-subnet"
  resource_group_name  = azurerm_resource_group.cluster.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.worker_subnet_cidr]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

# Create an Azure Red Hat OpenShift Cluster with variables
resource "azurerm_redhat_openshift_cluster" "cluster" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  tags                = var.tags

  cluster_profile {
    domain       = var.domain_name
    version      = var.cluster_version
    pull_secret  = var.pull_secret
    fips_enabled = var.fips_enabled
  }

  network_profile {
    pod_cidr      = var.pod_cidr
    service_cidr  = var.service_cidr
    outbound_type = var.outbound_type
  }

  main_profile {
    vm_size                    = var.main_profile_vm_size
    subnet_id                  = azurerm_subnet.main_subnet.id
    encryption_at_host_enabled = var.main_profile_encryption_at_host_enabled
  }

  api_server_profile {
    visibility = var.api_server_visibility
  }

  ingress_profile {
    visibility = var.ingress_visibility
  }

  worker_profile {
    vm_size                    = var.worker_profile_vm_size
    disk_size_gb               = var.worker_profile_disk_size_gb
    node_count                 = var.worker_profile_node_count
    subnet_id                  = azurerm_subnet.worker_subnet.id
    encryption_at_host_enabled = var.worker_profile_encryption_at_host_enabled

  }

  service_principal {
    client_id     = azuread_application.cluster.client_id
    client_secret = azuread_service_principal_password.main.value
  }

  depends_on = [
    "azurerm_role_assignment.role_network1",
    "azurerm_role_assignment.role_network2",
  ]
}
