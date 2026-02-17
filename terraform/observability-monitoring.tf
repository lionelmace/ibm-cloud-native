
##############################################################################
# Monitoring Services
##############################################################################


# Monitoring Variables
##############################################################################
variable "sysdig_plan" {
  description = "plan type"
  type        = string
  default     = "graduated-tier"
  # default     = "graduated-tier-sysdig-secure-plus-monitor"
}

variable "sysdig_service_endpoints" {
  description = "Only allow the value public-and-private. Previously it incorrectly allowed values of public and private however it is not possible to create public only or private only Cloud Monitoring instances."
  type        = string
  default     = "public-and-private"
}

variable "sysdig_private_endpoint" {
  description = "Add this option to connect to your Sysdig service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "sysdig_enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in Sysdig"
  default     = false
}

variable "sysdig_use_vpe" {
  default = true
}


# Monitoring Resource
##############################################################################

module "cloud_monitoring" {
  source = "terraform-ibm-modules/observability-instances/ibm//modules/cloud_monitoring"
  # version = "latest" # Replace "latest" with a release version to lock into a specific release

  resource_group_id       = ibm_resource_group.group.id
  instance_name           = format("%s-%s", local.basename, "monitoring")
  plan                    = var.sysdig_plan
  service_endpoints       = var.sysdig_service_endpoints
  enable_platform_metrics = var.sysdig_enable_platform_metrics
  region                  = var.region
  tags                    = var.tags
  manager_key_tags        = var.tags
}

output "cloud_monitoring_crn" {
  description = "The CRN of the Cloud Monitoring instance"
  value       = module.cloud_monitoring.crn
}

########################################################################################################################
# SCC WP (Workload Protection)
########################################################################################################################

module "scc_wp" {
  source = "terraform-ibm-modules/scc-workload-protection/ibm"
  # version = "latest" # Replace "latest" with a release version to lock into a specific release
  name                                         = format("%s-%s", local.basename, "workload-protection")
  region                                       = var.region
  resource_group_id                            = ibm_resource_group.group.id
  resource_tags                                = var.tags
  cloud_monitoring_instance_crn                = module.cloud_monitoring.crn
  scc_wp_service_plan                          = var.sysdig_plan
  cspm_enabled                                 = false
  app_config_crn                               = module.app_config.app_config_crn # Required if cspm_enabled is true.
  scc_workload_protection_trusted_profile_name = format("%s-%s", local.basename, "scc-wp-tp")
}

########################################################################################################################
# App Configuration
########################################################################################################################

# Create App Config instance
module "app_config" {
  source = "terraform-ibm-modules/app-configuration/ibm"
  # version           = "1.3.0"
  region                   = var.region
  resource_group_id        = ibm_resource_group.group.id
  app_config_name          = format("%s-%s", local.basename, "app-configuration")
  app_config_tags          = var.tags
  enable_config_aggregator = true # See https://cloud.ibm.com/docs/app-configuration?topic=app-configuration-ac-configuration-aggregator
  app_config_plan          = "basic"
  # The name to give the trusted profile that will be created if enable_config_aggregator is set to true.
  config_aggregator_trusted_profile_name = format("%s-%s", local.basename, "app-config-tp")
}

########################################################################################################################
# Monitoring Agents
########################################################################################################################

module "monitoring_agents" {
  source = "terraform-ibm-modules/monitoring-agent/ibm"
  # version = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  # cluster_id                = module.ocp_base.cluster_id
  cluster_id = ibm_container_vpc_cluster.roks_cluster.id
  # cluster_resource_group_id = module.resource_group.resource_group_id
  cluster_resource_group_id = ibm_resource_group.group.id
  is_vpc_cluster            = true
  access_key                = module.cloud_monitoring.access_key
  instance_region           = var.region
  # example of how to include / exclude metrics - more info https://cloud.ibm.com/docs/monitoring?topic=monitoring-change_kube_agent#change_kube_agent_log_metrics
  metrics_filter = [{ exclude = "metricA.*" }, { include = "metricB.*" }]
  # example of how to include / exclude container filter - more info https://cloud.ibm.com/docs/monitoring?topic=monitoring-change_kube_agent#change_kube_agent_filter_data
  container_filter = [{ type = "exclude", parameter = "kubernetes.namespace.name", name = "kube-system" }]
  # example of how to include / exclude container filter - more info https://cloud.ibm.com/docs/monitoring?topic=monitoring-change_kube_agent#change_kube_agent_block_ports
  blacklisted_ports = [22, 2379, 3306]
  # example of adding agent tag
  agent_tags = { "environment" : "test", "custom" : "value" }
  # example of setting agent mode to troubleshooting for additional metrics
  agent_mode = "troubleshooting"
}

## IAM
##############################################################################

resource "ibm_iam_access_group_policy" "iam-sysdig" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "sysdig-monitor"
    resource_group_id = ibm_resource_group.group.id
  }
}
