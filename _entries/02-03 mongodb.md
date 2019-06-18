---
sectionid: mongodb
sectionclass: h2
title: Deploy mongoDB
parent-id: lab-ratingapp
---

### Create mongoDB from template

{% collapsible %}
Azure Red Hat OpenShift provides a container image and template to make creating a new MongoDB database service easy. The template provides parameter fields to define all the mandatory environment variables (user, password, database name, etc) with predefined defaults including auto-generation of password values. It will also define both a deployment configuration and a service.

There are two templates available:

* `mongodb-ephemeral` is for development/testing purposes only because it uses ephemeral storage for the database content. This means that if the database pod is restarted for any reason, such as the pod being moved to another node or the deployment configuration being updated and triggering a redeploy, all data will be lost.

* `mongodb-persistent` uses a persistent volume store for the database data which means the data will survive a pod restart. Using persistent volumes requires a persistent volume pool be defined in the Azure Red Hat OpenShift deployment.

> **Hint** You can retrieve a list of templates using the command below. The templates are preinstalled in the `openshift` namespace.
> ```sh
> ./oc get templates -n openshift
> ```

Create a mongoDB deployment using the `mongodb-persistent` template. You're passing in the values to be replaced (username, password and database) which generates a YAML/JSON file. You then pipe it to the `oc create` command.

```sh
./oc process openshift//mongodb-persistent \
    -p MONGODB_USER=ratingsuser \
    -p MONGODB_PASSWORD=ratingspassword \
    -p MONGODB_DATABASE=ratingsdb \
    -p MONGODB_ADMIN_PASSWORD=ratingspassword | ./oc create -f -
```

If you now head back to the web console, you should see a new deployment for mongoDB.

![MongoDB deployment](media/mongodb-overview.png)

{% endcollapsible %}

### Restore data

{% collapsible %}

Now you have the database running on the cluster, it is time to restore data.

Download and unzip the data zip on the Azure Cloud Shell.

```sh
wget https://github.com/microsoft/rating-api/raw/master/data.tar.gz
tar -zxvf data.tar.gz
```

![Download and unzip the data](media/download-data.png)

Identify the name of the running MongoDB pod. For example, you can view the list of pods in your current project:

```sh
./oc get pods
```

![oc get pods](media/oc-getpods-mongo.png)

Copy the data folder into the mongoDB pod.

```sh
./oc rsync ./data mongodb-1-2g98n:/opt/app-root/src
```

![oc get pods](media/oc-rsync.png)

Then, open a remote shell session to the desired pod.

```sh
./oc rsh mongodb-1-2g98n
```

![oc rsh](media/oc-rsh.png)

Run the `mongoimport` command to import the JSON data files into the database. Make sure the username, password and database name match what you specified when you deployed the template.

```sh
mongoimport --host 127.0.0.1 --username ratingsuser --password ratingspassword --db ratingsdb --collection items --type json --file data/items.json --jsonArray
mongoimport --host 127.0.0.1 --username ratingsuser --password ratingspassword --db ratingsdb --collection sites --type json --file data/sites.json --jsonArray
mongoimport --host 127.0.0.1 --username ratingsuser --password ratingspassword --db ratingsdb --collection ratings --type json --file data/ratings.json --jsonArray
```

![mongoimport](media/mongoimport.png)

{% endcollapsible %}

### Retrieve mongoDB service hostname

{% collapsible %}

Find the mongoDB service.

```sh
./oc get svc mongodb
```

![oc get svc](media/oc-get-svc-mongo.png)

The service will be accessible at the following DNS name: `mongodb.workshop.svc.cluster.local` which is formed of `[service name].[project name].svc.cluster.local`. This resolves only within the cluster.

You can also retrieve this from the web console. You'll need this hostname to configure the `rating-api`.

![MongoDB service in the Web Console](media/mongo-svc-webconsole.png)

{% endcollapsible %}

> **Resources**
> * <https://docs.openshift.com/aro/using_images/db_images/mongodb.html>
> * <https://docs.openshift.com/aro/using_images/db_images/mongodb.html#running-mongodb-commands-in-containers>
> * <https://docs.openshift.com/aro/dev_guide/templates.html>