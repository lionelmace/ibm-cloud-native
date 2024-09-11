# Activity Tracker Event Routing and Targets
##############################################################################

resource "ibm_atracker_route" "atracker_route_de" {
  name = format("%s-%s", local.basename, "at-route")
  rules {
    target_ids = [ibm_atracker_target.at_logs_target.id, ibm_atracker_target.at_mezmo_target.id]
    locations  = [var.region, "global"]
  }
  lifecycle {
    # Recommended to ensure that if a target ID is removed here and destroyed in a plan, this is updated first
    create_before_destroy = true
  }
  depends_on = [ibm_iam_authorization_policy.iam-auth-atracker-2-logs]
}

resource "ibm_atracker_target" "at_logs_target" {
  cloudlogs_endpoint {
    target_crn = ibm_resource_instance.logs_instance.id
  }
  name        = format("%s-%s", local.basename, "at-logs-target")
  target_type = "cloud_logs"
  region      = var.region
}

# Activity Tracker (Mezmo) Target
resource "ibm_atracker_target" "at_mezmo_target" {
  logdna_endpoint {
    target_crn    = local.activity_tracker_id
    ingestion_key = ibm_resource_key.at_key.credentials.ingestion_key
  }
  name        = format("%s-%s", local.basename, "at-mezmo-target")
  target_type = "logdna"
  region      = var.region
}