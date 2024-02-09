# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = local.module_path
}

locals {
  module_path = "../modules/aro"
}

inputs = {
  azuread_application   = "example-aro"
  cluster_name          = "terraform-aro-cluster"
  cluster_version       = "4.13.23"
  api_server_visibility = "Public"
  ingress_visibility    = "Public"
  resource_group_name   = "aro-resource-group"
  location              = "East US"
  domain_name           = "aro.example.com"
  vnet                  = "aro-vnet"
  pod_cidr              = "10.128.0.0/14"
  service_cidr          = "172.30.0.0/16"
}

