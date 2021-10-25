---
sectionid: intro
sectionclass: h1
title: Azure Red Hat OpenShift Workshop
type: nocount
is-parent: yes
---

[Azure Red Hat OpenShift](https://azure.microsoft.com/en-us/services/openshift/) is a fully managed Red Hat OpenShift service in Azure that is jointly engineered and supported by Microsoft and Red Hat. In this lab, you'll go through a set of tasks that will help you understand some of the concepts of deploying and securing container based applications on top of Azure Red Hat OpenShift.

You can use this guide as an OpenShift tutorial and as study material to help you get started to learn OpenShift.

Some of the things you’ll be going through:

- Creating a [project](https://docs.openshift.com/aro/4/applications/projects/working-with-projects.html) on the Azure Red Hat OpenShift Web Console
- Deploying a MongoDB container that uses Azure Disks for [persistent storage](https://docs.openshift.com/aro/4/storage/understanding-persistent-storage.html)
- Deploying a Node JS API and frontend app from Git Hub using [Source-To-Image (S2I)](https://docs.openshift.com/aro/4/openshift_images/create-images.html)
- Exposing the web application frontend using [Routes](https://docs.openshift.com/aro/4/networking/routes/route-configuration.html)
- Creating a [network policy](https://docs.openshift.com/aro/4/networking/network_policy/about-network-policy.html) to control communication between the different tiers in the application

You'll be doing the majority of the labs using the OpenShift CLI, but you can also accomplish them using the Azure Red Hat OpenShift web console.
