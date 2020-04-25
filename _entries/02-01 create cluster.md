---
sectionid: createcluster
sectionclass: h2
title: Create cluster
parent-id: lab-ratingapp
---

### Create, access, and manage an Azure Red Hat OpenShift 4.3 Cluster 

We will now create our own ARO cluster, following the steps of the documentation  [Microsoft Docs for ARO](https://docs.microsoft.com/en-us/azure/openshift/howto-using-azure-redhat-openshift) to install a new ARO cluster.

#### Prerequisites

You'll need the following to create an Azure Red Hat OpenShift 4.3 cluster:

- Azure CLI version 2.0.72 or greater

- The 'az aro' extension

- A virtual network containing two empty subnets, each with no network security group attached. Your cluster will be deployed into these subnets.

- A cluster AAD application (client ID and secret) and service principal, or sufficient AAD permissions for az aro create to create an AAD application and service principal for you automatically.

- The RP service principal and cluster service principal must each have the Contributor role on the cluster virtual network. If you have the "User Access Administrator" role on the virtual network, az aro create will set up the role assignments for you automatically

#### Install the 'az aro' extension

{% collapsible %}

1. Log in to Azure.

    ```bash
    az login
    ```

2. Run the following command to install the az aro extension:

    ```bash
    az extension add -n aro --index https://az.aroapp.io/previews
    ```

3. Verify the ARO extension is registered.

    ```bash
    az -v
    ...
    Extensions:
    aro                                0.3.0
    ```

{% endcollapsible %}

#### Create a virtual network containing two empty subnets

Follow these steps to create a virtual network containing two empty subnets.

{% collapsible %}

1. Set the following variables.

   ```console
   LOCATION=eastus        #the location of your cluster
   RESOURCEGROUP="v4-$LOCATION"    #the name of the resource group where you want to create your cluster
   CLUSTER=cluster        #the name of your cluster
   ```

2. Create a resource group for your cluster.

   ```console
   az group create -g "$RESOURCEGROUP" -l $LOCATION
   ```

3. Create the virtual network.

   ```console
   az network vnet create \
     -g "$RESOURCEGROUP" \
     -n vnet \
     --address-prefixes 10.0.0.0/9 \
     >/dev/null
   ```

4. Add two empty subnets to your virtual network.

   ```console
   for subnet in "$CLUSTER-master" "$CLUSTER-worker"; do
     az network vnet subnet create \
       -g "$RESOURCEGROUP" \
       --vnet-name vnet \
       -n "$subnet" \
       --address-prefixes 10.$((RANDOM & 127)).$((RANDOM & 255)).0/24 \
       --service-endpoints Microsoft.ContainerRegistry \
       >/dev/null
   done
   ```

5. Disable network policies for Private Link Service on your virtual network and subnets. This is a requirement for the ARO service to access and manage the cluster.

   ```console
   az network vnet subnet update \
     -g "$RESOURCEGROUP" \
     --vnet-name vnet \
     -n "$CLUSTER-master" \
     --disable-private-link-service-network-policies true \
     >/dev/null
   ```

{% endcollapsible %}

#### Create the cluster

{% collapsible %}

1. Create a resource group to hold the resources, for example in East US.

    ```bash
    az group create --name aroworkshop --location eastus
    ```

1. You’re now ready to create a cluster.

    ```bash
    az aro create \
        -g "$RESOURCEGROUP" \
        -n "$CLUSTER" \
        --vnet vnet \
        --master-subnet "$CLUSTER-master" \
        --worker-subnet "$CLUSTER-worker" \
        --cluster-resource-group "aro-$CLUSTER" \
        --domain "$CLUSTER" 
    ```

>[!NOTE]
> It normally takes about 35 minutes to create a cluster.

{% endcollapsible %}
