#!/bin/zsh
# Script to create a Salesforce scratch org and deploy source automatically

# Set default variables

ORG_ALIAS="MyScratchOrg"
DEV_HUB_ALIAS="devhub"
PERMSET="OpenAI_Agent_Admin"

# Create scratch org
sf org create scratch --definition-file config/project-scratch-def.json --alias $ORG_ALIAS --set-default --target-dev-hub $DEV_HUB_ALIAS

# Push source to scratch org
sf project deploy start --target-org $ORG_ALIAS

# Assign permission set
sf org assign permset --name $PERMSET --target-org $ORG_ALIAS

# Open the org
sf org open --target-org $ORG_ALIAS

echo "Scratch org created and source deployed."
