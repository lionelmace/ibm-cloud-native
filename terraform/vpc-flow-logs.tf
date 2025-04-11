
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
  bucket_name          = format("%s-%s-%s", local.basename, "bucket-flow-logs", random_string.random.result)
  resource_instance_id = ibm_resource_instance.cos-flow-logs.id
  region_location      = var.region
  storage_class        = "standard"
}

resource "ibm_is_flow_log" "flowlog" {
  depends_on     = [ibm_cos_bucket.bucket-flow-logs]
  name           = format("%s-%s", local.basename, "flow-logs")
  target         = ibm_is_vpc.vpc.id
  active         = true
  storage_bucket = ibm_cos_bucket.bucket-flow-logs.bucket_name
}

resource "ibm_iam_authorization_policy" "iam-auth-flowlogs-cos" {
  source_service_name         = "is"
  source_resource_type        = "flow-log-collector"
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = ibm_resource_instance.cos-flow-logs.guid
  roles                       = ["Reader", "Writer"]
}