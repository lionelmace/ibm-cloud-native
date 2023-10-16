
variable "vpn_client_ip_pool" {
  default = "192.168.0.0/16"
}

resource "ibm_is_vpn_server" "vpn" {
  # LMA certificate_crn = data.terraform_remote_state.certificates.outputs.server_cert_crn
  certificate_crn = ibm_sm_imported_certificate.server_cert.crn
  client_authentication {
    method        = "certificate"
    # LMA client_ca_crn = data.terraform_remote_state.certificates.outputs.client_cert_crn
    client_ca_crn = ibm_sm_imported_certificate.client_cert.crn
  }
  client_ip_pool         = var.vpn_client_ip_pool
  client_idle_timeout    = 2800
  enable_split_tunneling = true
  name                   = "${local.basename}-vpn-server"
  port                   = 443
  protocol               = "udp"
  subnets = [
    ibm_is_subnet.subnet[0].id, ibm_is_subnet.subnet[1].id
    # ibm_is_subnet.subnet.id
  ]
  security_groups = [
    ibm_is_security_group.vpn.id
  ]
  resource_group = ibm_resource_group.group.id
}

resource "ibm_is_security_group" "vpn" {
  resource_group = ibm_resource_group.group.id
  name           = "${local.basename}-vpn-group"
  vpc            = ibm_is_vpc.vpc.id
}

resource "ibm_is_security_group_rule" "vpn_inbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "inbound"
  udp {
    port_min = 443
    port_max = 443
  }
}

# allow clients to use SSH to connect to hosts in the cloud
resource "ibm_is_security_group_rule" "vpn_ssh_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

# allow clients to use SSH to ping
resource "ibm_is_security_group_rule" "vpn_icmp_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  icmp {
    type = 8
    code = 0
  }
}

# allow clients to reach cloud service endpoints
resource "ibm_is_security_group_rule" "vpn_cse_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = "166.9.0.0/16"
}

resource "ibm_is_vpn_server_route" "route_cse_to_vpc" {
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "deliver"
  destination = "166.9.0.0/16"
}

# allow clients to reach private backend
resource "ibm_is_security_group_rule" "vpn_private_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = "161.26.0.0/16"
}

resource "ibm_is_vpn_server_route" "route_private_to_vpc" {
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "deliver"
  destination = "161.26.0.0/16"
}

data "ibm_is_vpn_server_client_configuration" "config" {
  vpn_server = ibm_is_vpn_server.vpn.id
  file_path  = "../config/client.ovpn"
}

output "full-ovpn-config" {
  value = <<EOT
${data.ibm_is_vpn_server_client_configuration.config.vpn_server_client_configuration}

<cert>
${module.pki.certificates["client"].cert.cert_pem}
</cert>

<key>
${module.pki.certificates["client"].private_key.private_key_pem}
</key>
EOT
}

# resource "local_file" "fullconfig" {
#   content  = <<EOT
# ${data.ibm_is_vpn_server_client_configuration.config.vpn_server_client_configuration}

# <cert>
# ${output.client_cert}
# </cert>

# <key>
# ${output.client_key}
# </key>
# EOT
#   filename = "../config/client-full.ovpn"
# }

output "vpn" {
  value = ibm_is_vpn_server.vpn
}
