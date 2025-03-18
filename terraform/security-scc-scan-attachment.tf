## SCC Scope
##############################################################################
resource "ibm_scc_scope" "scc_account_scope" {
  description = "Allow a profile attachment to target an IBM account"
  environment = "ibm-cloud"
  instance_id = ibm_resource_instance.scc_instance.guid
  name        = "Account Scope"
  properties = {
    scope_id   = local.account_id
    scope_type = "account"
  }
}

resource "ibm_scc_scope" "scc_group_scope" {
  description = "Allow a profile attachment to target a Resource Group"
  environment = "ibm-cloud"
  instance_id = ibm_resource_instance.scc_instance.guid
  name        = "Account Scope"
  properties = {
    scope_id   = ibm_resource_group.group.id
    scope_type = "account.resource_group"
  }
}

## SCC Profile Attachment
##############################################################################

module "create_profile_attachment_fs" {
  source                 = "terraform-ibm-modules/scc/ibm//modules/attachment"
  profile_name           = "IBM Cloud Framework for Financial Services"
  profile_version        = "latest"
  scc_instance_id        = ibm_resource_instance.scc_instance.guid
  attachment_name        = format("%s-%s", local.basename, "attachment-fs")
  attachment_description = "profile-attachment-description"
  attachment_schedule    = "daily"
  # scope the attachment to a specific resource group
  scope_ids = [ibm_scc_scope.scc_group_scope.scope_id]
  # scope = [{
  #   environment = "ibm-cloud"
  #   properties = [
  #     {
  #       name  = "scope_type"
  #       value = "account.resource_group"
  #     },
  #     {
  #       name  = "scope_id"
  #       value = ibm_resource_group.group.id
  #     }
  #   ]
  # }]
  depends_on = [
    ibm_scc_instance_settings.scc_instance_settings
  ]
}

module "create_profile_attachment_cis" {
  source                 = "terraform-ibm-modules/scc/ibm//modules/attachment"
  profile_name           = "CIS IBM Cloud Foundations Benchmark v1.1.0"
  profile_version        = "latest"
  scc_instance_id        = ibm_resource_instance.scc_instance.guid
  attachment_name        = format("%s-%s", local.basename, "attachment-cis")
  attachment_description = "profile-attachment-description"
  attachment_schedule    = "daily"
  # scope the attachment to the account
  scope_ids = [ibm_scc_scope.scc_account_scope.scope_id]
  # scope = [{
  #   environment = "ibm-cloud"
  #   properties = [
  #     {
  #       name  = "scope_type"
  #       value = "account"
  #     },
  #     {
  #       name  = "scope_id"
  #       value = local.account_id
  #     }
  #   ]
  # }]
  depends_on = [
    ibm_scc_instance_settings.scc_instance_settings
  ]
}

