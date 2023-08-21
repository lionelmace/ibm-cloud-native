resource "ibm_iam_access_group" "accgrp" {
  name = format("%s-%s", local.basename, "ag")
  tags = var.tags
}

# Visibility on the Resource Group
resource "ibm_iam_access_group_policy" "iam-rg-viewer" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.group.id
  }
}

# Create a policy to all Kubernetes instances within the Resource Group
resource "ibm_iam_access_group_policy" "policy-k8s" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = ibm_resource_group.group.id
  }
}


# SERVICE ID
# Equivalent to CLI commands in this tutorial
# https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-tutorial-kubernetes-secrets#tutorial-external-kubernetes-secrets-access
# resource "ibm_iam_service_id" "kubernetes-secrets" {
#   name        = "kubernetes-secrets"
#   description = "A service ID for testing Secrets Manager and Kubernetes Service."
#   tags        = var.tags
# }

# resource "ibm_iam_service_policy" "secrets-policy" {
#   iam_service_id = ibm_iam_service_id.kubernetes-secrets.id
#   roles          = ["SecretsReader"]

#   resources {
#     service              = "secrets-manager"
#     resource_instance_id = ibm_iam_service_id.kubernetes-secrets.id
#   }
# }

# resource "ibm_iam_service_api_key" "secrets_apikey" {
#   name           = "secrets_apikey"
#   description    = "An API key for testing Secrets Manager."
#   iam_service_id = ibm_iam_service_id.kubernetes-secrets.iam_id
# }


# AUTHORIZATIONS
##############################################################################

# Authorization policy between OpenShift and Secrets Manager
# resource "ibm_iam_authorization_policy" "roks-sm" {
#   source_service_name         = "containers-kubernetes"
#   source_resource_instance_id = module.vpc_openshift_cluster.vpc_openshift_cluster_id
#   target_service_name         = "secrets-manager"
#   target_resource_instance_id = ibm_resource_instance.secrets-manager.guid
#   roles                       = ["Manager"]
# }

# Authorization policy between SCC (Source) and COS Bucket (Target)
# Requires by the new SCC to store SCC evaluation results into a COS bucket
resource "ibm_iam_authorization_policy" "iam-auth-scc-cos" {
  source_service_name         = "compliance"
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = ibm_resource_instance.cos.guid
  roles                       = ["Writer"]
}

