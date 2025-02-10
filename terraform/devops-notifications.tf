resource "ibm_resource_instance" "event-notifications" {
  name              = format("%s-%s", local.basename, "event-notifications")
  service           = "event-notifications"
  plan              = "lite"
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
}

# Authorization policy between Cloud Monitoring (Source) and Event Notifications (Target)
# Required to add a Notification Channel with Event Notification in Cloud Monitoring
resource "ibm_iam_authorization_policy" "iam-auth-monitoring-event" {
  source_service_name         = "sysdig-monitor"
  source_resource_instance_id = module.cloud_monitoring.guid
  target_service_name         = "event-notifications"
  target_resource_instance_id = ibm_resource_instance.event-notifications.guid
  roles                       = ["Reader", "Event Source Manager"]
}