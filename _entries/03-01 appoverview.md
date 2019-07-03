---
sectionid: appoverview
sectionclass: h2
title: Application Overview
parent-id: lab-clusterapp
---

## Part 1: Intro to the OSToy App
The source code for this app is available here: [https://github.com/openshift-cs/ostoy] <br>
OSToy front-end container image: [https://quay.io/aroworkshop/ostoy-frontend] <br>
OSToy microservice container image: [https://quay.io/aroworkshop/ostoy-microservice] <br>
Deployment Definition yamls: [OSToy yamls](/yaml/)

*Note:* In order to simplify the deployment of the app (which you will do next) we have included all the objects needed in the above yamls as "all-in-one" yamls.  In reality though, an enterprise would most likely want to have a different yaml file for each Kubernetes object.

OSToy is a simple Node.js application that we will deploy to Azure Red Hat OpenShift. It is used to help us explore the functionality of Kubernetes. This application has a user interface which you can:
 - write messages to the log (stdout / stderr)
 - intentionally crash the application to view self-healing
 - toggle a liveliness probe and monitor OpenShift behavior
 - read config maps, secrets, and env variables
 - if connected to shared storage, read and write files
 - check network connectivity, intra-cluster DNS, and intra-communication with an included microservice

### OSToy Application Diagram

![OSToy Diagram](/media/managedlab/4-ostoy-arch.png)


### Familiarization with the Application UI
  1. Shows the pod name that served your browser the page.
  2. **Home:** The main page of the application where you can perform some of the functions listed which we will explore.
  3. **Persistent Storage:**  Allows us to write data to the persistent volume bound to this application.
  4. **Config Maps:**  Shows the contents of configmaps available to the application and the key:value pairs.
  5. **Secrets:** Shows the contents of secrets available to the application and the key:value pairs.
  6. **ENV Variables:** Shows the environment variables available to the application.
  7. **Networking:** Tools to illustrate networking within the application.
  8. Shows some more information about the application.

![Home Page](/media/managedlab/10-ostoy-homepage-1.png)

### Learn More about the application
To learn more, click on the "About" menu item on the left once we deploy the app.

![ostoy About](/media/managedlab/5-ostoy-about.png)
