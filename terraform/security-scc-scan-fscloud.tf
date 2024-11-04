

## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_fs" {
  name        = format("%s-%s", local.basename, "fs")
  depends_on  = [ibm_scc_instance_settings.scc_instance_settings]
  profile_id  = "fe96bd4d-9b37-40f2-b39f-a62760e326a3" # FS Cloud Profile v1.7.0
  instance_id = ibm_resource_instance.scc_instance.guid
  description = "scc-profile-attachment"
  scope {
    environment = "ibm-cloud"
    properties {
      name = "scope_id"
      # value = local.account_id
      value = ibm_resource_group.group.id
    }
    properties {
      name = "scope_type"
      # value = "account"
      value = "account.resource_group"
    }
    # properties {
    #   name = "exclusions"
    #   value = []
    # }
  }
  schedule = "daily"
  status   = "enabled"
  notifications {
    enabled = false
    controls {
      failed_control_ids = []
      threshold_limit    = 14
    }
  }

  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-b5675539-fb0a-4464-93a3-f9c3ab1da0f8"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-466f9d3c-6e3c-4e2a-aa53-d6120018da83"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-61878b48-e181-455d-aed3-5730b6e27890"
  }
  attachment_parameters {
    parameter_name         = "cos_allowed_ip_list"
    parameter_display_name = "Allowed IPs(CBR or Firewall)"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-61878b48-e181-455d-aed3-5730b6e27890"
  }
  attachment_parameters {
    parameter_name         = "allowed_ip"
    parameter_display_name = "IP allowlist for COS"
    parameter_type         = "ip_list"
    parameter_value        = "['192.168.1.0/24']"
    assessment_type        = "automated"
    assessment_id          = "rule-3027fd86-72c5-4c81-8ccd-ff556a922ec1"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-78c2061b-b8fd-43ca-862f-582ab911c800"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-15e9118b-2fd4-46a7-a454-7af07b2b342c"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-7937a8fd-a7ba-4c03-89ad-09726eb30c59"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-5c9aed4a-af5e-47e0-8a86-cac8199aa90d"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-554328f0-188f-4d1c-a088-f20f77248a32"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-94ca1725-f251-4cee-8c4c-280e141f194a"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-08a4e6b2-45f7-456e-a9a9-0010ed2f72a3"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-4554e868-eb89-4b18-8692-564da18e0c2d"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-4554e868-eb89-4b18-8692-564da18e0c2d"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-94242843-07b4-496b-ac86-540aed2f74da"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-65627941-63ee-4f52-9248-3b5a09163965"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-c0d4d0e2-f014-46fa-9be1-8c03e59b443b"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-0ffd34a1-3ca7-4d53-adbe-40f3980694e6"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-0ffd34a1-3ca7-4d53-adbe-40f3980694e6"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-9090851b-2577-4b2d-b790-d7c97a75681e"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-00882b45-ee37-4dc1-b948-afa618755fbd"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-00882b45-ee37-4dc1-b948-afa618755fbd"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-7ce216fc-90ee-4f61-8f3b-70d00321fe97"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-8e7fd3c6-01aa-47b8-9898-ba34ebc27015"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-7e7c09f6-fc69-4a9c-9282-5d04c4eef96b"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-a534cbfa-1d2b-4b10-b405-7d6a0a969944"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-f88e215f-bb33-4bd8-bd1c-d8a065e9aa70"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-6b80be89-7c9f-472f-9ad2-363086fbcc86"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-8c0d2fba-9f40-41ca-aad2-d65df81d4390"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-a6843b59-7e8b-4e5f-8f45-fe98a28269e2"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-0f5956af-a27b-41b4-a0ba-2a5f7c241361"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-c5642f67-fb2c-4fe1-aed1-585d9215808f"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-466c09e7-f7d5-47e5-a4b1-d89d0cb7b847"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-fce897fe-d572-4412-9c74-828bfab0c26a"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-052e91d0-75be-46a8-9b95-dc6e72c78580"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-4736fc5d-63e2-4673-92e5-4c1f381645f5"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-af947fb3-f91d-4019-949e-ee25a3a441a7"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-5593b5b5-dd27-45c9-b088-b40e447af5ef"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-e3981f0e-89f1-44c2-bf3c-05c280f3c93c"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-ed883cda-bdd3-48fd-972b-bf98b085423b"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-18717f44-e8ed-4224-9e28-e8a0a2181766"
  }
  attachment_parameters {
    parameter_name         = "vm_nic_count"
    parameter_display_name = "IBM Cloud Network Interfaces count"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-c0314fad-f377-465e-9f16-fa5aa3d5ebbe"
  }
  attachment_parameters {
    parameter_name         = "exclude_floating_ip_list"
    parameter_display_name = "Exclude exclude the IP spoofing"
    parameter_type         = "string_list"
    parameter_value        = "['my_f5_server']"
    assessment_type        = "automated"
    assessment_id          = "rule-7cf9deab-b418-4374-9e10-a13d217166bb"
  }
  attachment_parameters {
    parameter_name         = "exclude_ip_spoofing_check"
    parameter_display_name = "Exclude interfaces with IP-spoofing from VPC"
    parameter_type         = "string_list"
    parameter_value        = "['vm-qa-automation-prod']"
    assessment_type        = "automated"
    assessment_id          = "rule-898ff49d-1979-4b70-9a79-d303c88dea63"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-b6b7e67f-e7c2-4435-a883-80ab3d835d0e"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-454c9e3f-1441-4214-acb8-0c74980a1d75"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-dce07761-8ffd-4beb-a7cc-d38a17fffd4e"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-bd17ba0b-d749-445f-9f8e-d0aa076bf575"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-7cbf96ea-a032-4bc0-aae7-21d088965ef4"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-d271f870-ceee-4c7b-80cd-afa656d91345"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-b96fdad1-c2d5-4399-861f-49adecfd3485"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-97595caa-f691-41f3-991f-b06222b9ff8d"
  }
  attachment_parameters {
    parameter_name         = "exclude_load_balancers"
    parameter_display_name = "Exclude Application Load Balancers that have public access"
    parameter_type         = "string_list"
    parameter_value        = "['public-access-load-balancer', 'public-access-edge-node-load-balancer']"
    assessment_type        = "automated"
    assessment_id          = "rule-ce6dff83-7280-4d25-a032-e5ff893e2fce"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-10b28c5d-27aa-4d03-b863-2e770090df74"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-6fd901b9-879a-4894-bda5-ed40fbe99730"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-9a64c779-5744-4bcc-a5ac-e4ad04b0f59c"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-eeba25ca-0084-4b84-9979-ef8477942df7"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-fdabbd31-1b00-4a84-aca2-6c57e8404b9e"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-e32c033a-0d2b-4477-8129-01ec758281e3"
  }
  attachment_parameters {
    parameter_name         = "public_gateway_permitted_zones"
    parameter_display_name = "IBM Cloud Public Gateway permitted zones"
    parameter_type         = "string_list"
    parameter_value        = "['us-south-1', 'us-south-2', 'us-south-3', 'us-east-1', 'us-east-2', 'us-east-3', 'au-syd-1', 'au-syd-2', 'au-syd-3', 'eu-de-1', 'eu-de-2', 'eu-de-3', 'eu-gb-1', 'eu-gb-2']"
    assessment_type        = "automated"
    assessment_id          = "rule-d42bbc4b-932f-4ffe-9b2b-8d64fe9cf63f"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-7758e8eb-c4d8-42a8-869f-30e3c189f6fa"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-134ad94f-186c-410f-a97b-4d739627b881"
  }
  attachment_parameters {
    parameter_name         = "dns_port"
    parameter_display_name = "Security group rule for allowed port numbers to DNS"
    parameter_type         = "numeric"
    parameter_value        = "53"
    assessment_type        = "automated"
    assessment_id          = "rule-0f7e7e60-a05c-43a7-be74-70615f14a342"
  }
  attachment_parameters {
    parameter_name         = "inbound_allowed_list"
    parameter_display_name = "Enter the IP/CIDR list allowed for VPC inbound"
    parameter_type         = "ip_list"
    parameter_value        = "['0.0.0.0/0']"
    assessment_type        = "automated"
    assessment_id          = "rule-28271605-31bb-4efa-b0ef-5f51adc77d90"
  }
  attachment_parameters {
    parameter_name         = "outbound_allowed_list"
    parameter_display_name = "Enter the IP/CIDR list allowed for VPC Outbound"
    parameter_type         = "ip_list"
    parameter_value        = "['0.0.0.0/0']"
    assessment_type        = "automated"
    assessment_id          = "rule-c981bedc-1526-448c-836c-10b0e3a2b812"
  }
  attachment_parameters {
    parameter_name         = "exclude_security_groups"
    parameter_display_name = "Exclude the security groups"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-a1fff3f6-6428-4ad4-9be2-2171ce09fb8f"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-2b0fc034-063b-47a7-86e9-5a96c8ca9f23"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-628cf4f7-1b07-472b-8162-ea95b9335397"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-af1c19bb-a40e-4798-92ad-57d4e9d540ba"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-9d6236c6-6549-4722-b8ed-ef3f998396b2"
  }
  attachment_parameters {
    parameter_name         = "excluded_subnets"
    parameter_display_name = "Subnet(s) name"
    parameter_type         = "string_list"
    parameter_value        = "['dummy-subnet-1', 'dummy-subnet-2']"
    assessment_type        = "automated"
    assessment_id          = "rule-c92a1ac3-6f9a-4fb1-9cb8-57d312679020"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-8b014ee6-2fcf-4e78-9412-d290251ff2a1"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-2c129d6e-61b4-43cb-8dc0-81cb553afec3"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-3d843573-0a71-44cc-926a-330fbcf80ec6"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-7566b2cb-eb91-43b3-a661-154cf08664dc"
  }
  attachment_parameters {
    parameter_name         = "exclude_vpcs"
    parameter_display_name = "Exclude the VPCs"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-6d60f511-20a9-4489-b9b5-447504b7a836"
  }
  attachment_parameters {
    parameter_name         = "exclude_vpcs"
    parameter_display_name = "Exclude the VPCs"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-64c0bea0-8760-4a6b-a56c-ee375a48961e"
  }
  attachment_parameters {
    parameter_name         = "number_of_vpcs"
    parameter_display_name = "At least one VPC created"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-857646d8-23b8-4495-82a4-295ab399266e"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-29286737-f65b-41fb-8ba7-30e81f0f9dd8"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-cbfa30f4-f766-468d-a539-b83e3ce8901e"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-a4cc268c-9c97-4dbb-b02f-bf74d5a5aa93"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-821f0dd8-8516-45e0-bdde-17c726573d44"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-9d0ae8c0-7332-4b65-858c-56fe9875789f"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-38ed88e7-45b5-4c40-919a-5556796cf50e"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-23850407-cbf6-42cf-8985-f90b2c966d04"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-23850407-cbf6-42cf-8985-f90b2c966d04"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-7f249933-a745-462c-aa6b-fcde8fbba826"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-553bdee0-a3c4-4ff9-a2f2-7903cc98ca2f"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-e1a1fc17-59dc-4e1e-b303-6b5442048f31"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-21fd1a1e-7909-48a4-949a-ada1785a34cf"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-21fd1a1e-7909-48a4-949a-ada1785a34cf"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-a805aeea-8037-4a99-be6e-4537089922a7"
  }
  attachment_parameters {
    parameter_name         = "number_of_transit_gateways"
    parameter_display_name = "Number of transit gateways"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-8c28c15e-c38f-410a-a883-a5f22a839176"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-ca36ff5d-003b-4b21-b584-061a2ac5268a"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-83a7de4c-f63c-488b-b4ba-80bf8141cadd"
  }
  attachment_parameters {
    parameter_name         = "cbr_endpoints_allowed_ip_list"
    parameter_display_name = "IP allowlist for CBR"
    parameter_type         = "ip_list"
    parameter_value        = "['255.255.255.255/32']"
    assessment_type        = "automated"
    assessment_id          = "rule-e54063a9-379f-4cdf-a00c-2fd02c8d9eda"
  }
  attachment_parameters {
    parameter_name         = "netmask_bits_length"
    parameter_display_name = "Maximum length of netmask bit that is considered as wide flow"
    parameter_type         = "numeric"
    parameter_value        = "256"
    assessment_type        = "automated"
    assessment_id          = "rule-d1a21d53-67fe-4018-a670-f7a5840210ba"
  }
  attachment_parameters {
    parameter_name         = "lockout_policy_config_minutes"
    parameter_display_name = "Lockout duration policy setting in minutes"
    parameter_type         = "numeric"
    parameter_value        = "15"
    assessment_type        = "automated"
    assessment_id          = "rule-df5ef7fa-0ded-4f18-9555-02c399227693"
  }
  attachment_parameters {
    parameter_name         = "session_invalidation_in_seconds"
    parameter_display_name = "Sign out due to inactivity in seconds"
    parameter_type         = "numeric"
    parameter_value        = "7200"
    assessment_type        = "automated"
    assessment_id          = "rule-a637949b-7e51-46c4-afd4-b96619001bf1"
  }
  attachment_parameters {
    parameter_name         = "scan_interval_max"
    parameter_display_name = "Maximum number of days between vulnerability scans"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-51e15d43-3946-4898-b593-02e16a988d8e"
  }
  attachment_parameters {
    parameter_name         = "allowed_tool_integration_services"
    parameter_display_name = "List of allowed tool integration services for toolchains"
    parameter_type         = "string_list"
    parameter_value        = "['artifactory', 'customtool', 'draservicebroker', 'githubconsolidated', 'gitlab', 'hashicorpvault', 'hostedgit', 'keyprotect', 'pagerduty', 'pipeline', 'private_worker', 'saucelabs', 'secretsmanager', 'security_compliance', 'slack', 'sonarqube']"
    assessment_type        = "automated"
    assessment_id          = "rule-e208d1c0-8ede-49f0-b4a3-4da3da738733"
  }
  attachment_parameters {
    parameter_name         = "defined_images"
    parameter_display_name = "VPC provisioned from list of customer-defined images"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-709caded-75d6-4481-b9cd-de20851a9b19"
  }
  attachment_parameters {
    parameter_name         = "fs_cloud_regions"
    parameter_display_name = "Hyper Protect Crypto Services regions"
    parameter_type         = "string_list"
    parameter_value        = "['au-syd', 'br-sao', 'ca-tor', 'eu-de', 'eu-gb', 'jp-osa', 'jp-tok', 'us-east', 'us-south']"
    assessment_type        = "automated"
    assessment_id          = "rule-574143f9-befe-4da1-a15e-af9437ed9ae7"
  }
  attachment_parameters {
    parameter_name         = "worker_node_min_zones"
    parameter_display_name = "Minimum number of Worker node zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-88f25dca-0e62-43c1-939e-f6637d23847f"
  }
  attachment_parameters {
    parameter_name         = "number_of_direct_links"
    parameter_display_name = "Number of Direct Links"
    parameter_type         = "numeric"
    parameter_value        = "2"
    assessment_type        = "automated"
    assessment_id          = "rule-c0f15737-b451-44d0-a0b6-649013a155bc"
  }
  attachment_parameters {
    parameter_name         = "hpcs_crypto_units"
    parameter_display_name = "Number of IBM Cloud Hyper Protect Crypto Service units"
    parameter_type         = "string_list"
    parameter_value        = "['2', '3']"
    assessment_type        = "automated"
    assessment_id          = "rule-064d9004-8728-4988-b19a-1805710466f6"
  }
  attachment_parameters {
    parameter_name         = "loadbalancer_min_lb_zones"
    parameter_display_name = "Minimal number of loadbalancer zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-0be41446-a0e7-46fb-8cbb-37bf413e0286"
  }
  attachment_parameters {
    parameter_name         = "vpc_min_zones"
    parameter_display_name = "Minimum number of VPC zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-f47c1c7d-cead-4f21-aa71-4fe7a307ae9b"
  }
  attachment_parameters {
    parameter_name         = "no_pre_shared_key_characters"
    parameter_display_name = "Enough characters in pre-shared key"
    parameter_type         = "numeric"
    parameter_value        = "24"
    assessment_type        = "automated"
    assessment_id          = "rule-d8d13c3e-5ca0-46c5-a055-2475852c4ec6"
  }
  attachment_parameters {
    parameter_name         = "min_hours_change_password"
    parameter_display_name = "Mininum number of hours between App ID password changes"
    parameter_type         = "numeric"
    parameter_value        = "0"
    assessment_type        = "automated"
    assessment_id          = "rule-250c3e07-0d2d-48c6-9de6-cbf5ba0d22ed"
  }
  attachment_parameters {
    parameter_name         = "hpcs_rotation_policy"
    parameter_display_name = "Hyper Protect Crypto Services key rotation policy"
    parameter_type         = "string_list"
    parameter_value        = "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']"
    assessment_type        = "automated"
    assessment_id          = "rule-caf5e45d-ccc8-4e35-b124-e1b4c8bcab71"
  }
  attachment_parameters {
    parameter_name         = "arbitrary_secret_min_rotation_period"
    parameter_display_name = "Minimum rotation period of Secrets Manager arbitrary secrets"
    parameter_type         = "numeric"
    parameter_value        = "90"
    assessment_type        = "automated"
    assessment_id          = "rule-88ff070b-3a8d-4d66-a943-3b2fa28630ea"
  }
  attachment_parameters {
    parameter_name         = "user_credential_min_rotation_period"
    parameter_display_name = "Minimum rotation period of Secrets Manager user credentials"
    parameter_type         = "numeric"
    parameter_value        = "90"
    assessment_type        = "automated"
    assessment_id          = "rule-28e20137-3350-4d51-9abc-4dae8fee9e04"
  }
  attachment_parameters {
    parameter_name         = "access_tokens_expiration_minutes"
    parameter_display_name = "Expiration in minutes of App ID access tokens"
    parameter_type         = "numeric"
    parameter_value        = "120"
    assessment_type        = "automated"
    assessment_id          = "rule-91734f9f-b8ff-4bfd-afb3-db4f789ac38f"
  }
  attachment_parameters {
    parameter_name         = "session_expiration_in_seconds"
    parameter_display_name = "Session expiration in seconds for the account"
    parameter_type         = "numeric"
    parameter_value        = "86400"
    assessment_type        = "automated"
    assessment_id          = "rule-846058ff-dbf1-4ab6-864f-1be009618759"
  }
  attachment_parameters {
    parameter_name         = "diffie_hellman_group"
    parameter_display_name = "Diffie-Hellman group number set"
    parameter_type         = "numeric"
    parameter_value        = "14"
    assessment_type        = "automated"
    assessment_id          = "rule-a8a69cd6-a902-4144-b652-8be68600a029"
  }
  attachment_parameters {
    parameter_name         = "exclude_default_security_groups"
    parameter_display_name = "Exclude the default security groups"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-96527f89-1867-4581-b923-1400e04661e0"
  }
}
