---
sectionid: lab2-nodes
sectionclass: h2
title: Azure Service Operator - Blob Store
parent-id: lab-clusterapp
---

# Integrating with Azure services

So far, our OSToy application has functioned independently without relying on any external services. While this may be nice for a workshop environment, it's not exactly representative of real-world applications. Many applications require external services like databases, object stores, or messaging services.

In this section, we will learn how to integrate our OSToy application with other Azure services, specifically Azure Blob Storage and Key Vault. By the end of this section, our application will be able to securely create and read objects from Blob Storage.

To achieve this, we will use the Azure Service Operator (ASO) to create the necessary services for our application directly from Kubernetes. We will also utilize Key Vault to securely store the connection secret required for accessing the Blob Storage container. We will create a Kubernetes secret to retrieve this secret from Key Vault, enabling our application to access the Blob Storage container using the secret.

To demonstrate this integration, we will use OSToy to create a basic text file and save it in Blob Storage. Finally, we will confirm that the file was successfully added and can be read from Blob Storage.

## Azure Service Operator (ASO)

The [Azure Service Operator](https://azure.github.io/azure-service-operator/) (ASO) allows you to create and use Azure services directly from
Kubernetes. You can deploy your applications, including any required Azure services directly within the Kubernetes framework using a familiar structure to declaratively define and create Azure services like Storage Blob or CosmosDB databases.

## Key Vault

Azure Key Vault is a cloud-based service provided by Microsoft Azure that allows you to securely store and manage cryptographic keys, secrets, and certificates used by your applications and services.

### Why should you use Key Vault to store secrets?
Using a secret store like Azure Key Vault allows you to take advantage of a number of benefits.
1. Scalability - Using a secret store service is already designed to scale to handle a large number of secrets over placing them directly in the cluster.
1. Centralization - You are able to keep all your organizations secrets in one location.
1. Security - Features like access control, monitoring, encryption and audit are already baked in.
1. Rotation - Decoupling the secret from your cluster makes it much easier to rotate secrets since you only have to update it in Key Vault and the Kubernetes secret in the cluster
    will reference that external secret store. This also allows for separation of duties as someone else can manage these resources.

## Section overview

To provide a clearer understanding of the process, the procedure we will be following consists of three primary parts.

1. **Install the Azure Service Operator** - This allows you to create/delete Azure services (in our case, Blob Storage) through the use of a Kubernetes Custom Resource. Install the controller which will also create the required namespace and the service account and then create the required resources.
1. **Setup Key Vault** - Perform required prerequisites (ex: install CSI drivers), create a Key Vault instance, add the connection string.
1. **Application access** - Configuring the application to access the stored connection string in Key Vault and thus enable the application to access the Blob Storage location.

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

1. Get the service principal Client Id.

    ```
    export SERVICE_PRINCIPAL_CLIENT_ID="$(az ad sp list --display-name aro-lab-sp-${MY_UUID} --query '[0].appId' -o tsv)"
    ```


1. Install Helm if you don't already have it. You can also check the [Official Helm site](https://helm.sh/docs/intro/install/) for other install options.

    ```
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    ```


### Install the Azure Service Operator

1. Set up ASO
    1. We first need to install Cert Manager.  Run the following.

        ```
        oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.2/cert-manager.yaml
        ```

    1.  Confirm that the cert-manager pods have started successfully before continuing.

        ```
        oc get pods -n cert-manager
        ```
        
        You will see a response like:

        ```
        NAME                                       READY   STATUS    RESTARTS   AGE
        cert-manager-677874db78-t6wgn              1/1     Running   0          1m
        cert-manager-cainjector-6c5bf7b759-l722b   1/1     Running   0          1m
        cert-manager-webhook-5685fdbc4b-rlbhz      1/1     Running   0          1m
        ```

    1. We then need to add the latest Helm chart for the ASO.

        ```
        helm repo add aso2 https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts
        ```

    1. Update the Helm repository.

        ```
        helm repo update
        ```

    1. Install the ASO.

        ```
        helm upgrade --install --devel aso2 aso2/azure-service-operator \
        --create-namespace \
        --namespace=azureserviceoperator-system \
        --set azureSubscriptionID=$AZURE_SUBSCRIPTION_ID \
        --set azureTenantID=$AZ_TENANT_ID \
        --set azureClientID=$SERVICE_PRINCIPAL_CLIENT_ID \
        --set azureClientSecret=$SERVICE_PRINCIPAL_CLIENT_SECRET
        ```

     1. Ensure that the pods are running successfully.  This could take about 2 minutes.

        ```
        oc get pods -n azureserviceoperator-system
        ```

        You will see a response like:

        ```
        NAME                                                      READY   STATUS    RESTARTS   AGE
        azureserviceoperator-controller-manager-5b4bfc59df-lfpqf   2/2     Running   0          24s
        ```

## Create Storage Accounts and containers using the ASO

Now we need to create a Storage Account for our Blob Storage, to use with OSToy. We could create this using the CLI or the Azure Portal, but wouldn't it be nice if we could do so using standard Kubernetes objects? We could have defined the all these resources in once place (like in the deployment manifest), but for the purpose of gaining experience we will create each resource separately below.

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

1. Obtain the connection string of the Storage Account for use in the next section. The connection string contains all the information required to connect to the storage account. This should be guarded and securely stored. The `--name` parameter is the name of the Storage Account we created using the ASO.

    ```
    export CONNECTION_STRING=$(az storage account show-connection-string --name ostoystorage${MY_UUID} --resource-group ${PROJECT_NAME}-rg -o tsv)
    ```

The storage account is now set up for use with our application.

## Install Kubernetes Secret Store CSI

In this part we will create a Key Vault location to store the connection string to our Storage account. Our application will use this to connect to the Blob Storage container we created, enabling it to display the contents, create new files, as well as display the contents of the files. We will mount this as a secret in a secure volume mount within our application. Our application will then read that to access the Blob storage.

1. To simplify the process for the workshop, a script is provided that will do the prerequisite work in order to use Key Vault stored secrets.  If you are curious, please feel free to read the script, otherwise just run it. This should take about 1-2 minutes to complete.

    ```
    curl https://raw.githubusercontent.com/microsoft/aroworkshop/master/resources/setup-csi.sh | bash
    ```

    Or, if you'd rather not live on the edge, feel free to download it first.

    > Note: You could also connect your cluster to Azure ARC and use the [KeyVault extension](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-akv-secrets-provider)

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

1. Create a secret for Kubernetes to use to access the Key Vault. When this command is executed, the Service Principal's credentials are stored in the `secrets-store-creds` Secret object, where it can be used by the Secret Store CSI driver to authenticate with Azure Key Vault and retrieve secrets when needed.

    ```
    oc create secret generic secrets-store-creds \
    -n $PROJECT_NAME \
    --from-literal clientid=$SERVICE_PRINCIPAL_CLIENT_ID \
    --from-literal clientsecret=$SERVICE_PRINCIPAL_CLIENT_SECRET
    ```

1. Create a label for the secret. By default, the secret store provider has filtered watch enabled on secrets. You can allow it to find the secret in the default configuration by adding this label to the secret.

    ```
    oc -n $PROJECT_NAME label secret secrets-store-creds secrets-store.csi.k8s.io/used=true
    ```

1. Create the Secret Provider Class to give access to this secret. To learn more about the fields in this class see [Secret Provider Class](https://learn.microsoft.com/en-us/azure/aks/hybrid/secrets-store-csi-driver#create-and-apply-your-own-secretproviderclass-object) object.

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

SCCs are outside the scope of this workshop. Though, in short, OpenShift SCCs are a mechanism for controlling the actions and resources that a pod or container can access in an OpenShift cluster. SCCs can be used to enforce security policies at the pod or container level, which helps to improve the overall security of an OpenShift cluster. For more details please see [Managing security context constraints](https://docs.openshift.com/container-platform/latest/authentication/managing-security-context-constraints.html).

1. Create a new SCC that will allow our OSToy app to use the Secrets Store Provider CSI driver. The SCC that is used by default, `restricted`, does not allow it. So in this custom SCC we are explicitly allowing access to CSI. If you are curious feel free to view the file first, the last line in specific.

    ```
    oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoyscc.yaml
    ```

1. Create a Service Account for the application.

    ```
    oc create sa ostoy-sa -n $PROJECT_NAME
    ```

1. Grant permissions to the Service Account using the custom SCC we just created.

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

## See the storage contents through OSToy

After about a minute we can use our app to see the contents of our Blob storage container.

1. Get the route for the newly deployed application.

    ```
    oc get route ostoy-route -n $PROJECT_NAME -o jsonpath='{.spec.host}{"\n"}'
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
