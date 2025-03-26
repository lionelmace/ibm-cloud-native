##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.9"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.76.3"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = "1.3.1"
    }
    # kubectl = {
    #   source = "gavinbunney/kubectl"
    # }
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
  # config_path = "~/.kube/config" # Path to your kubeconfig file
  # config_context = "your-context" # Optional: specify the kube context
}

provider "helm" {
  alias = "backup-pvc"
  kubernetes {
    # config_path = try(data.ibm_container_cluster_config.roks_cluster_config.config_file_path, "")
    host                   = data.ibm_container_cluster_config.roks_cluster_config.host
    token                  = data.ibm_container_cluster_config.roks_cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  }
}

# Helm to install IBM Cloud Logs
##############################################################################
provider "helm" {
  # alias = "logs"
  kubernetes {
    host                   = data.ibm_container_cluster_config.roks_cluster_config.host
    token                  = data.ibm_container_cluster_config.roks_cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  }
  # IBM Cloud credentials are required to authenticate to the helm repo
  registry {
    url      = "oci://icr.io/ibm/observe/logs-agent-helm"
    username = "iamapikey"
    password = var.ibmcloud_api_key
  }
}

# Module Logs Agent requires kubectl in the background, not available in Terraform Cloud
##############################################################################
# WARNING local-exec is not supported by Terraform Cloud
# resource "null_resource" "install_kubectl" {
#   # download kubectl
#   provisioner "local-exec" {
#     command = <<EOT
#     curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#     chmod +x kubectl
#     mkdir -p $HOME/bin
#     mv kubectl $HOME/bin/kubectl
#     echo "$HOME/bin" >> $GITHUB_PATH
#     EOT
#   }
# }

# OR

# provider "kubectl" {}
# provider "kubectl" {
#   host                   = data.ibm_container_cluster_config.roks_cluster_config.host
#   token                  = data.ibm_container_cluster_config.roks_cluster_config.token
#   cluster_ca_certificate = base64decode(data.ibm_container_cluster_config.roks_cluster_config.ca_certificate)
#   load_config_file       = false
# }
##############################################################################

# Init cluster config for helm
############################################################################
data "ibm_container_cluster_config" "roks_cluster_config" {
  # update this value with the cluster ID where these agents will be provisioned
  cluster_name_id   = ibm_container_vpc_cluster.roks_cluster.id
  resource_group_id = ibm_resource_group.group.id
}
