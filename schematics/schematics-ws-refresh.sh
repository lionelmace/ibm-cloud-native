#!/bin/sh
# Uncommment to verbose
# set -x 

source ./local.env

ibmcloud sch refresh -i $WORKSPACE_ID