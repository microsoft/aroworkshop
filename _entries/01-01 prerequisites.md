---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---

### Azure subscription and Azure Red Hat OpenShift environment

{% collapsible %}

If you have been provided with a Microsoft Hands-on Labs environment for this workshop through a registration link and an activation code, please continue to registration and activate the lab.

![Registration](media/managedlab/0-registration.png)

After you complete the registration, click Launch Lab

![Launch lab](media/managedlab/1-launchlab.png)

The Azure subscription and associated lab credentials will be provisioned. This will take a few moments. This process will also provision an Azure Red Hat OpenShift cluster.

![Preparing lab](media/managedlab/2-preparinglab.png)

Once the environment is provisioned, a screen with all the appropriate lab credentials will be presented. Additionally, you'll have your Azure Red Hat OpenShift cluster endpoint. The credentials will also be emailed to the email address entered at registration.

![Credentials](media/managedlab/3-credentials.png)

You can now skip the **Create cluster** section and jump to [create project](#createproject).

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

Set the **Storage account** and **File share** names to your resource group name (all lowercase, without any special characters). Leave other settings unchanged, then hit **Create storage**

![Azure Cloud Shell](media/cloudshell/2-storageaccount-fileshare.png)

You should now have access to the Azure Cloud Shell

![Set the storage account and fileshare names](media/cloudshell/3-cloudshell.png)

{% endcollapsible %}

#### OpenShift CLI (oc)

You'll need to [download the latest OpenShift CLI (oc)](https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/) client tools for OpenShift 4.x. You can follow the steps below on the Azure Cloud Shell.

{% collapsible %}

> **Note** You'll need to change the link below to the latest link you get from the page.
> ![GitHub release links](media/github-oc-v4-release.jpg)

Please run following commands on Azure Cloud Shell to download and setup the OpenShift client.

```sh
cd ~
wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz

mkdir openshift

tar -zxvf oc.tar.gz -C openshift

echo 'export PATH=$PATH:~/openshift' >> ~/.bashrc && source ~/.bashrc

```

The OpenShift CLI (oc) is now installed.

{% endcollapsible %}

#### GitHub Account
You'll need a personal GitHub account. You can sign up for free [here](https://github.com/join).
