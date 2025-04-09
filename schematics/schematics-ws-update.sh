export WORKSPACE_ID=eu-de.workspace.itz-cp-emea-automation.2ff50127
export TEMPLATE=`ibmcloud sch workspace get --id $WORKSPACE_ID --output json | jq -jr '.template_data[] | .id'`
export TOKEN=$(ibmcloud iam oauth-tokens | awk '{print $4}')
curl --insecure -X 'PUT' 'https://eu.schematics.cloud.ibm.com/v1/workspaces/'$WORKSPACE_ID -H 'Authorization: bearer '$TOKEN --header 'Content-Type: application/json' -d @schematics-ws-update.json | jq  .