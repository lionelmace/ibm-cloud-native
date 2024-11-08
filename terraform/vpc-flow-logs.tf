
## VPC Flow Logs
##############################################################################

resource "ibm_resource_instance" "cos-flow-logs" {
  name              = format("%s-%s", local.basename, "cos-flow-logs")
  resource_group_id = ibm_resource_group.group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cos_bucket" "bucket-flow-logs" {
  bucket_name          = format("%s-%s", local.basename, "bucket-flow-logs")
  resource_instance_id = ibm_resource_instance.cos-flow-logs.id
  region_location      = var.region
  storage_class        = "standard"
}

resource "ibm_is_flow_log" "example" {
  depends_on     = [ibm_cos_bucket.bucket-flow-logs]
  name           = format("%s-%s", local.basename, "flow-logs")
  target         = ibm_is_vpc.vpc.id
  active         = true
  storage_bucket = ibm_cos_bucket.bucket-flow-logs.bucket_name
  # depends_on = [ibm_iam_authorization_policy.iam-auth-flowlogs-cos]
}

resource "ibm_iam_authorization_policy" "iam-auth-flowlogs-cos" {
  source_service_name         = "is"
  source_resource_type        = "flow-log-collector"
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = ibm_resource_instance.cos-flow-logs.guid
  roles                       = ["Reader", "Writer"]
}

# ID:                        4a4bc075-cafc-4143-b1fd-baee962d7143
# Source service name:       is
# Source service instance:   All instances
# Source resource type:      flow-log-collector
# Target service name:       cloud-object-storage
# Target service instance:   f18612b6-f80f-43db-ac80-5a945047f64c
# Roles:                     Reader, Writer