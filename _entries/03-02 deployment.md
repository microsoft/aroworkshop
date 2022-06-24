---
sectionid: lab2-app-deployment
sectionclass: h2
title: Application Deployment
parent-id: lab-clusterapp
---

### Retrieve login command

If not logged in via the CLI, click on the dropdown arrow next to your name in the top-right and select *Copy Login Command*.

{% collapsible %}

![CLI Login](media/managedlab/7-ostoy-login.png)

A new tab will open click "Display Token"

Copy the command under where it says "Log in with this token". Then go to your terminal and paste that command and press enter. You will see a similar confirmation message if you successfully logged in.

```
$ oc login --token=sha256~qWBXdQ_X_4wWZor0XZO00ZZXXXXXXXXXXXX --server=https://api.abcs1234.westus.aroapp.io:6443
Logged into "https://api.abcd1234.westus.aroapp.io:6443" as "kube:admin" using the token provided.

You have access to 67 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
```

{% endcollapsible %}

### Create new project

Create a new project called "OSToy" in your cluster.

{% collapsible %}

Use the following command

`oc new-project ostoy`

You should receive the following response

```
$ oc new-project ostoy
Now using project "ostoy" on server "https://api.abcd1234.westus2.aroapp.io:6443".
[...]
```

Equivalently you can also create this new project using the web console by selecting *Home > Projects* on the left menu, then clicking on the "Create Project" button on the right.

![UI Create Project](media/managedlab/6-ostoy-newproj.png)

{% endcollapsible %}

### View the YAML deployment objects

View the Kubernetes deployment object YAMLs.  If you wish you can download them from the following locations to your Azure Cloud Shell, to your local machine, or just use the direct link in the next steps.

{% collapsible %}

Feel free to open them up and take a look at what we will be deploying. For simplicity of this lab we have placed all the Kubernetes objects we are deploying in one "all-in-one" YAML file.  Though in reality there are benefits (ease of maintenance and less risk) to separating these out into individual files.

[ostoy-fe-deployment.yaml](https://github.com/microsoft/aroworkshop/blob/master/yaml/ostoy-fe-deployment.yaml)

[ostoy-microservice-deployment.yaml](https://github.com/microsoft/aroworkshop/blob/master/yaml/ostoy-microservice-deployment.yaml)

{% endcollapsible %}

### Deploy backend microservice

The microservice serves internal web requests and returns a JSON object containing the current hostname and a randomly generated color string.

{% collapsible %}

In your terminal deploy the microservice using the following command:

`oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-microservice-deployment.yaml`

You should see the following response:
```
$ oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-microservice-deployment.yaml
deployment.apps/ostoy-microservice created
service/ostoy-microservice-svc created
```

{% endcollapsible %}

### Deploy the front-end service

This deployment contains the node.js frontend for our application along with a few other Kubernetes objects.

{% collapsible %}

 If you open the *ostoy-fe-deployment.yaml* you will see we are defining:

- Persistent Volume Claim
- Deployment Object
- Service
- Route
- Configmaps
- Secrets

Deploy the frontend along with creating all objects mentioned above by entering:

`oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-fe-deployment.yaml`

You should see all objects created successfully

```
$ oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-fe-deployment.yaml
persistentvolumeclaim/ostoy-pvc created
deployment.apps/ostoy-frontend created
service/ostoy-frontend-svc created
route.route.openshift.io/ostoy-route created
configmap/ostoy-configmap-env created
secret/ostoy-secret-env created
configmap/ostoy-configmap-files created
secret/ostoy-secret created
```

{% endcollapsible %}

### Get route

Get the route so that we can access the application via:

 `oc get route`

{% collapsible %}

You should see the following response:

```
NAME           HOST/PORT                                                      PATH      SERVICES              PORT      TERMINATION   WILDCARD
ostoy-route   ostoy-route-ostoy.apps.abcd1234.westus2.aroapp.io             ostoy-frontend-svc   <all>                   None
```

Copy `ostoy-route-ostoy.apps.abcd1234.westus2.aroapp.io` above and paste it into your browser and press enter.  You should see the homepage of our application.

![Home Page](media/managedlab/10-ostoy-homepage.png)

{% endcollapsible %}
