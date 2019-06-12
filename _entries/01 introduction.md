---
sectionid: intro
sectionclass: h1
title: Azure Red Hat OpenShift Workshop
type: nocount
is-parent: yes
---

[Azure Red Hat OpenShift](https://azure.microsoft.com/en-us/services/openshift/) is a fully managed Red Hat OpenShift service that is jointly engineered and supported by Microsoft and Red Hat. In this lab, you'll go through a set of tasks that will help you understand some of the concepts of deploying and securing container based applications on top of Azure Red Hat OpenShift.

Some of the things you’ll be going through:

- Creating a [project](https://docs.openshift.com/aro/dev_guide/projects.html) on the Azure Red Hat OpenShift Web Console
- Deploying a Node JS API and frontend app from Git Hub using [Source-To-Image (S2I)](https://docs.openshift.com/aro/creating_images/s2i.html)
- Deploying a MongoDB container that uses Azure Disks for [persistent storage](https://docs.openshift.com/aro/dev_guide/persistent_volumes.html)
- Restoring data into the MongoDB container by [executing commands](https://docs.openshift.com/aro/dev_guide/executing_remote_commands.html) on the Pod
- Exposing the web application frontend using [Routes](https://docs.openshift.com/aro/dev_guide/routes.html)
- Creating a [network policy](https://docs.openshift.com/aro/admin_guide/managing_networking.html#admin-guide-networking-networkpolicy) to control communication between the different tiers in the application
- Setting scaling policies using [Horizontal Pod Autoscaler](https://docs.openshift.com/aro/dev_guide/pod_autoscaling.html)
- Application monitoring, logging and metrics