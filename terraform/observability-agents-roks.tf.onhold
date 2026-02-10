# ############################################################################
# Install Logs agents
# Source: https://github.com/terraform-ibm-modules/terraform-ibm-logs-agent
# ############################################################################

##############################################################################
# Trusted Profile
##############################################################################

locals {
  logs_agent_namespace = "ibm-observe"
  logs_agent_name      = "logs-agent"
}


module "trusted_profile" {
  source = "terraform-ibm-modules/trusted-profile/ibm"
  # version                     = "3.2.17"
  trusted_profile_name        = "${var.prefix}-profile"
  trusted_profile_description = "Logs agent Trusted Profile"
  # As a `Sender`, you can send logs to your IBM Cloud Logs service instance - but not query or tail logs. This role is meant to be used by agents and routers sending logs.
  trusted_profile_policies = [{
    roles = ["Sender"]
    unique_identifier = "logs-agent"
    resources = [{
      service = "logs"
    }]
  }]
  # Set up fine-grained authorization for `logs-agent` running in ROKS cluster in `ibm-observe` namespace.
  trusted_profile_links = [{
    cr_type = "ROKS_SA"
    unique_identifier = "logs-agent-link"
    links = [{
      #LMA crn       = module.ocp_base.cluster_crn
      crn       = ibm_container_vpc_cluster.roks_cluster.crn
      namespace = local.logs_agent_namespace
      name      = local.logs_agent_name
    }]
    }
  ]
}

data "ibm_is_security_groups" "vpc_security_groups" {
  #LMA depends_on = [module.ocp_base]
  depends_on = [ibm_container_vpc_cluster.roks_cluster]
  vpc_id     = ibm_is_vpc.vpc.id
}

# VPE for Cloud logs in the provisioned VPC which allows the agents 
# to access the private Cloud Logs Ingress endpoint.
##############################################################################
module "vpe" {
  source = "terraform-ibm-modules/vpe-gateway/ibm"
  # version = "4.5.0"
  region = var.region
  prefix = "vpe"
  vpc_id = ibm_is_vpc.vpc.id
  vpc_name         = ibm_is_vpc.vpc.name
  subnet_zone_list = local.subnet_zone_list
  #LMA resource_group_id  = module.resource_group.resource_group_id
  resource_group_id = ibm_resource_group.group.id
  # Select only security group attached to the Cluster
  #LMA security_group_ids = [for group in data.ibm_is_security_groups.vpc_security_groups.security_groups : group.id if group.name == "kube-${module.ocp_base.cluster_id}"] 
  security_group_ids = [for group in data.ibm_is_security_groups.vpc_security_groups.security_groups : group.id if group.name == "kube-${ibm_container_vpc_cluster.roks_cluster.id}"]
  cloud_service_by_crn = [
    {
      #LMA crn          = module.observability_instances.cloud_logs_crn
      crn          = ibm_resource_instance.logs_instance.id
      service_name = "logs"
    }
  ]
  service_endpoints = "private"
  depends_on        = [ibm_is_vpc.vpc, ibm_is_subnet.subnet]
}


# Observability Agents
##############################################################################
# DEPRECATED
# module "observability_agents" {
#   source     = "terraform-ibm-modules/observability-agents/ibm"
#   depends_on = [module.vpe]
#   #LMA cluster_id                = module.ocp_base.cluster_id
#   cluster_id = ibm_container_vpc_cluster.roks_cluster.id
#   #LMA cluster_resource_group_id = module.resource_group.resource_group_id
#   cluster_resource_group_id = ibm_resource_group.group.id
#   # Cloud Logs agent
#   logs_agent_trusted_profile = module.trusted_profile.trusted_profile.id
#   logs_agent_namespace       = local.logs_agent_namespace
#   logs_agent_name            = local.logs_agent_name
#   #LMA cloud_logs_ingress_endpoint = module.observability_instances.cloud_logs_ingress_private_endpoint
#   cloud_logs_ingress_endpoint = ibm_resource_instance.logs_instance.extensions.external_ingress_private
#   cloud_logs_ingress_port     = 443
#   # example of how to add additional metadata to the logs agents
#   logs_agent_additional_metadata = [{
#     key = "cluster_id"
#     #LMA value = module.ocp_base.cluster_id
#     value = ibm_container_vpc_cluster.roks_cluster.id
#   }]
#   # example of how to add additional log source path
#   logs_agent_additional_log_source_paths = ["/logs/*.log"]

#   # Monitoring agent
#   #LMA cloud_monitoring_access_key = module.observability_instances.cloud_monitoring_access_key
#   cloud_monitoring_access_key = module.cloud_monitoring.access_key
#   # example of how to include / exclude metrics - more info https://cloud.ibm.com/docs/monitoring?topic=monitoring-change_kube_agent#change_kube_agent_log_metrics
#   cloud_monitoring_metrics_filter   = [{ type = "exclude", name = "metricA.*" }, { type = "include", name = "metricB.*" }]
#   cloud_monitoring_container_filter = [{ type = "exclude", parameter = "kubernetes.namespace.name", name = "kube-system" }]
#   cloud_monitoring_agent_tags       = var.tags
#   #LMA cloud_monitoring_instance_region  = module.observability_instances.region
#   cloud_monitoring_instance_region = var.region
# }

##############################################################################
# Logs Agent
##############################################################################

module "logs_agent" {
  source                    = "terraform-ibm-modules/logs-agents/ibm"
  depends_on                = [module.vpe]
  cluster_id                = ibm_container_vpc_cluster.roks_cluster.id
  cluster_resource_group_id = ibm_resource_group.group.id # module.resource_group.resource_group_id
  # Logs agent
  logs_agent_trusted_profile_id = module.trusted_profile.trusted_profile.id
  logs_agent_namespace          = local.logs_agent_namespace
  logs_agent_name               = local.logs_agent_name
  cloud_logs_ingress_endpoint   = ibm_resource_instance.logs_instance.extensions.external_ingress_private # module.cloud_logs.ingress_private_endpoint
  storage_name                  = var.prefix
  cloud_logs_ingress_port       = 443
  # example of how to add additional metadata to the logs agent
  logs_agent_additional_metadata = [{
    key   = "cluster_id"
    # value = module.ocp_base.cluster_id
    value = ibm_container_vpc_cluster.roks_cluster.id
  }]
  logs_agent_resources = {
    limits = {
      cpu    = "500m"
      memory = "3Gi"
    }
    requests = {
      cpu    = "100m"
      memory = "1Gi"
    }
  }
  # example of how to add additional log source path
  logs_agent_system_logs = ["/logs/*.log"]
}