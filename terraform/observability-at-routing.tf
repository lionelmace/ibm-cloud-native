# Failed
# resource "ibm_atracker_target" "atracker_cloudlogs_target" {
#   cloudlogs_endpoint {
#     target_crn = ibm_resource_instance.logs_instance.id
#   }
#   name = "my-cloudlogs-target"
#   target_type = "cloud_logs"
#   region = "eu-de"
# }

# resource "ibm_atracker_route" "atracker_route" {
#   name = "my-route"
#   rules {
#     target_ids = [ ibm_atracker_target.atracker_cloudlogs_target.id ]
#     locations = [ "eu-de", "global" ]
#   }
#   lifecycle {
#     # Recommended to ensure that if a target ID is removed here and destroyed in a plan, this is updated first
#     create_before_destroy = true
#   }
# }