---
sectionid: mongodb
sectionclass: h2
title: Deploy MongoDB
parent-id: lab-ratingapp
---

### Create MongoDB from template

{% collapsible %}
Azure Red Hat OpenShift provides a container image and template to make creating a new MongoDB database service easy. The template provides parameter fields to define all the mandatory environment variables (user, password, database name, etc) with predefined defaults including auto-generation of password values. It will also define both a deployment configuration and a service.

There are two templates available:

* `mongodb-ephemeral` is for development/testing purposes only because it uses ephemeral storage for the database content. This means that if the database pod is restarted for any reason, such as the pod being moved to another node or the deployment configuration being updated and triggering a redeploy, all data will be lost.

* `mongodb-persistent` uses a persistent volume store for the database data which means the data will survive a pod restart. Using persistent volumes requires a persistent volume pool be defined in the Azure Red Hat OpenShift deployment.

> **Hint** You can retrieve a list of templates using the command below. The templates are preinstalled in the `openshift` namespace.
> ```sh
> oc get templates -n openshift
> ```

Create a MongoDB deployment using the `mongodb-persistent` template. You're passing in the values to be replaced (username, password and database) which generates a YAML/JSON file. You then pipe it to the `oc create` command.

```sh
oc process openshift//mongodb-persistent \
    -p MONGODB_USER=ratingsuser \
    -p MONGODB_PASSWORD=ratingspassword \
    -p MONGODB_DATABASE=ratingsdb \
    -p MONGODB_ADMIN_PASSWORD=ratingspassword | oc create -f -
```

If you now head back to the web console and navigate to **Workloads > Deployment Configs**, you should see a new entry for mongoDB. Make sure you select **Project: workshop** near the top of the page as well, if you have not already done so.

![MongoDB deployment](media/mongodb-overview.png)

{% endcollapsible %}

### Verify if the MongoDB pod was created successfully

{% collapsible %}

Run the `oc status` command to view the status of the new application and verify if the deployment of the mongoDB template was successful.

```sh
oc status
```

![oc status](media/oc-status-mongodb.png)

{% endcollapsible %}

### Retrieve MongoDB service hostname

{% collapsible %}

Find the MongoDB service.

```sh
oc get svc mongodb
```

![oc get svc](media/oc-get-svc-mongo.png)

The service will be accessible at the following DNS name: `mongodb.workshop.svc.cluster.local` which is formed of `[service name].[project name].svc.cluster.local`. This resolves only within the cluster.

You can also retrieve this from the web console by going to **. You'll need this hostname to configure the `rating-api`.

![MongoDB service in the Web Console](media/mongo-svc-webconsole.png)

{% endcollapsible %}

> **Resources**
> * [ARO Documentation - MongoDB](https://docs.openshift.com/aro/using_images/db_images/mongodb.html)
> * [ARO Documentation - Running MongoDB Commands...](https://docs.openshift.com/aro/using_images/db_images/mongodb.html#running-mongodb-commands-in-containers)
> * [ARO Documentation - Templates](https://docs.openshift.com/aro/dev_guide/templates.html)
