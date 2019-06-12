---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---

### Azure subscription and Azure Red Hat OpenShift environment

{% collapsible %}

If you haven't provisioned an environment yet, please go ahead and create one now. You should have been given access to a Microsoft Hands-on Labs environment for this workshop. If you don't have one, please ask your proctors. For more information, please go to the [Microsoft Hands-on Labs](https://www.microsoft.com/handsonlabs/) website.

If you have lab environment provisioned, you should be able to access the Azure Cloud Shell with credentials similar to the below. Additionally, you'll have your Azure Red Hat OpenShift cluster endpoint.

![Lab environment credentials](media/lab-env.png)

{% endcollapsible %}

### Tools

#### Azure Cloud Shell

You can use the Azure Cloud Shell accessible at <https://shell.azure.com> once you login with an Azure subscription.

{% collapsible %}

Head over to <https://shell.azure.com> and sign in with your Azure Subscription details.

Select **Bash** as your shell.

![Select Bash](media/cloudshell/0-bash.png)

Select **Show advanced settings**

![Select show advanced settings](media/cloudshell/1-mountstorage-advanced.png)

Set the **Storage account** and **File share** names to your resource group name (all lowercase, without any special characters), then hit **Create storage**

![Azure Cloud Shell](media/cloudshell/2-storageaccount-fileshare.png)

You should now have access to the Azure Cloud Shell

![Set the storage account and fileshare names](media/cloudshell/3-cloudshell.png)

{% endcollapsible %}

#### OpenShift CLI (oc)
You'll need to [download the latest OpenShift CLI (oc)](https://artifacts-openshift-release-3-11.svc.ci.openshift.org/zips/) Linux artifact. You can follow the steps below on the Azure Cloud Shell.

```sh
wget https://artifacts-openshift-release-3-11.svc.ci.openshift.org/zips/openshift-origin-client-tools-v3.11.0-dfd1318-207-linux-64bit.tar.gz

mkdir openshift

tar -zxvf openshift-origin-client-tools-v3.11.0-dfd1318-207-linux-64bit.tar.gz -C openshift --strip-components=1
```

The OpenShift CLI (oc) is now in the `openshift` directory. Test that it is working by doing

```sh
cd openshift
./oc version
```