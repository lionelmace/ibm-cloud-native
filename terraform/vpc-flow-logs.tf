
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
}