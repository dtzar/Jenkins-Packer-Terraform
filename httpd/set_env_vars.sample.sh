#!/bin/bash

export AZURE_CLIENT_ID=
export AZURE_CLIENT_SECRET=
export AZURE_SUBSCRIPTION_ID=
export IMAGE_NAME=
export IMAGE_RESOURCE_GROUP_NAME=
export BUILD_RESOURCE_GROUP_NAME=

export TF_VAR_subscription_id=$AZURE_SUBSCRIPTION_ID
export TF_VAR_tenant_id=
export TF_VAR_client_id=$AZURE_CLIENT_ID
export TF_VAR_client_secret=$AZURE_CLIENT_SECRET
