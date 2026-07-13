##############################################################################
## Create a Secrets Manager instance or reuse an existing one
##############################################################################

variable "existing_secrets_manager_crn" {
  type        = string
  default     = null
  description = "The CRN of existing secrets manager to use to create service credential secrets for Databases for MongoDB instance."

  validation {
    condition = anytrue([
      var.existing_secrets_manager_crn == null,
      can(regex("^crn:v\\d:(.*:){2}secrets-manager:(.*:)([aos]\\/[\\w_\\-]+):[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.existing_secrets_manager_crn))
    ])
    error_message = "The value provided for 'existing_secrets_manager_crn' is not valid."
  }
}

resource "ibm_resource_instance" "secrets_manager" {
  count             = var.existing_secrets_manager_crn != "" ? 0 : 1
  name              = format("%s-%s", local.basename, "secrets-manager")
  service           = "secrets-manager"
  plan              = "trial"
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags
  service_endpoints = "public-and-private"
}

data "ibm_resource_instance" "secrets_manager" {
  count       = var.existing_secrets_manager_crn != "" ? 1 : 0
  identifier  = var.existing_secrets_manager_crn
}

locals {
  secrets_manager_id   = var.existing_secrets_manager_crn != "" ? data.ibm_resource_instance.secrets_manager.0.id : ibm_resource_instance.secrets_manager.0.id
  secrets_manager_guid = var.existing_secrets_manager_crn != "" ? data.ibm_resource_instance.secrets_manager.0.guid : ibm_resource_instance.secrets_manager.0.guid
  secrets_manager_region = var.existing_secrets_manager_crn != "" ? data.ibm_resource_instance.secrets_manager[0].location : var.region
}

output "secrets_manager_id" {
  value = local.secrets_manager_id
}