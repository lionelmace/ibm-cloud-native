#!/bin/sh
# Uncommment to verbose
# set -x 

source ./local.env

# Export the terraform state to a json file
ibmcloud sch state list --id $WORKSPACE_ID > state-list.txt