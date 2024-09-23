# ############################################################################
# Install observability agents
# ############################################################################

module "observability_agents" {
  source                           = "terraform-ibm-modules/observability-agents/ibm"
#   version                          = "1.2.4"
  is_vpc_cluster                   = true
  cluster_id                       = ibm_container_vpc_cluster.roks_cluster.id
  cluster_resource_group_id        = ibm_container_vpc_cluster.roks_cluster.id
}