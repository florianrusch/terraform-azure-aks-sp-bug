provider "azurerm" {
  version = "1.32.1"
  skip_provider_registration = true
}

provider "azuread" {
  version = "0.5.1"
}

###########################################################################
# VARIABLES
###########################################################################
variable "resource_group_name" {
  type        = "string"
  description = "(Required) Name of the azure resource group."
}

variable "cluster_name" {
  type        = "string"
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "kubernetes_version" {
  type        = "string"
  default     = "1.12.7"
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
}

variable "location" {
  type        = "string"
  default     = "West Europe"
  description = "The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
}

variable "agent_pool_count" {
  type        = "string"
  default     = "1"
  description = "Number of Agents (VMs) in the Pool. Possible values must be in the range of 1 to 100 (inclusive)."
}

variable "agent_size" {
  type        = "string"
  default     = "Standard_D2s_v3"
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
}

variable "client_secret" {
  type        = "string"
  description = "(Required) The Password for this Service Principal."
}

variable "end_date" {
  type        = "string"
  default     = "2099-01-01T00:00:00Z"
  description = "The End Date which the Password is valid until, formatted as a RFC3339 date string (e.g. 2018-01-01T01:02:03Z). Changing this field forces a new resource to be created."
}


###########################################################################
# RESOURCES
###########################################################################
resource "azuread_application" "sp" {
  name                       = "${var.cluster_name}"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_application_password" "sp" {
  application_id = "${azuread_application.sp.id}"
  value          = "${var.client_secret}"
  end_date       = "${var.end_date}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = "${var.kubernetes_version}"

  agent_pool_profile {
    name           = "default"
    count          = "${var.agent_pool_count}"
    vm_size        = "${var.agent_size}"
  }

  service_principal {
    client_id     = "${azuread_application.sp.application_id}"
    client_secret = "${var.client_secret}"
  }

  depends_on = ["azuread_application.sp", "azuread_application_password.sp"]
}
