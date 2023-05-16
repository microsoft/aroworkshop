#!/bin/bash
start=$(date +%s)
set -e

RESOURCE_GROUP=openenv-$GUID
CLUSTER_NAME=aro-cluster-$GUID

az extension add --name connectedk8s > /dev/null 2>&1
az extension add --upgrade -n k8s-extension > /dev/null 2>&1

echo "Extensions added." > ${HOME}/arc.log

az connectedk8s connect --name ${CLUSTER_NAME}-arc --resource-group $RESOURCE_GROUP > /dev/null 2>&1 #--no-wait
echo "Cluster connection to ARC initiated." >> ${HOME}/arc.log

i=0
while [[ $(az connectedk8s show --resource-group $RESOURCE_GROUP --name ${CLUSTER_NAME}-arc --query 'connectivityStatus' -o tsv) != "Connected" && i -lt 60 ]]
do
    echo "$i. waiting for connectivity..." >> ${HOME}/arc.log
    sleep 10
    ((i=i+1))
done

end=$(date +%s)
secs=$(($end-$start))
printf "\n**************\nConnection Runtime\n**************\n" >> ${HOME}/arc.log
printf '%dh:%dm:%ds\n' $((secs/3600)) $((secs%3600/60)) $((secs%60)) >> ${HOME}/arc.log

WORKSPACE_ID=$(az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $CLUSTER_NAME-ws-monitor --query 'id' -o tsv)
echo "Created LA Workspace." >> ${HOME}/arc.log

az k8s-extension create --name azuremonitor-containers --cluster-name $CLUSTER_NAME-arc \
    --resource-group $RESOURCE_GROUP \
    --cluster-type connectedClusters \
    --extension-type Microsoft.AzureMonitor.Containers \
    --configuration-settings logAnalyticsWorkspaceResourceID=${WORKSPACE_ID} \
    --no-wait > /dev/null 2>&1
echo "AzureMonitor.Containers extention initiated." >> ${HOME}/arc.log

az k8s-extension create -g $RESOURCE_GROUP -c $CLUSTER_NAME-arc -t connectedClusters --extension-type Microsoft.AzureKeyVaultSecretsProvider --name akvsecretsprovider --no-wait > /dev/null 2>&1
echo "AzureKeyVaultSecretsProvider extention initiated." >> ${HOME}/arc.log

sleep 80

i=0
while [[ ($(az k8s-extension show -g $RESOURCE_GROUP -c $CLUSTER_NAME-arc -t connectedClusters --name azuremonitor-containers --query 'provisioningState' -o tsv) != "Succeeded" || \
         $(az k8s-extension show -g $RESOURCE_GROUP -c $CLUSTER_NAME-arc -t connectedClusters --name akvsecretsprovider --query 'provisioningState' -o tsv) != "Succeeded") && \
        i -lt 60 ]]
do
    echo "$i. Waiting for extensions...." >> ${HOME}/arc.log
    sleep 10
    ((i=i+1))
done

echo $(az k8s-extension list -g $RESOURCE_GROUP -c $CLUSTER_NAME-arc -t connectedClusters -o table) >> ${HOME}/arc.log

echo "Done." >> ${HOME}/arc.log

end=$(date +%s)
secs=$(($end-$start))
printf "\n**************\nTotal Runtime\n**************\n" >> ${HOME}/arc.log
printf '%dh:%dm:%ds\n' $((secs/3600)) $((secs%3600/60)) $((secs%60)) >> ${HOME}/arc.log