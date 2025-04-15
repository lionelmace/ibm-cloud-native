
##############################################################################
# SCC Workload Protection
##############################################################################


# Workload Protection Instance
##############################################################################

resource "ibm_resource_instance" "wp_instance" {
  resource_group_id = ibm_resource_group.group.id
  name              = format("%s-%s", local.basename, "workload-protection")
  service           = "sysdig-secure"
  plan              = "graduated-tier"
  location          = var.region
  tags              = var.tags
  service_endpoints = "private"
#   depends_on = [ibm_iam_authorization_policy.cloud-logs-cos]
}
