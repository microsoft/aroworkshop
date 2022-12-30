---
sectionid: loginconsole
sectionclass: h2
title: Connect to the cluster
parent-id: intro
---

This section assumes you have been given cluster credentials by your lab administrator, or that you have created a cluster in the previous section. You should have;

* Web Console URL 
* A username (eg: `kubeadmin`, `student01`)
* A password

### Login to the web console

Open the Web Console URL in your web browser, and login with the credentials you have. After logging in, you should be able to see the Azure Red Hat OpenShift Web Console.

![Azure Red Hat OpenShift Web Console](media/openshift-webconsole.png)

### Choose an option to use the `oc` command

{% collapsible %}

This workshop will make extensive use of the `oc` OpenShift Client to run commands. You can run this command line client in several different ways.

* **Option 1)** Use the "web terminal" built into the OpenShift Web Console. This is the easiest if you have already had a OpenShift cluster installed for you for this workshop.
* **Option 2)** Use the Azure Cloud Shell. This is the most natural option if you created the cluster yourself.  

### Option 1 - Use the OpenShift web terminal to use `oc`

To launch the web terminal, click the command line terminal icon ( ![web terminal icon](media/web-terminal.png) ) on the upper right of the console. A web terminal instance is displayed in the Command line terminal pane. This instance is automatically logged in with your credentials.

### Option 2 - Use the Azure Cloud Shell to use `oc`

> **Note** Make sure you complete the [prerequisites](#prereq) to install the OpenShift CLI on the Azure Cloud Shell.

Once you're logged into the Web Console, click on the username on the top right, then click **Copy login command**.

![Copy login command](media/login-command.png)

On the following page click on **Display Token** and copy the ```oc login``` line.

![Display Token Link](media/oc-display-token-link.png)
![Copy Login Token](media/oc-copy-login-token.png)

Open the [Azure Cloud Shell](https://shell.azure.com) and paste the login command. You should be able to connect to the cluster.

![Login through the cloud shell](media/oc-login-cloudshell.png)

{% endcollapsible %}


