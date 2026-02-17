##############################################################################
# IBM Cloud Provider
##############################################################################

provider "http-full" {}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "kubernetes" {
  host                   = data.ibm_container_cluster_config.roks_cluster_config.host
  token                  = data.ibm_container_cluster_config.roks_cluster_config.token
  cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  load_config_file       = false
}

provider "helm" {
  kubernetes = {
    host                   = data.ibm_container_cluster_config.roks_cluster_config.host
    token                  = data.ibm_container_cluster_config.roks_cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  }
  # No registry authentication required - using public registries
}

data "ibm_iam_auth_token" "auth_token" {}

# Required by SCC Workload Protection used in file observability-monitoring.tf
provider "restapi" {
  # see https://cloud.ibm.com/apidocs/resource-controller/resource-controller#endpoint-url for full list of available resource controller endpoints
  uri = "https://resource-controller.cloud.ibm.com"
  headers = {
    Authorization = data.ibm_iam_auth_token.auth_token.iam_access_token
  }
  write_returns_object = true
}

provider "sysdig" {
  sysdig_secure_team_name = "Secure Operations"
  sysdig_secure_url       = "https://${var.region}.monitoring.cloud.ibm.com"
  ibm_secure_iam_url      = "https://iam.cloud.ibm.com"
  ibm_secure_instance_id  = module.scc_wp.guid
  ibm_secure_api_key      = var.ibmcloud_api_key
}

# Init cluster config for helm and kubernetes providers
############################################################################
data "ibm_container_cluster_config" "roks_cluster_config" {
  cluster_name_id   = ibm_container_vpc_cluster.roks_cluster.id
  resource_group_id = ibm_resource_group.group.id
  endpoint_type     = "private"
}