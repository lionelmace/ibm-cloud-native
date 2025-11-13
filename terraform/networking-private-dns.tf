# Private DNS Instance
##############################################################################

resource "ibm_resource_instance" "pdns-instance" {
  name              = "${local.basename}-pdns"
  resource_group_id = ibm_resource_group.group.id
  location          = "global"
  service           = "dns-svcs"
  plan              = "standard-dns"
}

# DNS Zone
##############################################################################

resource "ibm_dns_zone" "pdns-zone-1" {
  name = "${local.basename}.local"
  instance_id = ibm_resource_instance.pdns-instance.guid
}

resource "ibm_dns_resource_record" "pdns-a-record" {
  instance_id = ibm_resource_instance.pdns-instance.guid
  zone_id     = ibm_dns_zone.pdns-zone-1.zone_id
  type        = "A"
  name        = "nlb-zone-1"
  rdata       = "10.243.1.8" # Private IP of my private NLB
  ttl         = 900
}

resource "ibm_dns_permitted_network" "pdns-permitted-network" {
    instance_id = ibm_resource_instance.pdns-instance.guid
    zone_id = ibm_dns_zone.pdns-zone-1.zone_id
    vpc_crn = ibm_is_vpc.vpc.crn
    type = "vpc"
}

# GLB
##############################################################################

resource "ibm_dns_glb" "pdns-glb" {
  depends_on    = [ibm_dns_glb_pool.pool-nlb-1]
  name          = "${local.basename}-nlb-glb"
  instance_id   = ibm_resource_instance.pdns-instance.guid
  zone_id       = ibm_dns_zone.pdns-zone-1.zone_id
  ttl           = 120
  enabled       = true
  fallback_pool = ibm_dns_glb_pool.pool-nlb-1.pool_id
  default_pools = [ibm_dns_glb_pool.pool-nlb-1.pool_id]
  az_pools {
    availability_zone = "${var.region}-1"
    pools             = [ibm_dns_glb_pool.pool-nlb-1.pool_id]
  }
}

resource "ibm_dns_glb_pool" "pool-nlb-1" {
  depends_on                = [ibm_dns_zone.pdns-zone-1]
  name                      = "testpool"
  instance_id               = ibm_resource_instance.pdns-instance.guid
  enabled                   = true
  healthy_origins_threshold = 1
  origins {
    name        = "example-1"
    address     = "www.google.com"
    enabled     = true
    description = "origin pool"
  }
  monitor              = ibm_dns_glb_monitor.pdns-zone-1-monitor.monitor_id
  notification_channel = "https://mywebsite.com/dns/webhook"
  healthcheck_region   = var.region
  # Option 1 – single subnet:
  healthcheck_subnets = [ibm_is_subnet.subnet[1].id]
  # Option 2 – all three workload subnets:
  # healthcheck_subnets = [
  #   for s in ibm_is_subnet.subnet : s.crn
  # ]
}

resource "ibm_dns_glb_monitor" "pdns-zone-1-monitor" {
  depends_on     = [ibm_dns_zone.pdns-zone-1]
  name           = "${local.basename}-pdns-glb-monitor"
  instance_id    = ibm_resource_instance.pdns-instance.guid
  interval       = 63
  retries        = 3
  timeout        = 8
  port           = 8080
  type           = "HTTP"
  expected_codes = "200"
  path           = "/health"
  method         = "GET"
  expected_body  = "alive"
  headers {
    name  = "headerName"
    value = ["example", "abc"]
  }
}