#!/bin/bash

RESOURCE_GROUP_NAME=httpd-rg
REGION=eastus

# on rpm-based machines there is already a packer bin
# which is symlinked to cracklib-packer so for the sake
# of testing out a different bin name (this requires that
# on an rpm-based machine that the HashiCorp packer bin is
# symlinked to packer.io: `ln -s ~/bin/packer ~/bin/packer.io`)
PACKER_BIN=$(
    which packer | grep sbin > /dev/null 2> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "packer.io"
    else
        echo "packer"
    fi
)

create_resource_group() {
    RG_NAME=$1
    LOCATION=$2

    RG_OUTPUT_COUNT=$(az group show -n $RG_NAME | wc -l)

    if [[ $RG_OUTPUT_COUNT -eq 0 ]]; then
        echo $(date) " - resource group $RG_NAME does not exist, creating..."
        az group create -n $RG_NAME -l $LOCATION
    else
        echo $(date) " - resource group $RG_NAME already exists"
    fi
}

echo $(date) " - ensure resource group exists, create if it does not"
create_resource_group $RESOURCE_GROUP_NAME $REGION

echo $(date) " - validating Packer template"
$PACKER_BIN validate -var-file ./httpd_vars.json ./httpd.json
if [[ $? -eq 0 ]]; then
    echo $(date) " - Packer template is valid, continuing"
else
    echo $(date) " - invalid Packer template (see above for issues). Exiting..."
    exit 1
fi
