---
sectionid: createcluster
sectionclass: h2
title: Create cluster
parent-id: lab-ratingapp
---

### Create an Azure Active Directory tenant for your cluster 


Microsoft Azure Red Hat OpenShift requires an [Azure Active Directory (Azure AD)](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-create-new-tenant) tenant to create your cluster. A tenant is a dedicated instance of Azure AD that an organization or app developer receives when they create a relationship with Microsoft by signing up for Azure, Microsoft Intune, or Microsoft 365. Each Azure AD tenant is distinct and separate from other Azure AD tenants and has its own work and school identities and app registrations.

If you have **Administrator** access to your organization's Azure Active Directory (unlikely), you can skip this step. Otherwise, follow these instructions to create one.

#### Create Azure Active Directory tenant

{% collapsible %}

1. Sign in to the Azure portal using the account you wish to associate with your Azure Red Hat OpenShift cluster, go to <https://portal.azure.com>

1. Open the [Azure Active Directory blade](https://portal.azure.com/#create/Microsoft.AzureActiveDirectory) to create a new tenant (also known as a new Azure Active Directory).

1. Provide an initial domain name. This will have `onmicrosoft.com` appended to it. You can reuse the value for Organization name here.

1. Choose a country or region where the tenant will be created.

1. Click **Create**.

1. After your Azure AD tenant is created, select the **Click here to manage your new directory** link. Your new tenant name should be displayed in the upper-right of the Azure portal:

    ![New tenant](../media/new-tenant.png)

1. Make note of the tenant ID so you can later specify where to create your Azure Red Hat OpenShift cluster. In the portal, you should now see the Azure Active Directory overview blade for your new tenant. Select Properties and copy the value for your Directory ID.

{% endcollapsible %}


> **Resources**
> * [ARO Documentation - Access your services](https://docs.openshift.com/aro/getting_started/access_your_services.html)
> * [ARO Documentation - Getting started with the CLI](https://docs.openshift.com/aro/cli_reference/get_started_cli.html)
> * [ARO Documentation - Projects](https://docs.openshift.com/aro/dev_guide/projects.html)
