# ############################################################################
# Install observability agents
# ############################################################################

# Cloud Logs Not supported yet.
# module "observability_agents" {
#   source                    = "terraform-ibm-modules/observability-agents/ibm"
#   is_vpc_cluster            = true
#   cluster_id                = ibm_container_vpc_cluster.roks_cluster.id
#   cluster_resource_group_id = ibm_resource_group.group.id
#   log_analysis_enabled      = false
#   cloud_monitoring_enabled  = false
# }