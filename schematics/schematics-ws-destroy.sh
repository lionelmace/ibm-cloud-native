#!/bin/sh
# Uncommment to verbose
# set -x 

source ./local.env

ibmcloud sch destroy -i $WORKSPACE_ID