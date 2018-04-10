#!/usr/bin/env bash

set -eEu

source ../config/env.sh

#if [[ -z "$AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_SECRET" ]]; then
#  echo "AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_SECRET environment variable not set"
#  echo "export AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_SECRET='your service principal secret'"
#
#  exit 1
#fi
#
#IDENTIFIER_URI="http://ROOTAzureCPI-${azure_terraform_prefix}"
#DISPLAY_NAME="${azure_terraform_prefix}-Service Principal for PCF Subscription"
#
## ===============
## Create app and service principal
#
## check for existing app by identifier-uri
#AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_ID=$(
#    az ad app list \
#      --identifier-uri "${IDENTIFIER_URI}" \
#      | jq -r " .[] | .appId" )
#
#if [[ -z "$AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_ID" ]]; then
#    echo "Creating client ${DISPLAY_NAME}"
#    # create ROOT application client
#    AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_ID=$(
#        az ad app create \
#          --display-name "${DISPLAY_NAME}" \
#          --password "${AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_SECRET}" \
#          --homepage "${IDENTIFIER_URI}" \
#          --identifier-uris "${IDENTIFIER_URI}" \
#          | jq -r ".appId" )
#else
#    echo "...Skipping client ${DISPLAY_NAME}.  Already exists."
#fi
#
#SERVICE_PRINCIPAL_NAME=$(
#    az ad sp list --display-name "${DISPLAY_NAME}" | jq -r ".[] | .appId")
#
#if [[ -z "$SERVICE_PRINCIPAL_NAME" ]]; then
#    echo "Creating service principal ${DISPLAY_NAME}"
#    # create ROOT service principal
#    SERVICE_PRINCIPAL_NAME=$(
#        az ad sp create \
#          --id ${AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_ID} \
#          | jq -r ".appId" )
#else
#    echo "...Skipping service principal ${DISPLAY_NAME}.  Already exists."
#fi
#
#ROLE_ID=$(
#    az role assignment list \
#      --assignee ${SERVICE_PRINCIPAL_NAME} \
#      --role "Contributor" \
#      --scope /subscriptions/${azure_subscription_id} \
#      | jq -r ".[] | .id")
#
#if [[ -z "$ROLE_ID" ]]; then
#
#    echo "Applying Contributor access to ${DISPLAY_NAME}"
#    ROLE_ID=$(
#        az role assignment create \
#          --assignee "${SERVICE_PRINCIPAL_NAME}" \
#          --role "Contributor" \
#          --scope /subscriptions/${azure_subscription_id} \
#           | jq -r ".id")
#else
#    echo "...Skipping Contributor roll assignment ${DISPLAY_NAME}.  Already assigned."
#fi

# ===============
# Create app and service principal for the Network resource group

NET_IDENTIFIER_URI="http://NETWORKAzureCPI-${azure_terraform_prefix}"
NET_DISPLAY_NAME="${azure_terraform_prefix}-Service Principal for NETWORK"

# check for existing app by identifier-uri
AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID=$(
    az ad app list \
      --identifier-uri "${NET_IDENTIFIER_URI}" \
      | jq -r " .[] | .appId" )

if [[ -z "$AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID" ]]; then
    echo "Creating client ${NET_DISPLAY_NAME}"
    # create network application client
    AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID=$(
        az ad app create \
          --display-name "${NET_DISPLAY_NAME}" \
          --password "${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_SECRET}" \
          --homepage "${NET_IDENTIFIER_URI}" \
          --identifier-uris "${NET_IDENTIFIER_URI}" \
          | jq -r ".appId" )
else
    echo "...Skipping client ${NET_DISPLAY_NAME}.  Already exists."
fi

SERVICE_PRINCIPAL_NAME=$(
    az ad sp list --display-name "${NET_DISPLAY_NAME}" | jq -r ".[] | .appId")

if [[ -z "$SERVICE_PRINCIPAL_NAME" ]]; then
    echo "Creating service principal ${NET_DISPLAY_NAME}"
    # create network service principal
    SERVICE_PRINCIPAL_NAME=$(
        az ad sp create \
          --id ${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID} \
          | jq -r ".appId" )
else
    echo "...Skipping service principal ${NET_DISPLAY_NAME}.  Already exists."
fi

ROLE_ID=$(
    az role assignment list \
      --assignee ${SERVICE_PRINCIPAL_NAME} \
      --role "Contributor" \
      --scope /subscriptions/${azure_subscription_id} \
      | jq -r ".[] | .id")

if [[ -z "$ROLE_ID" ]]; then

    echo "Applying Contributor access to ${NET_DISPLAY_NAME} for Subscription"
    ROLE_ID=$(
        az role assignment create \
          --assignee "${SERVICE_PRINCIPAL_NAME}" \
          --role "Contributor" \
          --scope /subscriptions/${azure_subscription_id} \
           | jq -r ".id")
else
    echo "...Skipping Contributor roll assignment ${NET_DISPLAY_NAME}.  Already assigned."
fi


# ===============
# Create app and service principal for the BOSH/PCF resource group

BOSH_IDENTIFIER_URI="http://BOSHAzureCPI-${azure_terraform_prefix}"
BOSH_DISPLAY_NAME="${azure_terraform_prefix}-Service Principal for BOSH"

# check for existing app by identifier-uri
AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID=$(
    az ad app list \
      --identifier-uri "${BOSH_IDENTIFIER_URI}" \
      | jq -r " .[] | .appId" )

if [[ -z "$AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID" ]]; then
    echo "Creating client ${BOSH_DISPLAY_NAME}"
    # create BOSH application client
    AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID=$(
        az ad app create \
          --display-name "${BOSH_DISPLAY_NAME}" \
          --password "${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_SECRET}" \
          --homepage "${BOSH_IDENTIFIER_URI}" \
          --identifier-uris "${BOSH_IDENTIFIER_URI}" \
          | jq -r ".appId" )
else
    echo "...Skipping client ${BOSH_DISPLAY_NAME}.  Already exists."
fi

SERVICE_PRINCIPAL_NAME=$(
    az ad sp list --display-name "${BOSH_DISPLAY_NAME}" | jq -r ".[] | .appId")

if [[ -z "$SERVICE_PRINCIPAL_NAME" ]]; then
    echo "Creating service principal ${BOSH_DISPLAY_NAME}"
    # create BOSH service principal
    SERVICE_PRINCIPAL_NAME=$(
        az ad sp create \
          --id ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID} \
          | jq -r ".appId" )
else
    echo "...Skipping service principal ${BOSH_DISPLAY_NAME}.  Already exists."
fi


echo
echo "Populate pcf-pipelines/install-pcf/azuer/params.yml with these values:"
echo
#echo "# ROOT Service Principal for Subscription"
#echo "azure_root_service_principal_client_id: ${AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_ID}"
#echo "azure_root_service_principal_client_secret: ${AZURE_ROOT_SERVICE_PRINCIPAL_CLIENT_SECRET}"
echo
echo "# NETWORK Service Principal"
echo "azure_network_service_principal_client_id: ${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_ID}"
echo "azure_network_service_principal_client_secret: '${AZURE_NETWORK_SERVICE_PRINCIPAL_CLIENT_SECRET}'"
echo
echo "# PCF Service Principal"
echo "azure_client_id: ${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_ID}"
echo "azure_client_secret: '${AZURE_PCF_SERVICE_PRINCIPAL_CLIENT_SECRET}'"


