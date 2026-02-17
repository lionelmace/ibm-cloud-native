##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.13"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.88.2"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = "1.3.1"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "1.56.1"
    }
    # Required by SCC Workload Protection used in file observability-monitoring.tf
    restapi = {
      source  = "mastercard/restapi"
      version = ">= 2.0.1"
    }
  }
}

provider "http-full" {}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "kubernetes" {
  host                   = data.ibm_container_cluster_config.roks_cluster_config.host
  token                  = data.ibm_container_cluster_config.roks_cluster_config.token
  cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  load_config_file = false
}

provider "helm" {
  kubernetes = {
    host                   = data.ibm_container_cluster_config.roks_cluster_config.host
    token                  = data.ibm_container_cluster_config.roks_cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  }
  # No registry authentication required - using public registries
}

provider "sysdig" {
  sysdig_secure_url       = "https://eu-de.monitoring.cloud.ibm.com"
  sysdig_secure_api_token = var.ibmcloud_api_key
}
# Error: unexpected response code '404': 404 page not found
#  2026/02/17 10:06:10 Terraform apply | 
#  2026/02/17 10:06:10 Terraform apply | 
#  2026/02/17 10:06:10 Terraform apply |   with module.scc_wp.restapi_object.cspm,
#  2026/02/17 10:06:10 Terraform apply |   on .terraform/modules/scc_wp/main.tf line 156, in resource "restapi_object" "cspm":
#  2026/02/17 10:06:10 Terraform apply |  156: resource "restapi_object" "cspm" {

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

# Init cluster config for helm and kubernetes providers
############################################################################
data "ibm_container_cluster_config" "roks_cluster_config" {
  cluster_name_id   = ibm_container_vpc_cluster.roks_cluster.id
  resource_group_id = ibm_resource_group.group.id
  endpoint_type     = "private"
}