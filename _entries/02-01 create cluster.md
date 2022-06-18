---
sectionid: createcluster
sectionclass: h2
title: Create cluster
parent-id: lab-ratingapp
---

### Create, access, and manage an Azure Red Hat OpenShift 4 Cluster

We will now create our own cluster.

## Before you begin

If you choose to install and use the CLI locally, this tutorial requires that you are running the Azure CLI version 2.6.0 or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest).

Azure Red Hat OpenShift requires a minimum of 40 cores to create and run an OpenShift cluster. The default Azure resource quota for a new Azure subscription does not meet this requirement. To request an increase in your resource limit, see [Standard quota: Increase limits by VM series](https://docs.microsoft.com/azure/azure-portal/supportability/per-vm-quota-requests).

### Verify your permissions

To create an Azure Red Hat OpenShift cluster, verify the following permissions on your Azure subscription, Azure Active Directory user, or service principal:

|Permissions|Resource Group which contains the VNet|User executing `az aro create`|Service Principal passed as `–client-id`|
|----|:----:|:----:|:----:|
|**User Access Administrator**|X|X| |
|**Contributor**|X|X|X|

### Register the resource providers

Next, you need to register the following resource providers in your subscription.

{% collapsible %}

1. Register the `Microsoft.RedHatOpenShift` resource provider:

    ```azurecli-interactive
    az provider register -n Microsoft.RedHatOpenShift --wait
    ```
    
1. Register the `Microsoft.Compute` resource provider:

    ```azurecli-interactive
    az provider register -n Microsoft.Compute --wait
    ```
    
1. Register the `Microsoft.Storage` resource provider:

    ```azurecli-interactive
    az provider register -n Microsoft.Storage --wait
    ```


{% endcollapsible %}

### Create a virtual network containing two empty subnets

Next, you will create a virtual network containing two empty subnets.

{% collapsible %}

0. **Set the following variables.**

   ```console
   LOCATION=eastus                 # the location of your cluster
   RESOURCEGROUP=aro-rg            # the name of the resource group where you want to create your cluster
   CLUSTER=cluster                 # the name of your cluster
   ```

1. **Create a resource group**

    An Azure resource group is a logical group in which Azure resources are deployed and managed. When you create a resource group, you are asked to specify a location. This location is where resource group metadata is stored, it is also where your resources run in Azure if you don't specify another region during resource creation. Create a resource group using the [az group create][az-group-create] command.

    ```azurecli-interactive
    az group create --name $RESOURCEGROUP --location $LOCATION
    ```

    The following example output shows the resource group created successfully:

    ```json
    {
    "id": "/subscriptions/<guid>/resourceGroups/aro-rg",
    "location": "eastus",
    "managedBy": null,
    "name": "aro-rg",
    "properties": {
        "provisioningState": "Succeeded"
    },
    "tags": null
    }
    ```

2. **Create a virtual network.**

    Azure Red Hat OpenShift clusters running OpenShift 4 require a virtual network with two empty subnets, for the master and worker nodes.

    Create a new virtual network in the same resource group you created earlier.

    ```azurecli-interactive
    az network vnet create \
    --resource-group $RESOURCEGROUP \
    --name aro-vnet \
    --address-prefixes 10.0.0.0/22
    ```

    The following example output shows the virtual network created successfully:

    ```json
    {
    "newVNet": {
        "addressSpace": {
        "addressPrefixes": [
            "10.0.0.0/22"
        ]
        },
        "id": "/subscriptions/<guid>/resourceGroups/aro-rg/providers/Microsoft.Network/virtualNetworks/aro-vnet",
        "location": "eastus",
        "name": "aro-vnet",
        "provisioningState": "Succeeded",
        "resourceGroup": "aro-rg",
        "type": "Microsoft.Network/virtualNetworks"
    }
    }
    ```

3. **Add an empty subnet for the master nodes.**

    ```azurecli-interactive
    az network vnet subnet create \
    --resource-group $RESOURCEGROUP \
    --vnet-name aro-vnet \
    --name master-subnet \
    --address-prefixes 10.0.0.0/23 
    ```

4. **Add an empty subnet for the worker nodes.**

    ```azurecli-interactive
    az network vnet subnet create \
    --resource-group $RESOURCEGROUP \
    --vnet-name aro-vnet \
    --name worker-subnet \
    --address-prefixes 10.0.2.0/23 
    ```

5. **[Disable subnet private endpoint policies](https://docs.microsoft.com/azure/private-link/disable-private-link-service-network-policy) on the master subnet.** This is required to be able to connect and manage the cluster.

    ```azurecli-interactive
    az network vnet subnet update \
    --name master-subnet \
    --resource-group $RESOURCEGROUP \
    --vnet-name aro-vnet \
    --disable-private-link-service-network-policies true
    ```

{% endcollapsible %}

### Get a Red Hat pull secret

A Red Hat pull secret enables your cluster to access Red Hat container registries along with additional content. This step is required to be able to pull Red Hat images.

Obtain your pull secret by navigating to <https://cloud.redhat.com/openshift/install/azure/aro-provisioned> and clicking **Download pull secret**. You will need to log in to your Red Hat account or create a new Red Hat account with your business email and accept the terms and conditions.

> **Note** You can upload that file to Azure Cloud Shell by dragging and dropping the file into the window.

![Download pull secret](media/redhat-pullsecret.png)

## Create the cluster

Run the following command to create a cluster. When running the `az aro create` command, you can reference your pull secret using the --pull-secret @pull-secret.txt parameter. Execute `az aro create` from the directory where you stored your `pull-secret.txt` file. Otherwise, replace `@pull-secret.txt` with `@<path-to-my-pull-secret-file>`.

{% collapsible %}

```azurecli-interactive
az aro create \
--resource-group $RESOURCEGROUP \
--name $CLUSTER \
--vnet aro-vnet \
--master-subnet master-subnet \
--worker-subnet worker-subnet \
--pull-secret @pull-secret.txt
# --domain foo.example.com # [OPTIONAL] custom domain
```

> **Note**
> It normally takes about 35 minutes to create a cluster. If you're running this from the Azure Cloud Shell and it timeouts, you can reconnect again and review the progress using `az aro list --query "[].{resource:resourceGroup, name:name, provisioningState:provisioningState}" -o table`.

> **Important**
> If you choose to specify a custom domain, for example **foo.example.com**, the OpenShift console will be available at a URL such as `https://console-openshift-console.apps.foo.example.com`, instead of the built-in domain `https://console-openshift-console.apps.<random>.<location>.aroapp.io`.
>
> By default, OpenShift uses self-signed certificates for all of the routes created on `*.apps.<random>.<location>.aroapp.io`.  If you choose to use custom DNS after connecting to the cluster, you will need to follow the OpenShift documentation to [configure a custom CA for your ingress controller](https://docs.openshift.com/container-platform/4.3/authentication/certificates/replacing-default-ingress-certificate.html) and a [custom CA for your API server](https://docs.openshift.com/container-platform/4.3/authentication/certificates/api-server.html).
>

{% endcollapsible %}

## Connect to the cluster

You can log into the cluster using the `kubeadmin` user.  

{% collapsible %}

Run the following command to find the password for the `kubeadmin` user.

```azurecli-interactive
az aro list-credentials \
  --name $CLUSTER \
  --resource-group $RESOURCEGROUP
```

The following example output shows the password will be in `kubeadminPassword`.

```json
{
  "kubeadminPassword": "<generated password>",
  "kubeadminUsername": "kubeadmin"
}
```

Save these secrets, you are going to use them to connect to the Web Portal

{% endcollapsible %}
