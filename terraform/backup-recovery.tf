
resource "ibm_resource_instance" "backup_recovery" {
  name              = format("%s-%s", local.basename, "brs")
  service           = "backup-recovery"
  plan              = "premium"
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags = var.tags
}

output "backup_recovery_id" {
  value = ibm_resource_instance.backup_recovery.id
}

output "backup_recovery_guid" {
  value = ibm_resource_instance.backup_recovery.guid
}

output "backup_recovery_crn" {
  value = ibm_resource_instance.backup_recovery.crn
}