---
sectionid: mongodb
sectionclass: h2
title: Deploy MongoDB
parent-id: lab-ratingapp
---

### Create mongoDB from Docker hub

{% collapsible %}
Azure Red Hat OpenShift allows you to deploy a container image from Docker hub easily and we will deploy a MongoDB database service this way. The mandatory environment variables (user, password, database name etc.) can be passed in the ``oc new-app`` command line

Deploy the MongoDB database:
```sh
oc new-app bitnami/mongodb -e MONGODB_USERNAME=ratingsuser -e MONGODB_PASSWORD=ratingspassword -e MONGODB_DATABASE=ratingsdb -e MONGODB_ROOT_USER=root -e MONGODB_ROOT_PASSWORD=ratingspassword
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
