#!/bin/bash

#########################################
# This script is adapted from the Azure Red Hat OpenShift documentation 
# https://learn.microsoft.com/en-us/azure/openshift/howto-use-key-vault-secrets
# 
# There are two main parts
# 1. Installing the Kubernetes Secret Store CSI driver
# 2. Installing the Azure Key Store CSI driver
#
# Prerequisites: Ensure that you are logged into the cluster with `oc` prior to running.
#########################################

CSI_NAMESPACE=k8s-secrets-store-csi
OSTOY_PROJECT_NAME=$(oc project --short) # save the current project name to switch back to at the end of the script

####################################
# 1. Installing the Kubernetes Secret Store CSI
####################################

# Create an OpenShift Project to deploy the CSI into
echo -n "Creating new $CSI_NAMESPACE project for the Secret Store CSI..."
oc new-project $CSI_NAMESPACE > /dev/null 2>&1
echo "done."

# Set SecurityContextConstraints to allow the CSI driver to run (otherwise the DaemonSet will not be able to create Pods)
echo -n "Updating SecurityContextConstraints to allow the CSI driver to run..."
oc adm policy add-scc-to-user privileged system:serviceaccount:$CSI_NAMESPACE:secrets-store-csi-driver > /dev/null 2>&1
echo "done."

# Add the Secrets Store CSI Driver to your Helm Repositories
echo "Adding the Secrets Store CSI Driver to your Helm repositories."
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts > /dev/null 2>&1

# Update your local Helm Repositories
helm repo update > /dev/null 2>&1

# Install the secrets store csi driver
echo -n "Installing the secrets store csi driver..."
helm install -n $CSI_NAMESPACE csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --version v1.3.2 \
  --set "linux.providersDir=/var/run/secrets-store-csi-providers" > /dev/null 2>&1
echo "done."

# Wait for the daemonset to be fully deployed
while [[ $(oc get daemonset -n $CSI_NAMESPACE -l "app=secrets-store-csi-driver" -o jsonpath='{.items[*].status.numberReady}') != $(oc get daemonset -n $CSI_NAMESPACE -l "app=secrets-store-csi-driver" -o jsonpath='{.items[*].status.desiredNumberScheduled}') ]]; do
  echo "Waiting for daemonsets to be fully deployed..."
  sleep 10
done

echo "Ready."

####################################
# Installing the Azure Key Store CSI
####################################

# Add the Azure Helm Repository
echo "Adding the Azure Helm repository."
helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts > /dev/null 2>&1

# Update your local Helm Repositories
helm repo update > /dev/null 2>&1

# Install the Azure Key Vault CSI provider
echo -n "Installing the Azure Key Vault CSI provider..."
helm install -n $CSI_NAMESPACE azure-csi-provider \
  csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
  --set linux.privileged=true --set secrets-store-csi-driver.install=false \
  --set "linux.providersDir=/var/run/secrets-store-csi-providers" \
  --version=v1.4.1 > /dev/null 2>&1
echo "done."

# Wait for the daemonset to be fully deployed
while [[ $(oc get daemonset -n $CSI_NAMESPACE -l "app=csi-secrets-store-provider-azure" -o jsonpath='{.items[*].status.numberReady}') != $(oc get daemonset -n $CSI_NAMESPACE -l "app=csi-secrets-store-provider-azure" -o jsonpath='{.items[*].status.desiredNumberScheduled}') ]]; do
  echo "Waiting for daemonsets to be fully deployed..."
  sleep 10
done

# Set SecurityContextConstraints to allow the CSI driver to run
echo -n "Updating SecurityContextConstraints to allow the CSI driver to run..."
oc adm policy add-scc-to-user privileged system:serviceaccount:$CSI_NAMESPACE:csi-secrets-store-provider-azure > /dev/null 2>&1
echo "done."

# Switch back to the OC project
oc project $OSTOY_PROJECT_NAME > /dev/null 2>&1

echo "Keyvault prerequisites setup complete."