
##############################################################################
# Create a resource group or reuse an existing one
##############################################################################

data "ibm_resource_group" "group" {
  name = "icn-knkiir-group"
}

output "resource_group_name" {
  value = data.ibm_resource_group.group.name
}