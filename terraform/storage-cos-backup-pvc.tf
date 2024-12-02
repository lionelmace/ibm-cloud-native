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

output "cos-backkup-credentials" {
  value = local.backup-endpoints
}

# Store your IBM COS credentials in a Kubernetes secret.
resource "kubernetes_secret" "cos_write_access" {
  metadata {
    name      = "cos-write-access"
    namespace = "default"
  }

  data = {
    "access-key" = base64encode(local.backup-endpoints.cos_access_key_id)
    "secret-key" = base64encode(local.backup-endpoints.cos_secret_access_key)
  }

  type = "ibm/ibmc-s3fs"
}