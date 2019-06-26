---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---

### Azure subscription and Azure Red Hat OpenShift environment

{% collapsible %}

If you haven't provisioned an environment yet, please go ahead and create one now. You should have been given access to a Microsoft Hands-on Labs environment for this workshop through a registration link and an activation code. If you don't have one, please ask your proctors. For more information, please go to the [Microsoft Hands-on Labs](https://www.microsoft.com/handsonlabs/) website.

Please continue the registration with the activation code you've been provided.

![Registration](media/managedlab/0-registration.png)

After you complete the registration, click Launch Lab

![Launch lab](media/managedlab/1-launchlab.png)

The Azure subscription and associated lab credentials will be provisioned. This will take a few moments. This process will also provision an Azure Red Hat OpenShift cluster.

![Preparing lab](media/managedlab/2-preparinglab.png)

Once the environment is provisioned, a screen with all the appropriate lab credentials will be presented. Additionally, you'll have your Azure Red Hat OpenShift cluster endpoint. The credentials will also be emailed to the email address entered at registration.

![Credentials](media/managedlab/3-credentials.png)

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

You'll need to [download the latest OpenShift CLI (oc)](https://github.com/openshift/origin/releases/tag/v3.11.0) client tools release. Follow the link to GitHub, and copy the link for the You can follow the steps below on the Azure Cloud Shell.

{% collapsible %}

> **Note** You'll need to change the link below to the latest link you get from the page.
> ![GitHub release links](media/github-oc-release.png)

```sh
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

mkdir openshift

tar -zxvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz -C openshift --strip-components=1

echo 'export PATH=$PATH:~/openshift' >> ~/.bashrc && source ~/.bashrc

```

The OpenShift CLI (oc) is now installed.

{% endcollapsible %}