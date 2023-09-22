# Create Access Group
resource "ibm_iam_access_group" "ag-admin" {
  name = format("%s-%s", local.basename, "ag-admin")
  tags = var.tags
}

# Service: All Identity and Access enabled services
# Role: Administrator, Manager
resource "ibm_iam_access_group_policy" "policy-all-iam-services" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles = [ "Administrator", "Manager", "Reader", "Viewer", "Editor" ]
}


# Service: All Account Management Services - Role: Administrator
resource "ibm_iam_access_group_policy" "policy-account-management" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles           = ["Administrator"]
  account_management = true
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

# Service: Support Center - Role: Editor
resource "ibm_iam_access_group_policy" "policy-admin-support" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles = [ "Editor" ]
  resources {
    service = "support"
  }
}

# Service: Security & Compliance Center - Role: Administrator, Editor
resource "ibm_iam_access_group_policy" "policy-admin-scc" {
  access_group_id = ibm_iam_access_group.ag-admin.id
  roles = [ "Administrator", "Editor" ]
  resources {
    service = "compliance"
  }
}

# # Create a policy to all Kubernetes/OpenShift clusters within the Resource Group
# ##############################################################################
# resource "ibm_iam_access_group_policy" "policy-k8s" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer", "Administrator"]

#   resources {
#     service = "containers-kubernetes"
#   }
# }

# # Service: IAM Identity Service
# ##############################################################################
# # Assign Administrator platform access role to enable the creation of API Key
# # Pre-Req to provision IKS/ROKS clusters
# resource "ibm_iam_access_group_policy" "policy-k8s-identity-administrator" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Administrator", "User API key creator", "Service ID creator"]

#   resources {
#     service = "iam-identity"
#   }
# }

# ## IAM Container Registry
# ##############################################################################
# # Role Writer supports both Pull and Push
# resource "ibm_iam_access_group_policy" "iam-registry" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Viewer", "Writer"]

#   resources {
#     service = "container-registry"
#   }
# }

# ## ICD Mongo
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-mongo" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Editor"]

#   resources {
#     service = "databases-for-mongodb"
#   }
# }

# ## IAM DevOps
# ##############################################################################
# # DevOps - Continuous Delivery
# resource "ibm_iam_access_group_policy" "iam-continuous-delivery" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer"]

#   resources {
#     service = "continuous-delivery"
#   }
# }

# # DevOps - Toolchain
# resource "ibm_iam_access_group_policy" "iam-toolchain" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Editor", "Operator", "Viewer"]

#   resources {
#     service = "toolchain"
#   }
# }

# ## IAM Log Analysis
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-log-analysis" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Manager", "Viewer", "Standard Member"]

#   resources {
#     service = "logdna"
#   }
# }

# ## IAM Monitoring
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-sysdig" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Writer", "Editor"]

#   resources {
#     service = "sysdig-monitor"
#   }
# }

# ## IAM Key Protect
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-kms" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Reader", "Viewer"]

#   resources {
#     service = "kms"
#   }
# }

# ## IAM Secrets Manager
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-sm" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Reader", "Viewer"]

#   resources {
#     service = "secrets-manager"
#   }
# }

# ## IAM Activity Tracker
# ##############################################################################
# resource "ibm_iam_access_group_policy" "iam-at" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Reader", "Viewer"]

#   resources {
#     service = "logdnaat"
#   }
# }

# ## IAM CBR Context Based Restrictions
# ##############################################################################

# resource "ibm_iam_access_group_policy" "iam-cbr" {
#   access_group_id = ibm_iam_access_group.ag-admin.id
#   roles           = ["Editor"]

#   resources {
#     service = "context-based-restrictions"
#   }
# }