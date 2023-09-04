
resource "ibm_tg_gateway" "tgw" {
  name           = format("%s-%s", local.basename, "tgw")
  location       = "eu-de"
  global         = false
  resource_group = ibm_resource_group.group.id
}

resource "ibm_tg_connection" "tgw_connection" {
  gateway      = ibm_tg_gateway.tgw.id
  network_type = "vpc"
  name         = "my-tgw-connection"
  network_id   = ibm_is_vpc.vpc.crn
}