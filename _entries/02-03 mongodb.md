---
sectionid: mongodb
sectionclass: h2
title: Deploy MongoDB
parent-id: lab-ratingapp
---

### Create mongoDB from template

{% collapsible %}
Azure Red Hat OpenShift provides a container image and template to make creating a new MongoDB database service easy. The template provides parameter fields to define all the mandatory environment variables (user, password, database name, etc) with predefined defaults including auto-generation of password values. It will also define both a deployment configuration and a service.

Switch to the ``openshift`` project to create the mongoDB template.
```sh
oc project openshift
```

Load up the ``mongodb-persistent-template`` template into the ``openshift`` namespace.
```sh
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/db-templates/mongodb-persistent-template.json
```

Switch back to your main project ``workshop`` project.
```sh
oc project workshop
```

Create a mongoDB deployment using the `mongodb-persistent` template. You're passing in the values to be replaced (username, password and database) which generates a YAML/JSON file. You then pipe it to the `oc create` command.

```sh
oc process openshift//mongodb-persistent \
    -p MONGODB_USER=ratingsuser \
    -p MONGODB_PASSWORD=ratingspassword \
    -p MONGODB_DATABASE=ratingsdb \
    -p MONGODB_ADMIN_PASSWORD=ratingspassword | oc create -f -
```

If you now head back to the web console, and switch to the **workshop** project, you should see a new deployment for mongoDB.

![MongoDB deployment](media/mongodb-overview.png)

{% endcollapsible %}

### Verify if the mongoDB pod was created successfully

{% collapsible %}

Run the `oc get all` command to view the status of the new application and verify if the deployment of the mongoDB template was successful.

```sh
oc get all
```

![oc status](media/oc-status-mongodb.png)

{% endcollapsible %}

### Retrieve mongoDB service hostname

{% collapsible %}

Find the mongoDB service.

```sh
oc get svc mongodb
```

![oc get svc](media/oc-get-svc-mongo.png)

The service will be accessible at the following DNS name: `mongodb.workshop.svc.cluster.local` which is formed of `[service name].[project name].svc.cluster.local`. This resolves only within the cluster.

You can also retrieve this from the web console. You'll need this hostname to configure the `rating-api`.

![MongoDB service in the Web Console](media/mongo-svc-webconsole.png)

{% endcollapsible %}

> **Resources**
> * [ARO Documentation - Templates](https://docs.openshift.com/aro/4/openshift_images/using-templates.html)
