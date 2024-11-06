

## SCC Profile Attachment
##############################################################################

module "create_profile_attachment" {
  source                 = "terraform-ibm-modules/scc/ibm//modules/attachment"
  profile_name           = "IBM Cloud Framework for Financial Services"
  profile_version        = "latest"
  scc_instance_id        = ibm_resource_instance.scc_instance.guid
  attachment_name        = format("%s-%s", local.basename, "attachment-fs")
  attachment_description = "profile-attachment-description"
  attachment_schedule    = "daily"
  # scope the attachment to a specific resource group
  scope = [{
    environment = "ibm-cloud"
    properties = [
      {
        name  = "scope_type"
        value = "account.resource_group"
      },
      {
        name  = "scope_id"
        value = ibm_resource_group.group.id
      }
    ]
  }]
}

