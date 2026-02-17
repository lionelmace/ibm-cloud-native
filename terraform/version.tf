
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
      version = ">= 3.3.1, <4.0.0"
    }
    # Required by SCC Workload Protection used in file observability-monitoring.tf
    restapi = {
      source  = "mastercard/restapi"
      version = ">=2.0.1, <3.0.0"
    }
  }
}