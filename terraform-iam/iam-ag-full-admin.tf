# Create Access Group
resource "ibm_iam_access_group" "ag-admin" {
  name = format("%s-%s", local.basename, "ag-full-admin")
  tags = var.tags
}

# Service: All Identity and Access enabled services
# Role: Administrator, Manager
resource "ibm_iam_access_group_policy" "policy-all-iam-services" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  resource_attributes {
    name     = "serviceType"
    operator = "stringEquals"
    value    = "service"
  }
  roles = ["Administrator", "Manager"]
}


# Service: All Account Management Services
# Role: Administrator
resource "ibm_iam_access_group_policy" "policy-account-management" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles           = ["Administrator"]
  resource_attributes {
    name     = "serviceType"
    operator = "stringEquals"
    value    = "platform_service"
  }
}

# Service: Resource Group only
# Enables to create RG 
resource "ibm_iam_access_group_policy" "policy-resource-group" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles           = ["Viewer", "Reader", "Editor"]
  resources {
    resource_type = "resource-group"
  }
}

# Service: Support Center
# Role: Editor
resource "ibm_iam_access_group_policy" "policy-admin-support" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles           = ["Editor"]
  resources {
    service = "support"
  }
}

# Service: Security & Compliance Center
# Role: Administrator, Editor
resource "ibm_iam_access_group_policy" "policy-admin-scc" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles           = ["Administrator", "Editor"]
  resources {
    service = "compliance"
  }
}


# Service: IAM Identity Service
# Assign the role "User API key creator" to create API Key
# Pre-Req: IKS/ROKS must create an API key at cluster provisioning time
#resource "ibm_iam_access_group_policy" "policy-k8s-identity-administrator" {
#  access_group_id = ibm_iam_access_group.ag-admin.id
#  roles           = ["User API key creator"]
# roles           = ["Administrator", "User API key creator", "Service ID creator"]
#  resources {
#    service = "iam-identity"
#  }
#}
