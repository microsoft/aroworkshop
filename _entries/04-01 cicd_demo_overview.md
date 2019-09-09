---
sectionid: lab3-cdcd-demo-overview
sectionclass: h2
title: CICD Demo Overview
parent-id: lab-cicd
---

### CICD 

With Continuous Integration and Continuous Delivery, you can accelerate the development and deliver of your microservices. Azure Red Hat OpenShift provides seamless supports to open source DevOps & CICD tools, like Jenkins, Nexus, GitHub and SonarQube.

### The OpenShift CICD Demo

In this lab, you'll deploy a complete CICD demo on Azure Red Hat OpenShift. 

Following components will be deployed onto your Azure Red Hat OpenShift cluster.

- A sample Java application, the source code is available at https://github.com/OpenShiftDemos/openshift-tasks
- A sample OpenShift Pipeline, a pre-defined CICD pipeline on ARO.
- Jenkins, open source CICD engine and automation server.
- Nexus, software artifact repository.
- SonarQube, code quality platform.
- Gogs, a self-hosted Git service.
- PostgreSQL, open source RDBMS database.
- Eclipse Che, web based Eclipse IDE.

The following diagram shows the steps included in the deployment pipeline:

![CICD Demo Diagram](/media/cicd-pipeline-diagram.png)

On every pipeline execution, the code goes through the following steps:

- Code is cloned from Gogs, built, tested and analyzed for bugs and bad patterns
- The WAR artifact is pushed to Nexus Repository manager
- A container image (tasks:latest) is built based on the Tasks application WAR artifact deployed on WildFly
- The Tasks app container image is pushed to the internal image registry
- The Tasks container image is deployed in a fresh new container in DEV project
- If tests successful, the pipeline is paused for the release manager to approve the release to STAGE
- If approved, the DEV image is tagged in the STAGE project
- The staged image is deployed in a fresh new container in the STAGE project

To learn more about this CICD demo, you can visit [this](https://github.com/nichochen/openshift-cd-demo) GitHub Repo.

