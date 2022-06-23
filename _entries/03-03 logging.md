---
sectionid: lab2-logging
sectionclass: h2
title: Logging and Metrics
parent-id: lab-clusterapp
---

Assuming you can access the application via the Route provided and are still logged into the CLI (please go back to part 2 if you need to do any of those) we'll start to use this application.  As stated earlier, this application will allow you to "push the buttons" of OpenShift and see how it works.  We will do this to test the logs.

Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want to output to the *stdout* stream.  You can try "**All is well!**".  Then click "Send Message".

![Logging stdout](media/managedlab/8-ostoy-stdout.png)

Click in the message box for "Log Message (stderr)" and write any message you want to output to the *stderr* stream. You can try "**Oh no! Error!**".  Then click "Send Message".

![Logging stderr](media/managedlab/9-ostoy-stderr.png)

### View logs directly from the pod

{% collapsible %}

Go to the CLI and enter the following command to retrieve the name of your frontend pod which we will use to view the pod logs:

```
$ oc get pods -o name
pod/ostoy-frontend-679cb85695-5cn7x
pod/ostoy-microservice-86b4c6f559-p594d
```

So the pod name in this case is **ostoy-frontend-679cb85695-5cn7x**.  Then run `oc logs ostoy-frontend-679cb85695-5cn7x` and you should see your messages:

```
$ oc logs ostoy-frontend-679cb85695-5cn7x
[...]
ostoy-frontend-679cb85695-5cn7x: server starting on port 8080
Redirecting to /home
stdout: All is well!
stderr: Oh no! Error!
```

You should see both the *stdout* and *stderr* messages.

Try to see them from within the OpenShift Web Console as well. Make sure you are in the "ostoy" project. In the left menu click *Workloads > Pods > \<frontend-pod-name>*.  Then click the "Logs" sub-tab.

![web-pods](media/managedlab/9-ostoy-wclogs.png)

{% endcollapsible %}

### View metrics and logs by integrating with Azure Arc

{% collapsible %}

You can use Azure services for metrics and logging by enabling your ARO cluster with Azure Arc. The instructions for setting this up can be found at the following locations. Perform them in the following order. These are prerequisites for this part of the lab.

1. [Connect an existing cluster to Azure Arc](https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli)
1. [Azure Monitor Container Insights for Azure Arc-enabled Kubernetes clusters](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=%2Fazure%2Fazure-arc%2Fkubernetes%2Ftoc.json&bc=%2Fazure%2Fazure-arc%2Fkubernetes%2Fbreadcrumb%2Ftoc.json)

> Note: These also have some small prerequisites. Make sure to read those too. Also, when it asks for the "Cluster Name" for the CLI commands, it will most likely be the name of the Arc enabled cluster name and NOT the name of your ARO cluster.

Once you have completed the above steps, if you are not already in Container Insights, then type "Azure Arc" in the search bar from the Home screen and select "Kubernetes - Azure Arc".

![arckubernetes](media/managedlab/36-searcharc.png)

Select the Arc connected cluster you just created, then select "Insights".

![arcclusterselect](media/managedlab/37-arcselect.png)

You will see a page with all sorts of metrics for the cluster.

![clustermetrics](media/managedlab/38-clustermetrics.png)

>Note: Please feel free to come back to this section after the "Autoscaling" section and see how you can use Container Insights to view metrics. You may need to add a filter by "namespace" to see the pods from our application.

To see the log messages we output to *stdout* and *stderr*, click on "Logs" in the left menu, then the "Container Logs" query. Finally, click "Load to editor" for the pre-created query called "Find a value in Container Logs Table".

![containerlogs](media/managedlab/39-containerlogs.png)

This will populate a query that requires a parameter to search for. Let's look for our error entry. Type "stderr" in the location for `FindString`, then click run.  You should see one line returned that contains the message you inputted earlier. You can also click the twist for more information.

![getmessage](media/managedlab/40-getlogmessage.png)

Feel free to spend a few minutes exploring logs with the pre-created queries or try your own to see how robust the service is.

{% endcollapsible %}
