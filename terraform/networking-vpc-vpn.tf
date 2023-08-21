# Authorization policy between VPN and Secrets Manager
resource "ibm_iam_authorization_policy" "vpn-sm" {
  source_service_name         = "is"
  source_resource_type        = "vpn-server"
  target_service_name         = "secrets-manager"
  target_resource_instance_id = local.secrets_manager_id
  roles                       = ["SecretsReader"]
}