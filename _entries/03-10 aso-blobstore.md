---
sectionid: lab2-nodes
sectionclass: h2
title: Azure Service Operator - Blob Store
parent-id: lab-clusterapp
---

## Azure Service Operator (ASO)

The [Azure Service Operator](https://azure.github.io/azure-service-operator/) (ASO) allows you to create and use Azure services directly from
Kubernetes. You can deploy your applications, including any required Azure services directly within the Kubernetes framework using a familiar structure to declaratively define and create Azure services like Storage Blob or CosmosDB databases.

In order to illustrate the use of the ASO on ARO, we will walk through a simple example of creating an Azure Blob Storage container, connecting to it with OSToy, upload a file to it, and view the file in our application. Interestingly, this part of the workshop will also use Azure Key Vault to store secrets that the application can use to access Azure services.  We will store the secret needed to access the Blob Storage in Azure Key Vault and then mount the secret from there into our cluster for the OSToy application to use.  


### Why should you use Key Vault to store secrets?
Using a secret store like Azure Key Vault allows you to take advantage of a number of benefits.
1. Scalability - Using a secret store service is already designed to scale to handle a large number of secrets over placing them directly in the cluster.
1. Centralization - You are able to keep all your organizations secrets in one location.
1. Security - Features like access control, monitoring, encryption and audit are already baked in.
1. Rotation - Decoupling the secret from your cluster makes it much easier to rotate secrets since you only have to update it in Key Vault and the Kubernetes secret in the cluster
    will reference that external secret store.

### Section overview

To make the process clearer, here is an overview of the procedure we are going to follow. There are three main "parts".

1. **Install the Azure Service Operator** - This allows you to create/delete blob storage through the use of a Kubernetes Custom Resource.  Install the controller which will also create the required namespace and the service account and then create the required resources.
1. **Setup Key Vault** - Perform required prerequisites (ex: install CSI drivers), create a Key Vault instance, add the connection string.
1. **Application access** - configuring the application to access the stored connection string in Key Vault and thus enable the application to access the Blob Storage location.

Below is an updated application diagram of what this will look like after completing this section.

![newarch](media/managedlab/49-newarch.png)


## Access the cluster

1. Login to the cluster using the `oc` CLI if you are not already logged in.

## Setup

### Define helper variables

1. Set helper environment variables to facilitate execution of the commands in this section. Replace `<REGION>` with the Azure region you are deploying into (ex: `eastus` or `westus2`).

    ```
    export AZURE_SUBSCRIPTION_ID=$(az account show --query "id" --output tsv)
    export AZ_TENANT_ID=$(az account show -o tsv --query tenantId)
    export MY_UUID=$(uuidgen | cut -d - -f 2 | tr '[:upper:]' '[:lower:]')
    export PROJECT_NAME=ostoy-${MY_UUID}
    export KEYVAULT_NAME=secret-store-${MY_UUID}
    export REGION=<REGION>
    ```

### Create a service principal

If you don't already have a Service Principal to use then we need to create one.  It is recommended to create one with `Contributor` level permissions for this workshop so that the Azure Service
Operator can create resources and that access can be granted to Key Vault.

1. Create a service principal for use in the lab and store the client secret in an environment variable.

    ```
    export SERVICE_PRINCIPAL_CLIENT_SECRET="$(az ad sp create-for-rbac -n aro-lab-sp-${MY_UUID} --role contributor --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID --query 'password' -o tsv)"
    ```

1. Get the service principal Client Id

    ```
    export SERVICE_PRINCIPAL_CLIENT_ID="$(az ad sp list --display-name aro-lab-sp-${MY_UUID} --query '[0].appId' -o tsv)"
    ```


1. Install Helm if you don't already have it. You can also check the [Official Helm site](https://helm.sh/docs/intro/install/) for other install options.

    ```
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    ```


### Install the Azure Service Operator

1. Set up ASO
    1. We first need to install Cert Manager.  Run the following:

        ```
        oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.1/cert-manager.yaml
        ```

    1.  Confirm that the cert-manager pods have started successfully before continuing.

        ```
        oc get pods -n cert-manager
        ```
        You will see a response like:

        ```
        $ oc get pods -n cert-manager
        NAME                                       READY   STATUS    RESTARTS   AGE
        cert-manager-677874db78-t6wgn              1/1     Running   0          1m
        cert-manager-cainjector-6c5bf7b759-l722b   1/1     Running   0          1m
        cert-manager-webhook-5685fdbc4b-rlbhz      1/1     Running   0          1m
        ```

    1. We then need to add the latest Helm chart for the ASO.

        ```
        helm repo add aso2 https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts
        ```

    1. Update the Helm repository

        ```
        helm repo update
        ```

    1. Install the ASO from Helm

        ```
        helm upgrade --install --devel aso2 aso2/azure-service-operator \
        --create-namespace \
        --namespace=azureserviceoperator-system \
        --set azureSubscriptionID=$AZURE_SUBSCRIPTION_ID \
        --set azureTenantID=$AZ_TENANT_ID \
        --set azureClientID=$SERVICE_PRINCIPAL_CLIENT_ID \
        --set azureClientSecret=$SERVICE_PRINCIPAL_CLIENT_SECRET
        ```

     1. Ensure the pods are running successfully.  This could take about 2 minutes.

        ```
        oc get pods -n azureserviceoperator-system
        ```

        You will see a response like:

        ```
        $ oc get pods -n azureserviceoperator-system
            NAME                                                      READY   STATUS    RESTARTS   AGE
            azureserviceoperator-controller-manager-5b4bfc59df-lfpqf   2/2     Running   0          24s
        ```

## Create Storage Accounts and containers using the ASO

Now we need to create a Storage Account and for our blob storage to use with OSToy.  We could create this using the CLI or the Azure Portal, but wouldn't it be nice if we could
do so using standard Kubernetes objects. We could define the all the resources our application needs in once place.  We will create each resource separately below.

1.  Create a new OpenShift project for our OSToy app (even if you already have one from earlier).

    ```
    oc new-project $PROJECT_NAME
    ```

1. Create a resource group.

    ```
    cat << EOF | oc apply -f -
    apiVersion: resources.azure.com/v1api20200601
    kind: ResourceGroup
    metadata:
      name: ${PROJECT_NAME}-rg
      namespace: $PROJECT_NAME
    spec:
      location: $REGION
    EOF
    ```

1. Confirm that the Resource Group was actually created. You will see the name returned. It may take a minute or two to appear.

    ```
    az group list --query '[].name' --output tsv | grep ${MY_UUID}
    ```

1. Create a Storage Account.

    ```
    cat << EOF | oc apply -f -
    apiVersion: storage.azure.com/v1api20210401
    kind: StorageAccount
    metadata:
      name: ostoystorage${MY_UUID}
      namespace: $PROJECT_NAME
    spec:
      location: $REGION
      kind: BlobStorage
      sku:
        name: Standard_LRS
      owner:
        name: ${PROJECT_NAME}-rg
      accessTier: Hot
    EOF
    ```

1. Confirm that it was created.  It may take a minute or two to appear.

    ```
    az storage account list --query '[].name' --output tsv | grep ${MY_UUID}
    ```

1. Create a Blob service.

    ```
    cat << EOF | oc apply -f -
    apiVersion: storage.azure.com/v1api20210401
    kind: StorageAccountsBlobService
    metadata:
      name: ostoystorage${MY_UUID}service
      namespace: $PROJECT_NAME
    spec:
      owner:
        name: ostoystorage${MY_UUID}
    EOF
    ```

1. Create a container.

    ```
    cat << EOF | oc apply -f -
    apiVersion: storage.azure.com/v1api20210401
    kind: StorageAccountsBlobServicesContainer
    metadata:
      name: ${PROJECT_NAME}-container
      namespace: $PROJECT_NAME
    spec:
      owner:
        name: ostoystorage${MY_UUID}service
    EOF
    ```

1. Confirm that the container was created.  It make take a minute or two to appear.

    ```
    az storage container list --auth-mode login --account-name ostoystorage${MY_UUID} --query '[].name' -o tsv
    ```

1. Obtain the connection string of the Storage Account for use in the next section. The `--name` parameter is the name of the Storage Account we created using the ASO.

    ```
    export CONNECTION_STRING=$(az storage account show-connection-string --name ostoystorage${MY_UUID} --resource-group ${PROJECT_NAME}-rg -o tsv)
    ```

The storage account is now set up for use with our application.


## Install Kubernetes Secret Store CSI

In this part we will create a Key Vault location to store the connection string to our Storage account. Our application will use this to connect to the container we created to display the contents, create new files, as well as display the contents of the files.  We will securely mount this as a secret in a secure volume mount within our application.  Our application will then read that to access.  ADD HERE THE BENEFITS AS WELL AS WI coming.

1. To simplify the process for the workshop, there is a script provided that will do the prerequisite work in order to use Key Vault stored secrets.  If you are curious please feel free to read the script, otherwise just run it. This should take about 1-2 minutes to complete.

    ```
    curl https://raw.githubusercontent.com/microsoft/aroworkshop/master/resources/setup-csi.sh | bash
    ```

    Or, if you'd rather not live on the edge, feel free to download it first.

1. Create an Azure Key Vault in the resource group we created using the ASO above.

    ```
    az keyvault create -n $KEYVAULT_NAME --resource-group ${PROJECT_NAME}-rg --location $REGION
    ```

1. Store the connection string as a secret in Key Vault.

    ```
    az keyvault secret set --vault-name $KEYVAULT_NAME --name connectionsecret --value $CONNECTION_STRING
    ```

1. Set an Access Policy for the Service Principal. This allows the Service Principal to get secrets from the Key Vault instance.

    ```
    az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $SERVICE_PRINCIPAL_CLIENT_ID
    ```

1. Create a secret for Kubernetes to use to access the Key Vault.

    ```
    oc create secret generic secrets-store-creds \
    -n $PROJECT_NAME \
    --from-literal clientid=$SERVICE_PRINCIPAL_CLIENT_ID \
    --from-literal clientsecret=$SERVICE_PRINCIPAL_CLIENT_SECRET
    ```

1. Create a label for the secret. This prevents the CSI driver from creating multiple Kubernetes secrets for the same external secret in Azure Key Vault.

    ```
    oc -n $PROJECT_NAME label secret secrets-store-creds secrets-store.csi.k8s.io/used=true
    ```

1. Create the Secret Provider Class to give access to this secret.

    ```
    cat <<EOF | oc apply -f -
    apiVersion: secrets-store.csi.x-k8s.io/v1
    kind: SecretProviderClass
    metadata:
      name: azure-kvname
      namespace: $PROJECT_NAME
    spec:
      provider: azure
      parameters:
        usePodIdentity: "false"
        useVMManagedIdentity: "false"
        userAssignedIdentityID: ""
        keyvaultName: "${KEYVAULT_NAME}"
        objects: |
          array:
            - |
              objectName: connectionsecret
              objectType: secret
              objectVersion: ""
        tenantId: "${AZ_TENANT_ID}"
    EOF
    ```

## Create a custom Security Context Constraint (SCC)

1. Create a new SCC that allows our OSToy app to use the Secrets CSI driver.  The SCC that is run by default, `restricted`, does not allow it. So in this custom SCC we are explicitly allowing access to CSI.  Feel free to view the file first.

    ```
    oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoyscc.yaml
    ```

1. Create a Service Account for the application to run.

    ```
    oc create sa ostoy-sa -n $PROJECT_NAME
    ```

1. Grant permissions to the Service Account

    ```
    oc adm policy add-scc-to-user ostoyscc system:serviceaccount:${PROJECT_NAME}:ostoy-sa
    ```

## Deploy the OSToy application

1. Deploy the application.  First deploy the microservice.

    ```
    oc apply -n $PROJECT_NAME -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-microservice-deployment.yaml
    ```

1. Run the following to deploy the frontend. This will automatically remove the comment symbols for the new lines that we need in order to use the secret.

    ```
    curl https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-frontend-deployment.yaml | sed 's/#//g' | oc apply -n $PROJECT_NAME -f -
    ```

## See the bucket contents through OSToy

After about a minute we can use our app to see the contents of our blob storage container.

1. Get the route for the newly deployed application.

    ```
    oc get route ostoy-route -o jsonpath='{.spec.host}{"\n"}'
    ```

1. Open a new browser tab and enter the route from above. Ensure that it is using `http://` and not `https://`.
1. A new menu item will appear. Click on "ASO - Blob Storage" in the left menu in OSToy.
1. You will see a page that lists the contents of the bucket, which at this point should be empty.

    ![view blob](media/managedlab/46-aso-viewblobstorage.png)

1. Move on to the next step to add some files.

## Create files in your Azure Blob Storage Container

For this step we will use OStoy to create a file and upload it to the Blob Storage Container. While Blob Storage can accept any kind of file, for this workshop we'll use text files so that the contents can easily be rendered in the browser.

1. Click on "ASO - Blob Storage" in the left menu in OSToy.
1. Scroll down to the section underneath the "Existing files" section, titled "Upload a text file to Blob Storage".
1. Enter a file name for your file.
1. Enter some content for your file.
1. Click "Create file".

    ![create file](media/managedlab/47-aso-createblob.png)

1. Scroll up to the top section for existing files and you should see your file that you just created there.
1. Click on the file name to view the file.

    ![viewfilecontents](media/managedlab/48-aso-viewblob.png)

1. Now to confirm that this is not just some smoke and mirrors, let's confirm directly via the CLI. Run the following to list the contents of our bucket.

    ```
    az storage blob list --account-name ostoystorage${MY_UUID} --connection-string $CONNECTION_STRING -c ${PROJECT_NAME}-container --query "[].name" -o tsv
    ```

    We should see our file(s) returned.
