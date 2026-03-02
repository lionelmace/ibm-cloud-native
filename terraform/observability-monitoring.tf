
##############################################################################
# Monitoring Services
##############################################################################


# Monitoring Variables
##############################################################################
variable "sysdig_plan" {
  description = "plan type"
  type        = string
  default     = "graduated-tier"
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
# App Config with config aggregator enabled
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
# SCC Workload Protection with CSPM enabled
########################################################################################################################

module "scc_wp" {
  source = "terraform-ibm-modules/scc-workload-protection/ibm"
  # version = "1.17.6"
  # version = "latest" # Replace "latest" with a release version to lock into a specific release
  name                                         = format("%s-%s", local.basename, "workload-protection")
  region                                       = var.region
  resource_group_id                            = ibm_resource_group.group.id
  resource_tags                                = var.tags
  cloud_monitoring_instance_crn                = module.cloud_monitoring.crn
  scc_wp_service_plan                          = var.sysdig_plan
  cspm_enabled                                 = true
  app_config_crn                               = module.app_config.app_config_crn # Required if cspm_enabled is true.
  scc_workload_protection_trusted_profile_name = format("%s-%s", local.basename, "scc-wp-tp")
}

########################################################################################################################
# SCC WP Zone (https://cloud.ibm.com/docs/workload-protection?topic=workload-protection-posture-zones)
# - create a new zone which only contains FedRAMP policies
########################################################################################################################

# # lookup all posture policies
# data "sysdig_secure_posture_policies" "all" {
#   # explicit depends_on required as data lookup can only occur after SCC-WP instance has been created
#   depends_on = [module.scc_wp]
# }

# # extract out all FSCloud/DORA/PCI policies
# # locals {
# #   fedramp_policies = [
# #     for p in data.sysdig_secure_posture_policies.all.policies :
# #     p if length(regexall(".*FedRAMP.*", p.name)) > 0
# #   ]
# # }
# locals {
#   # Match any of these in the policy name (case-insensitive)
#   posture_framework_regex = "(?i)(FSCloud|DORA|PCI[- ]?DSS)"

#   selected_policies = [
#     for p in data.sysdig_secure_posture_policies.all.policies :
#     p if length(regexall(local.posture_framework_regex, p.name)) > 0
#   ]
# }

# # Create a new zone and add the selected policies to it
# resource "sysdig_secure_posture_zone" "example" {
#   name        = "${var.prefix}-zone"
#   description = "Zone description"
#   # policy_ids  = [for p in local.fedramp_policies : p.id]
#   policy_ids  = [for p in local.selected_policies : p.id]

#   # you can use a scope to only target a set of sub-accounts by uncommenting the below code and updating the account IDs

#   # scopes {
#   #   scope {
#   #     target_type = "ibm"
#   #     rules       = "account in (\"nbac0df06b644a9cabc6e44f55b3880h\", \"5f9af00a96104f49b6509aa715f9d6a4\")"
#   #   }
#   # }
# }

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
