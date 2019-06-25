---
sectionid: appoverview
sectionclass: h2
title: Application Deployment
parent-id: lab-clusterapp
---

## Part 2: Deploying Shifty

**Step 0:** Log into the CLI if not already logged in.  Click on the dropdown arrow next to your name in the top-right and select *Copy Login Command*. 

![CLI Login](/media/managedlab/7-shifty-login.png)

Then go to your CLI and paste that command and press enter.  You will see a similar confirmation message if you successfully logged in.

![CLI Login2](/media/managedlab/8-shifty-postlogin.png)

**Step 1:** Create a new project called "shifty" in your clusterm using the following command

`oc new-project shifty`

Equivalently you can also create this new project using the web UI by selecting "Application Console" at the top 
then clicking on "+Create Project" button on the right.

![UI Create Project](/media/managedlab/6-shifty-newproj.png)

**Step 2:** 

**Step 3:** Deploy the backend microservice
The microservice application serves internal web requests and returns a JSON object containing the current hostname and a randomly generated color string.

Download both front-end and microservice deployment YAMLs and place them in some directory
