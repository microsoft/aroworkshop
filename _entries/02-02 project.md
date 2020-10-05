---
sectionid: createproject
sectionclass: h2
title: Create Project
parent-id: lab-ratingapp
---

### Login to the web console

{% collapsible %}

Each Azure Red Hat OpenShift cluster has a public hostname that hosts the OpenShift Web Console.

You can use command `az aro list` to list the clusters in your current Azure subscription.

```sh
az aro list -o table
```

The cluster web console's URL will be listed. Open that link in new browser tab and login with the `kubeadmin` user and password retrieved earlier.

After logging in, you should be able to see the Azure Red Hat OpenShift Web Console.

![Azure Red Hat OpenShift Web Console](media/openshift-webconsole.png)

{% endcollapsible %}

### Retrieve the login command and token

{% collapsible %}

> **Note** Make sure you complete the [prerequisites](#prereq) to install the OpenShift CLI on the Azure Cloud Shell.

Once you're logged into the Web Console, click on the username on the top right, then click **Copy login command**.

![Copy login command](media/login-command.png)

Open the [Azure Cloud Shell](https://shell.azure.com) and paste the login command. You should be able to connect to the cluster.

![Login through the cloud shell](media/oc-login-cloudshell.png)

{% endcollapsible %}

### Create a project

{% collapsible %}

A project allows a community of users to organize and manage their content in isolation from other communities.

```sh
oc new-project workshop
```

![Create new project](media/oc-newproject.png)

{% endcollapsible %}

> **Resources**

> * [ARO Documentation - Getting started with the CLI](https://docs.openshift.com/aro/4/cli_reference/openshift_cli/getting-started-cli.html)
> * [ARO Documentation - Projects](https://docs.openshift.com/aro/4/applications/projects/working-with-projects.html)
