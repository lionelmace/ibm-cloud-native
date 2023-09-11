# Warning
# The first two connections are free at the account level not the gateway level. 
# So if you create 2 TGWs each with 2 connections you'd be charged for 2 connections, 
# and if you create a TGW with 2 connections, delete it, 
# and create again in the same month, you'd be charged for 2 connections.
# TGW exceeded 2 connections it'd get charged for those extra connections.

# resource "ibm_tg_gateway" "tgw" {
#   name           = format("%s-%s", local.basename, "tgw")
#   location       = "eu-de"
#   global         = false
#   resource_group = ibm_resource_group.group.id
# }

# resource "ibm_tg_connection" "tgw_connection" {
#   gateway      = ibm_tg_gateway.tgw.id
#   network_type = "vpc"
#   name         = "my-tgw-connection"
#   network_id   = ibm_is_vpc.vpc.crn
# }