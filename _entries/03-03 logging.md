---
sectionid: lab2-logging
sectionclass: h2
title: Logging and Metrics
parent-id: lab-clusterapp
---

Assuming you can access the application via the Route provided and are still logged into the CLI (please go back to part 2 if you need to do any of those) we'll start to use this application.  As stated earlier, this application will allow you to "push the buttons" of OpenShift and see how it works.

### View logs directly from the pod

{% collapsible %}

Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want to output to the *stdout* stream.  You can try "**All is well!**".  Then click "Send Message".

![Logging stdout](/media/managedlab/8-ostoy-stdout.png)

Click in the message box for "Log Message (stderr)" and write any message you want to output to the *stderr* stream. You can try "**Oh no! Error!**".  Then click "Send Message".

![Logging stderr](/media/managedlab/9-ostoy-stderr.png)

Go to the CLI and enter the following command to retrieve the name of your frontend pod which we will use to view the pod logs:

```sh
$ oc get pods -o name
pod/ostoy-frontend-679cb85695-5cn7x
pod/ostoy-microservice-86b4c6f559-p594d
```

So the pod name in this case is **ostoy-frontend-679cb85695-5cn7x**.  Then run `oc logs ostoy-frontend-679cb85695-5cn7x` and you should see your messages:

```sh
$ oc logs ostoy-frontend-679cb85695-5cn7x
[...]
ostoy-frontend-679cb85695-5cn7x: server starting on port 8080
Redirecting to /home
stdout: All is well!
stderr: Oh no! Error!
```

You should see both the *stdout* and *stderr* messages.

{% endcollapsible %}

### View logs using Azure Monitor Integration

{% collapsible %}

One can use the native Azure service, Azure Monitor, to view and keep application logs along with metrics. This lab assumes that the cluster was already configured to use Azure Monitor for application logs at cluster creation.  If you want more information on how to connect this for a new or existing cluster see the docs here: (https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-azure-redhat-setup)


Access the azure portal at (https://portal.azure.com/)

Click on "Monitor".

![Monitor](/media/managedlab/24-ostoy-azuremonitor.png)

Click Logs in the left menu.

> Note: if you are asked to select a scope select the Log Analytics scope for your cluster

![container logs](/media/managedlab/29-ostoy-logs.png)

Expand "ContainerInsights".

Double click "ContainerLog".

Then click the "Run" button at the top.

![container logs](/media/managedlab/30-ostoy-logs.png)

In the bottom pane you will see the results of the application logs returned.  You might need to sort, but you should see the two lines we outputted to *stdout* and *stderr*.

![container logs](/media/managedlab/31-ostoy-logout.png)

{% endcollapsible %}


### View Metrics using Azure Monitor Integration

{% collapsible %}

Click on "Containers" in the left menu under Insights.

![Containers](/media/managedlab/25-ostoy-monitorcontainers.png)

Click on your cluster that is integrated with Azure Monitor.

![Cluster](/media/managedlab/26-ostoy-monitorcluster.png)

You will see metrics for your cluster such as resource consumption over time and pod counts.  Feel free to explore the metrics here.  

![Metrics](/media/managedlab/27-ostoy-metrics.png)

For example, if you want to see how much resources our OSTOY pods are using click on the "Containers" tab.

Enter "ostoy" into the search box near the top left.

You will see the 2 pods we have, one for the front-end and one for the microservice and the relevant metric.  Feel free to select other options to see min, max or other percentile usages of the pods.  You can also change to see memory consumption

![container metrics](/media/managedlab/28-ostoy-metrics.png)

{% endcollapsible %}