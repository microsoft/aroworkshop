---
sectionid: lab2-logging
sectionclass: h2
title: Logging and Metrics
parent-id: lab-clusterapp
---

Assuming you can access the application via the Route provided and are still logged into the CLI (please go back to part 2 if you need to do any of those) we'll start to use this application.  As stated earlier, this application will allow you to "push the buttons" of OpenShift and see how it works.  We will do this to test the logs.

Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want to output to the *stdout* stream.  You can try "**All is well!**".  Then click "Send Message".

![Logging stdout](/media/managedlab/8-ostoy-stdout.png)

Click in the message box for "Log Message (stderr)" and write any message you want to output to the *stderr* stream. You can try "**Oh no! Error!**".  Then click "Send Message".

![Logging stderr](/media/managedlab/9-ostoy-stderr.png)

### View logs directly from the pod

{% collapsible %}

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

One can use the native Azure service, Azure Monitor, to view and keep application logs along with metrics. In order to complete this integration you will need to follow the documentation [here](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-azure-redhat4-setup) and particularly the prerequisites.  The prerequisites are:

- The Azure CLI version 2.0.72 or later

- The Helm 3 CLI tool

- Bash version 4

- The Kubectl command-line tool

- A [Log Analytics workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/design-logs-deployment) (see [here](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace) if you need to create one)

Then follow the steps to (Enable Azure Monitor)[https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-azure-redhat4-setup#integrate-with-an-existing-workspace] for our cluster. 
> **Note:** Although not required, it is recommended to create a Log Analytics workspace prior to integrating with Azure Monitor.  It would make it easier to keep track of our logs.

This lab assumes you have successfully set up Azure Monitor with your cluster based upon the above referenced document.

Once the steps to connect Azure Monitor to an existing cluster were successfully completed, access the (Azure portal)[https://portal.azure.com]

Click on "Monitor" under the left hamburger menu.

![Monitor](/media/managedlab/24-ostoy-azuremonitor.png)

Click Logs in the left menu. Click the "Get started" button if that screen shows up.

![container logs](/media/managedlab/29-ostoy-logs.png)

If you are asked to select a scope select the Log Analytics workspace you created

Expand "ContainerInsights".

Double click "ContainerLog".

Change the time range to be "Last 30 Minutes".

Then click the "Run" button at the top.

![container logs](/media/managedlab/30-ostoy-logs.png)

In the bottom pane you will see the results of the application logs returned.  You might need to sort, but you should see the two lines we outputted to *stdout* and *stderr*. 

![container logs](/media/managedlab/31-ostoy-logout.png)

If the logs are particularly chatty then you can paste the following query to see your message.

```
ContainerLog
| where LogEntry contains "<Your Message>"
```

{% endcollapsible %}


### View Metrics using Azure Monitor Integration

{% collapsible %}

Click on "Containers" in the left menu under **Insights**.

![Containers](/media/managedlab/25-ostoy-monitorcontainers.png)

You might need to click on the "Monitored clusters" tab. Click on your cluster that is integrated with Azure Monitor. 

![Cluster](/media/managedlab/26-ostoy-monitorcluster.png)

You will see metrics for your cluster such as resource consumption over time and pod counts.  Feel free to explore the metrics here.  

![Metrics](/media/managedlab/27-ostoy-metrics.png)

For example, if you want to see how much resources our OSTOY pods are using click on the "Containers" tab.

Enter "ostoy" into the search box near the top left.

You will see the 2 pods we have, one for the front-end and one for the microservice and the relevant metric.  Feel free to select other options to see min, max or other percentile usages of the pods.  You can also change to see memory consumption

![container metrics](/media/managedlab/28-ostoy-metrics.png)

{% endcollapsible %}