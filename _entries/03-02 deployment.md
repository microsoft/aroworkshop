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
[user@ok-vm Shifty]# oc login https://openshift.abcd1234.eastus.azmosa.io --token=hUBBG3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Logged into "https://openshift.abcd1234.eastus.azmosa.io:443" as "okashi" using the token provided.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    aro-demo
  * aro-shifty
  ...
```

**Step 1:** Create a new project called "shifty" in your clusterm using the following command

`oc new-project shifty`

You should revieve the following response

```[user@ok-vm Shifty]# oc new-project shifty
Now using project "shifty-test" on server "https://openshift.abcd1234.eastus.azmosa.io:443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-25-centos7~https://github.com/sclorg/ruby-ex.git

to build a new example application in Ruby.
```

Equivalently you can also create this new project using the web UI by selecting "Application Console" at the top 
then clicking on "+Create Project" button on the right.

![UI Create Project](/media/managedlab/6-shifty-newproj.png)

**Step 2:** Download the Kubernetes deployment object yamls from the following locations to your local drive in a directory of your choosing (just remember where you placed them for the next step).  Feel free to open them up and take a look at what we will be deploying. For simplicity of this lab we have placed all the Kubernetes objects we are deploying in one "all-in-one" yaml file.  Though in reality there are benefits to seperating these out into individual yaml files. 

[shifty-fe-deployment.yaml](/Shifty-YAMLs/shifty-fe-deployment.yaml)<br>
[shifty-microservice-deployment.yaml](/Shifty-YAMLs/shifty-microservice-deployment.yaml)

**Step 3:** Deploy the backend microservice
The microservice application serves internal web requests and returns a JSON object containing the current hostname and a randomly generated color string.

In your command line deploy the microservice using the following command:

`oc apply -f shifty-microservice-deployment.yaml`

You should see the following response:
```
[user@ok-vm Shifty]# oc apply -f shifty-microservice-deployment.yaml 
deployment.apps/shifty-microservice created
service/shifty-microservice-svc created
```

**Step 4:** Deploy the front-end service
The frontend deployment contains the node.js frontend for our application along with a few other Kubernetes objects to illustrate examples. If you open the *shifty-fe-deployment.yaml* you will see we are defining:
 - Persistent Volume Claim
 - Deployment Object
 - Service
 - Route
 - Configmaps
 - Secrets
 
 In your command line deploy the frontend along with creating all objects mentioned above by entering:
 
 `oc apply -f shifty-fe-deployment.yaml`

You should see all objects created successfully as in below

```
[user@ok-vm Shifty]# oc apply -f shifty-fe-deployment.yaml
persistentvolumeclaim/shifty-pvc created
deployment.apps/shifty-frontend created
service/shifty-frontend-svc created
route.route.openshift.io/shifty-route created
configmap/shifty-configmap-env created
secret/shifty-secret-env created
configmap/shifty-configmap-files created
secret/shifty-secret created
```

**Step 5:** Get the route so that we can access the application via `oc get route`

Should see the following response
```NAME           HOST/PORT                                                             PATH      SERVICES              PORT      TERMINATION   WILDCARD
shifty-route   shifty-route-shifty.apps.abcd1234.eastus.azmosa.io             shifty-frontend-svc   <all>                   None
```
