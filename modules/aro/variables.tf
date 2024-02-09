variable "azuread_application" {
  description = "The Azure application name"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ARO cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the ARO cluster"
  type        = string
}

variable "pull_secret" {
  description = "The pull secret for the cluster"
  default     = null
  type        = string
}

variable "fips_enabled" {
  description = "Whether Federal Information Processing Standard (FIPS) validated cryptographic modules are used."
  default     = false
  type        = string
}

variable "outbound_type" {
  description = "The outbound (egress) routing method. Possible values are Loadbalancer and UserDefinedRouting."
  default     = null
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the ARO cluster"
  type        = string
}

variable "vnet" {
  description = "The name of the VNET for the ARO cluster"
  type        = string
}

variable "pod_cidr" {
  description = "The CIDR range for the pod network"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR range for the service network"
  type        = string
}

variable "api_server_visibility" {
  description = "Cluster API server visibility. Supported values are Public and Private"
  type        = string
}

variable "ingress_visibility" {
  description = "Cluster Ingress visibility. Supported values are Public and Private. Defaults to Public"
  type        = string
}

variable "main_profile_vm_size" {
  description = "The size of the Virtual Machines for the main nodes."
  default     = "Standard_D8s_v3"
  type        = string
}

variable "main_profile_encryption_at_host_enabled" {
  description = "Whether main virtual machines are encrypted at host."
  default     = false
  type        = bool
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default = null
  type = map(string)
  }

variable "worker_profile_vm_size" {
  description = "The size of the Virtual Machines for the worker nodes."
  default     = "Standard_D4s_v3"
  type        = string
}

variable "worker_profile_disk_size_gb" {
  description = "The internal OS disk size of the worker Virtual Machines in GB."
  default     = "128"
  type        = string
}

variable "worker_profile_node_count" {
  description = "The initial number of worker nodes which should exist in the cluster."
  default     = "3"
  type        = string
}

variable "worker_profile_encryption_at_host_enabled" {
  description = "Whether main virtual machines are encrypted at host."
  default     = false
  type        = bool
}

variable "virtual_network_cidr" {
  type        = string
  default     = "10.0.0.0/22"
  description = "CIDR range for virtual network"
}

variable "main_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/23"
  description = "CIDR range for control plane subnet"
}

variable "worker_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/23"
  description = "CIDR range for worker subnet"
}