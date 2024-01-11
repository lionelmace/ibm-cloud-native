resource "ibm_cr_namespace" "container-registry-namespace" {
  name              = format("%s-%s", local.basename, "registry")
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags
}

output "icr-namespace" {
  value = ibm_cr_namespace.container-registry-namespace.crn
}

variable "icr_use_vpe" { default = true }

# VPE (Virtual Private Endpoint) for Container Registry
##############################################################################

resource "ibm_is_virtual_endpoint_gateway" "vpe_icr" {

  name           = "${local.basename}-icr-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = "crn:v1:bluemix:public:container-registry:${var.region}:::endpoint:${var.icr_region}"
    resource_type = "provider_cloud_service"
  }

  # one Reserved IP for per zone in the VPC
  dynamic "ips" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      subnet = ips.key
      name   = "${ips.value.name}-ip-icr"
    }
  }

  tags = var.tags
}

# variable "objects" {
#   type = "list"
#   description = "list of objects
#   default = [
#       {
#         id = "name1"
#         attribute = "a"
#       },
#       {
#         id = "name2"
#         attribute = "a,b"
#       },
#       {
#         id = "name3"
#         attribute = "d"
#       }
#   ]
# }
# var.objects[index(var.objects.*.id, "name2")]

data "ibm_is_endpoint_gateway_targets" "example" {
}

locals {
  resources = data.ibm_is_endpoint_gateway_targets.example.resources
  icr_map = var.resources[index(var.resources.*.name, "registry-eu-de-v2")]
#  my_value = lookup(data.ibm_is_endpoint_gateway_targets.example, "key1", "")
}

output "endpoint_gateway_target" {
  value = icr_map.crn
  # value = local.my_value
  # value = data.ibm_is_endpoint_gateway_targets.example
  # ${lookup(var.objects[1], "id")}
}

## IAM
##############################################################################
# Role Writer supports both Pull and Push
resource "ibm_iam_access_group_policy" "iam-registry" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer", "Writer"]

  resources {
    service           = "container-registry"
    resource_group_id = ibm_resource_group.group.id
    resource_type     = "namespace"
    resource          = ibm_cr_namespace.container-registry-namespace.name
  }
}