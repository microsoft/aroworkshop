---
sectionid: createproject
sectionclass: h2
title: Create project
parent-id: labs
---

### Login to the web console

Each Azure Red Hat OpenShift cluster has a public hostname that hosts the OpenShift Web Console.

Retrieve your cluster specific hostname. Replace `<cluster name>` and `<resource group>` by those specific to your environment.

```sh
az openshift show -n <cluster name> -g <resource group> --query "publicHostname" -o tsv
```

You should get back something like `openshift.77f472f620824da084be.eastus.azmosa.io`. Add `https://` to the beginning of that hostname and open that link in your browser. You'll be asked to login with Azure Active Directory. Use the username and password provided to you in the lab.

After logging in, you should be able to see the Azure Red Hat OpenShift Web Console.

![Azure Red Hat OpenShift Web Console](media/openshift-webconsole.png)

### Retrieve the login command and token

> **Note** Make sure you complete the [prerequisites](#prereq) to install the OpenShift CLI on the Azure Cloud Shell.

Once you're logged into the Web Console, click on the username on the top right, then click **Copy login command**.

![Copy login command](media/login-command.png)

Open the [Azure Cloud Shell](https://shell.azure.com), navigate to where you extracted the OpenShift CLI, and paste the login command. You should be able to connect to the cluster.

![Login through the cloud shell](media/oc-login-cloudshell.png)

### Create a project

A project allows a community of users to organize and manage their content in isolation from other communities.

```
./oc new-project workshop`
```

> **Resources**
> * <https://docs.openshift.com/aro/getting_started/access_your_services.html>
> * <https://docs.openshift.com/aro/cli_reference/get_started_cli.html>
> * <https://docs.openshift.com/aro/dev_guide/projects.html>