##############################################################################
## Global Variables
##############################################################################

#region     = "eu-de"     # eu-de for Frankfurt MZR
#icr_region = "de.icr.io"

##############################################################################
## VPC
##############################################################################
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true


##############################################################################
## Cluster IKS
##############################################################################
# iks_version               = "1.31.1"
iks_worker_nodes_per_zone = 1
iks_machine_flavor        = "bx2.4x16"
# iks_machine_flavor    = "bx2.16x64" # ODF or Portworx flavor

# Scale up   by adding a worker pool
# Scale down by setting the number of worker to Zero
create_secondary_iks_pool = false
# Uncomment to create worker pool
iks_worker_pools = [
  {
    pool_name        = "secondary"
    machine_type     = "bx2.4x16"
    workers_per_zone = 0
  }
]

# Possible values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
iks_wait_till          = "IngressReady"
iks_update_all_workers = true
# iks_worker_nodes_per_zone = 2


##############################################################################
## Cluster ROKS
##############################################################################
# Optional: Specify OpenShift version. If not included, 4.18 is used
openshift_version = ""
# openshift_os             = "REDHAT_8_64"
openshift_os             = "RHCOS"
openshift_machine_flavor = "bx2.4x16"
# openshift_machine_flavor = "bx2.16x64" # ODF Flavors
install_odf_addons = false

# Scale up   by adding a worker pool
# Scale down by setting the number of worker to Zero
# Uncomment to create worker pool
create_secondary_roks_pool = true
roks_worker_pools = [
  {
    pool_name        = "wpool-rhoai"
    machine_type     = "bx2.8x32"
    workers_per_zone = 1
  },
  # {
  #   pool_name        = "wpool-odf"
  #   machine_type     = "bx2.16x64"
  #   workers_per_zone = 1
  # },
  # {
  #   pool_name        = "default"
  #   machine_type     = "mx2.4x32"
  #   workers_per_zone = 1
  # }
]

openshift_disable_public_service_endpoint = false
# Secure By default - Public outbound access is blocked as of OpenShift 4.15
# Protect network traffic by enabling only the connectivity necessary 
# for the cluster to operate and preventing access to the public Internet.
# By default, value is false.
openshift_disable_outbound_traffic_protection = true

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"
openshift_update_all_workers = true

##############################################################################
## Secrets Manager
##############################################################################
existing_secrets_manager_name = "secrets-manager"

##############################################################################
## COS
##############################################################################
cos_plan   = "standard"
cos_region = "global"


##############################################################################
## Observability: Log Analysis (Mezmo) & Monitoring (Sysdig)
##############################################################################
# DEPRECATED (LMA)
# Available Plans: lite, 7-day, 14-day, 30-day
# log_plan                 = "7-day"
# log_enable_platform_logs = false

sysdig_plan                    = "graduated-tier"
sysdig_enable_platform_metrics = true


##############################################################################
## ICD Mongo
##############################################################################
# Available Plans: standard, enterprise
icd_mongo_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_mongo_adminpassword     = "AdministratorPassw0rd01"
icd_mongo_db_version        = "6.0"
icd_mongo_service_endpoints = "private"
icd_mongo_use_vpe           = true

# Minimum parameter for Enterprise Edition
# icd_mongo_ram_allocation = 14336
# icd_mongo_disk_allocation = 20480
# icd_mongo_core_allocation = 6

# Minimum parameter for Standard Edition
icd_mongo_ram_allocation  = 4096 # old value: 1024
icd_mongo_disk_allocation = 20480
icd_mongo_core_allocation = 0

icd_mongo_users = [{
  name     = "user123"
  password = "Password12"
}]

##############################################################################
## ICD Postgres
##############################################################################
# # Available Plans: standard, enterprise
# icd_postgres_plan = "standard"
# # expected length in the range (10 - 32) - must not contain special characters
# icd_postgres_adminpassword     = "Passw0rd01"
# icd_postgres_db_version        = "12"
# icd_postgres_service_endpoints = "public"

# # Minimum parameter for Standard Edition
# icd_postgres_ram_allocation  = 1024
# icd_postgres_disk_allocation = 20480
# icd_postgres_core_allocation = 0

# icd_postgres_users = [{
#   name     = "user123"
#   password = "password12"
# }]
