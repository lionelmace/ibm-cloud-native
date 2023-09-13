
variable "emails" {
  description = "List of Emails to invite"
  type        = list(string)
  default     = []
}

# Invite users to the Access Group
resource "ibm_iam_user_invite" "invite_user" {
  users         = var.emails
  depends_on    = [ibm_iam_access_group.accgrp]
}
