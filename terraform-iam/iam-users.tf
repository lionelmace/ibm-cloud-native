
variable "emails" {
  description = "List of Emails to invite"
  type        = list(string)
  default     = []
}

# Invite users to the Access Group
resource "ibm_iam_user_invite" "invite_user" {
  count = length(var.emails)

  users         = var.emails
  access_groups = [ibm_iam_access_group.ag-admin.id, ibm_iam_access_group.ag-admin-vpc.id]
}
