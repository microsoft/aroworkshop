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

```
[root@ok-vm Shifty]# oc login https://api.XXXXXXX.openshift.com --token=hUBBG3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Logged into "https://api.XXXXXXXX.openshift.com:443" as "okashi18" using the token provided.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    aro-demo
  * aro-shifty
  ...
```

**Step 1:** Create a new project called "shifty" in your clusterm using the following command

`oc new-project shifty`

Equivalently you can also create this new project using the web UI by selecting "Application Console" at the top 
then clicking on "+Create Project" button on the right.

![UI Create Project](/media/managedlab/6-shifty-newproj.png)

**Step 2:** Download the Kubernetes deployment object yamls from the following locations to your local drive in a directory of your choosing (just remember where you placed them for the next step).  Feel free to open them up and take a look at what we will be deploying. For simplicity of this lab we have placed all the Kubernetes objects we are deploying in one "all-in-one" yaml file.  Though in reality there are benefits to seperating these out into individual yaml files. 

[shifty-fe-deployment.yaml](/Shifty-YAMLs/shifty-fe-deployment.yaml)
[shifty-microservice-deployment.yaml](/Shifty-YAMLs/shifty-microservice-deployment.yaml

**Step 3:** Deploy the backend microservice
The microservice application serves internal web requests and returns a JSON object containing the current hostname and a randomly generated color string.

In your command line deploy the microservice using the following command:

`oc apply -f shifty-microservice-deployment.yaml`

You should see the following response:
```
[root@ok-vm Shifty]# oc apply -f shifty-microservice-deployment.yaml 
deployment.apps/shifty-microservice created
service/shifty-microservice-svc created
```

