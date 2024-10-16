
## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_instance" {
  name        = format("%s-%s", local.basename, "cis")
  depends_on  = [ibm_scc_instance_settings.scc_instance_settings]
  profile_id  = "48279384-3d29-4089-8259-8ed354774b4a" # CIS IBM Foundations v1.1.0
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
    parameter_name         = "tls_version"
    parameter_display_name = "IBM Cloud Internet Services TLS version"
    parameter_type         = "string_list"
    parameter_value        = "['1.2', '1.3']"
    assessment_type        = "automated"
    assessment_id          = "rule-e16fcfea-fe21-4d30-a721-423611481fea"
  }
  attachment_parameters {
    parameter_name         = "ssh_port"
    parameter_display_name = "Network ACL rule for allowed IPs to SSH port"
    parameter_type         = "numeric"
    parameter_value        = "22"
    assessment_type        = "automated"
    assessment_id          = "rule-f9137be8-2490-4afb-8cd5-a201cb167eb2"
  }
  attachment_parameters {
    parameter_name         = "rdp_port"
    parameter_display_name = "Security group rule RDP allow port number"
    parameter_type         = "numeric"
    parameter_value        = "3389"
    assessment_type        = "automated"
    assessment_id          = "rule-9653d2c7-6290-4128-a5a3-65487ba40370"
  }
  attachment_parameters {
    parameter_name         = "ssh_port"
    parameter_display_name = "Security group rule SSH allow port number"
    parameter_type         = "numeric"
    parameter_value        = "22"
    assessment_type        = "automated"
    assessment_id          = "rule-7c5f6385-67e4-4edf-bec8-c722558b2dec"
  }
  attachment_parameters {
    parameter_name         = "rdp_port"
    parameter_display_name = "Disallowed IPs for ingress to RDP port"
    parameter_type         = "numeric"
    parameter_value        = "3389"
    assessment_type        = "automated"
    assessment_id          = "rule-f1e80ee7-88d5-4bf2-b42f-c863bb24601c"
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

