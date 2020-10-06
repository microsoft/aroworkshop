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

You should get back something like `https://console-openshift-console.apps.rt80g8x5.eastus.aroapp.io` under the URL column. 

![Azure Cloud Shell ARO URL](media/aro-url.png)

If you click on this like or paste into a browser you'll be asked to login to the OpenShift Container Platform console. Use the `kubeadminUsername` and `kubeadminPassword` from previous exercise.

> **Note** These credentials were gathered in step "2.2 Connect to the cluster"

After logging in, you should be able to see the Azure Red Hat OpenShift Web Console.

![Azure Red Hat OpenShift Web Console](media/openshift-webconsole.png)

{% endcollapsible %}

### Retrieve the login command and token

{% collapsible %}

> **Note** Make sure you complete the [prerequisites](#prereq) to install the OpenShift CLI on the Azure Cloud Shell.

Once you're logged into the Web Console, click on the username on the top right, then click **Copy login command**.

![Copy login command link](media/login-command.png)

Click **Display Token**, then copy the command in the section **Log in with this token**.

![Copy login command screen](media/login-command2.png)

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
> * [ARO Documentation - Access your services](https://docs.openshift.com/aro/getting_started/access_your_services.html)
> * [ARO Documentation - Getting started with the CLI](https://docs.openshift.com/aro/cli_reference/get_started_cli.html)
> * [ARO Documentation - Projects](https://docs.openshift.com/aro/dev_guide/projects.html)
