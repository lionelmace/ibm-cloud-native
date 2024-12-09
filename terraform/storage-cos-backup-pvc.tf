##############################################################################
# COS Instance with 1 bucket
# 
# Source:
# https://cloud.ibm.com/docs/containers?topic=containers-utilities#ibmcloud-backup-restore
##############################################################################

# COS to backup PVC
##############################################################################

resource "ibm_resource_instance" "cos-backup" {
  name              = format("%s-%s", local.basename, "cos-backup")
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  parameters = {
    service-endpoints = "private"
  }
}

## COS Bucket for PVC Backup
##############################################################################
resource "ibm_cos_bucket" "backup-bucket" {
  bucket_name          = format("%s-%s", local.basename, "cos-bucket-backup")
  resource_instance_id = ibm_resource_instance.cos-backup.id
  storage_class        = "smart"

  cross_region_location = "eu"
  endpoint_type         = "public"
#   endpoint_type = "private"
}

## HMAC Service Credentials
##############################################################################
resource "ibm_resource_key" "cos-hmac-backup" {
  name                 = format("%s-%s", local.basename, "cos-backup-key")
  resource_instance_id = ibm_resource_instance.cos-backup.id
  role                 = "Writer"
  parameters           = { HMAC = true }
}

locals {
  backup-endpoints = [
    {
      name                  = "backup",
      cos_access_key_id     = nonsensitive(ibm_resource_key.cos-hmac-backup.credentials["cos_hmac_keys.access_key_id"])
      cos_secret_access_key = nonsensitive(ibm_resource_key.cos-hmac-backup.credentials["cos_hmac_keys.secret_access_key"])
      cos_endpoint          = ibm_cos_bucket.backup-bucket.s3_endpoint_direct
      cos_bucket_name       = ibm_cos_bucket.backup-bucket.bucket_name
    }
  ]
}

output "cos-backup-credentials" {
  value = local.backup-endpoints
}

# Store your IBM COS credentials in a Kubernetes secret.
##############################################################################
resource "kubernetes_secret" "cos_write_access" {
  metadata {
    name      = "cos-write-access"
    namespace = "default"
  }
  data = {
    "access-key" = base64encode(local.backup-endpoints[0].cos_access_key_id)
    "secret-key" = base64encode(local.backup-endpoints[0].cos_secret_access_key)
  }
  type = "ibm/ibmc-s3fs"
  depends_on = [ibm_container_vpc_cluster.roks_cluster, ibm_resource_key.cos-hmac-backup]
}

# Backup Restore Helm chart to back up data in file/block storage PVC to COS
##############################################################################
resource "helm_release" "backup-pvc" {
  name       = "my-backup-pvc"
  # chart      = "ibmcloud-backup-restore"
  chart       = "https://icr.io/helm/iks-charts/ibmcloud-backup-restore"
  # chart       = "oci://icr.io/iks-charts/ibmcloud-backup-restore"
  # repository = "icr.io/iks-charts/ibmcloud-backup-restore"
  version = "1.0.10"
  namespace  = "default"

  # Optional: Set values inline (overrides values.yaml if conflicts exist)
  set {
    name  = "pullPolicy"
    value = "Always"
  }
  set {
    name  = "tag"
    value = "latest"
  }

  # Dynamically reference backup-endpoints
  dynamic "set" {
    for_each = {
      cos_access_key_id     = local.backup-endpoints[0].cos_access_key_id
      cos_secret_access_key = local.backup-endpoints[0].cos_secret_access_key
      cos_endpoint          = local.backup-endpoints[0].cos_endpoint
      cos_bucket_name       = local.backup-endpoints[0].cos_bucket_name
    }

    content {
      name  = set.key
      value = set.value
    }
  }

  # Additional sets
  set {
    name  = "my_first_pvc_backup"
    value = "latest"
  }
  set {
    name  = "PVC_NAMES"
    value = "latest"
  }
}