########################################################################################################################
# Backup & Recovery for IKS/ROKS with Data Source Connector
########################################################################################################################

variable "dsc_storage_class" {
  type        = string
  description = "Storage class to use for the Data Source Connector persistent volume. By default, it uses 'ibmc-vpc-block-metro-5iops-tier' for VPC clusters and 'ibmc-block-silver' for Classic clusters."
  default     = null
}

variable "existing_brs_instance_crn" {
  type        = string
  description = "CRN of an existing BRS instance to use. If not provided, a new instance will be created."
  default     = null
}

module "backup_recover_protect_ocp" {
  source                       = "terraform-ibm-modules/iks-ocp-backup-recovery/ibm"
  cluster_id                   = ibm_container_vpc_cluster.roks_cluster.id
  cluster_resource_group_id    = ibm_resource_group.group.id
  cluster_config_endpoint_type = "private"
  add_dsc_rules_to_cluster_sg  = false
  kube_type                    = "openshift"
  ibmcloud_api_key             = var.ibmcloud_api_key
  # enable_auto_protect is set to false to avoid issues when running terraform pipelines. in production, this should be set to true.
  enable_auto_protect = false
  # --- B&R Instance ---
  existing_brs_instance_crn = var.existing_brs_instance_crn
  brs_endpoint_type         = "public"
  brs_instance_name         = format("%s-%s", local.basename, "brs")
  brs_connection_name       = format("%s-%s", local.basename, "brs-connection-roks")
  brs_create_new_connection = true
  region                    = var.region
  connection_env_type       = "kRoksVpc"
  dsc_storage_class         = var.dsc_storage_class == null ? "ibmc-vpc-block-metro-5iops-tier" : var.dsc_storage_class
  # --- Backup Policy ---
  policy = {
    name = "${var.prefix}-retention"
    schedule = {
      unit      = "Minutes"
      frequency = 30
    }
    retention = {
      duration = 1
      unit     = "Days"
    }
    use_default_backup_target = true
  }
  access_tags   = var.tags
  resource_tags = var.tags
}