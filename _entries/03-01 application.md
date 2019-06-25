---
sectionid: appoverview
sectionclass: h2
title: Application Overview [WIP]
parent-id: lab-clusterapp
---

## Part 1: Intro to the Shifty App
The source code for this app is available here: https://github.com/openshift-cs/shifty-demo <br>
Shifty front-end container image: quay.io/aroworkshop/shifty-frontend <br> 
Shifty microservice container image: quay.io/aroworkshop/shifty-microservice

Shifty is a simple Node.js application that we will deploy to Azure Red Hat OpenShift. It is used to help us explore the functionality of Kubernetes. This application has a user interface which you can:
 - write messages to the log (stdout / stderr)
 - intentionally crash the application to view auto repair
 - toggle a liveness probe and monitor OpenShift behavior
 - if provided; read config maps, secrets, and env variables
 - if connected to shared storage, read and write files
 - check network connectivity, intra-cluster DNS, and intra-communication with an included microservice

![Shifty Diagram](/media/managedlab/4-shifty-arch.png)

To learn more click on the "About" menu item on the left once we deploy the app.

![Shifty About](/media/managedlab/5-shifty-about.png)
