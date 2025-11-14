#!/bin/sh
# Uncommment to verbose
# set -x 

source ./local.env

ibmcloud sch apply -i $WORKSPACE_ID