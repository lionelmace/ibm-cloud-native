# Delete a resource from the state (Delete the resource in the console first!)
ibmcloud sch workspace state rm --i $WORKSPACE_ID  --address "ibm_logs_router_tenant.logs_router_tenant_instance_de"
ibmcloud sch workspace state rm --i $WORKSPACE_ID  --address "ibm_resource_instance.scc_instance"
ibmcloud sch workspace state rm --i $WORKSPACE_ID  --address "ibm_scc_instance_settings.scc_instance_settings"

# Get logs for a job
ibmcloud sch job logs --id 762620939f475ee3cb3bd1587d9a685c --target 


##############################################################################

# remove only the invite resource from state
ibmcloud sch workspace state rm --id $WORKSPACE_ID --address "ibm_iam_user_invite.invite_vmware_users"
# re-apply only this resource (avoids touching others)
ibmcloud sch apply --id $WORKSPACE_ID --target ibm_iam_user_invite.invite_vmware_users

##############################################################################