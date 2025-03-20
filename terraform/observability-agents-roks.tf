# ############################################################################
# Install observability agents
# ############################################################################

##############################################################################
# Trusted Profile
##############################################################################

locals {
  logs_agent_namespace = "ibm-observe"
  logs_agent_name      = "logs-agent"
}


module "trusted_profile" {
  source                      = "terraform-ibm-modules/trusted-profile/ibm"
  version                     = "2.0.1"
  trusted_profile_name        = "${var.prefix}-profile"
  trusted_profile_description = "Logs agent Trusted Profile"
  # As a `Sender`, you can send logs to your IBM Cloud Logs service instance - but not query or tail logs. This role is meant to be used by agents and routers sending logs.
  trusted_profile_policies = [{
    roles = ["Sender"]
    resources = [{
      service = "logs"
    }]
  }]
  # Set up fine-grained authorization for `logs-agent` running in ROKS cluster in `ibm-observe` namespace.
  trusted_profile_links = [{
    cr_type = "ROKS_SA"
    links = [{
      #LMA crn       = module.ocp_base.cluster_crn
      crn       = ibm_container_vpc_cluster.roks_cluster.id
      namespace = local.logs_agent_namespace
      name      = local.logs_agent_name
    }]
    }
  ]
}

# VPE for Cloud logs in the provisioned VPC which allows the agents 
# to access the private Cloud Logs Ingress endpoint.
##############################################################################
module "vpe" {
  source   = "terraform-ibm-modules/vpe-gateway/ibm"
  version  = "4.3.0"
  region   = var.region
  prefix   = var.prefix
  vpc_id   = ibm_is_vpc.vpc.id
  #LMA vpc_name = "${var.prefix}-vpc"
  subnet_zone_list = local.subnet_zone_list
  resource_group_id  = module.resource_group.resource_group_id
  security_group_ids = [for group in data.ibm_is_security_groups.vpc_security_groups.security_groups : group.id if group.name == "kube-${module.ocp_base.cluster_id}"] # Select only security group attached to the Cluster
  cloud_service_by_crn = [
    {
      crn          = module.observability_instances.cloud_logs_crn
      service_name = "logs"
    }
  ]
  service_endpoints = "private"
}


# Observability Agents
##############################################################################

module "observability_agents" {
  source                    = "terraform-ibm-modules/observability-agents/ibm"
  depends_on                = [module.vpe]
  #LMA cluster_id                = module.ocp_base.cluster_id
  cluster_id                = ibm_container_vpc_cluster.roks_cluster.id
  #LMA cluster_resource_group_id = module.resource_group.resource_group_id
  cluster_resource_group_id = ibm_resource_group.group.id
  # Cloud Logs agent
  logs_agent_trusted_profile  = module.trusted_profile.trusted_profile.id
  logs_agent_namespace        = local.logs_agent_namespace
  logs_agent_name             = local.logs_agent_name
  cloud_logs_ingress_endpoint = module.observability_instances.cloud_logs_ingress_private_endpoint
  cloud_logs_ingress_port     = 443
  # example of how to add additional metadata to the logs agents
  logs_agent_additional_metadata = [{
    key   = "cluster_id"
    value = module.ocp_base.cluster_id
  }]
  # example of how to add additional log source path
  logs_agent_additional_log_source_paths = ["/logs/*.log"]
  
  # Monitoring agent
  cloud_monitoring_access_key = module.observability_instances.cloud_monitoring_access_key
  # example of how to include / exclude metrics - more info https://cloud.ibm.com/docs/monitoring?topic=monitoring-change_kube_agent#change_kube_agent_log_metrics
  cloud_monitoring_metrics_filter   = [{ type = "exclude", name = "metricA.*" }, { type = "include", name = "metricB.*" }]
  cloud_monitoring_container_filter = [{ type = "exclude", parameter = "kubernetes.namespace.name", name = "kube-system" }]
  cloud_monitoring_agent_tags       = var.resource_tags
  cloud_monitoring_instance_region  = module.observability_instances.region
}