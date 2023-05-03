---
sectionid: lab2-nodes
sectionclass: h2
title: Managing Worker Nodes
parent-id: lab-clusterapp
---

There may be times when you need to change aspects of your worker nodes. Things like scaling, changing the type, adding labels or taints to name a few. Most of these things are done through the use of machine sets. A machine is a unit that describes the host for a node and a machine set is a group of machines. Think of a machine set as a “template” for the kinds of machines that make up the worker nodes of your cluster. Similar to how a replicaset is to pods. A machine set allows users to manage many machines as a single entity though it is contained to a specific availability zone. If you'd like to learn more see [Overview of machine management](https://docs.openshift.com/container-platform/latest/machine_management/index.html)

### Scaling worker nodes

{% collapsible %}

#### View the machine sets that are in the cluster
Let's see which machine sets we have in our cluster.  If you are following this lab, you should only have three so far (one for each availability zone).

From the terminal run:

`oc get machinesets -n openshift-machine-api`

You will see a response like:

```
$ oc get machinesets -n openshift-machine-api
NAME                           DESIRED   CURRENT   READY   AVAILABLE   AGE
ok0620-rq5tl-worker-westus21   1         1         1       1           72m
ok0620-rq5tl-worker-westus22   1         1         1       1           72m
ok0620-rq5tl-worker-westus23   1         1         1       1           72m
```
This is telling us that there is a machine set defined for each availability zone in westus2 and that each has one machine.

#### View the machines that are in the cluster

Let's see which machines (nodes) we have in our cluster.

From the terminal run:

`oc get machine -n openshift-machine-api`

You will see a response like:

```
$ oc get machine -n openshift-machine-api
NAME                                 PHASE     TYPE              REGION    ZONE   AGE
ok0620-rq5tl-master-0                Running   Standard_D8s_v3   westus2   1      73m
ok0620-rq5tl-master-1                Running   Standard_D8s_v3   westus2   2      73m
ok0620-rq5tl-master-2                Running   Standard_D8s_v3   westus2   3      73m
ok0620-rq5tl-worker-westus21-n6lcs   Running   Standard_D4s_v3   westus2   1      73m
ok0620-rq5tl-worker-westus22-ggcmv   Running   Standard_D4s_v3   westus2   2      73m
ok0620-rq5tl-worker-westus23-hzggb   Running   Standard_D4s_v3   westus2   3      73m
```

As you can see we have 3 master nodes, 3 worker nodes, the types of nodes, and which region/zone they are in.

#### Scale the number of nodes up via the CLI

Now that we know that we have 3 worker nodes, let's scale the cluster up to have 4 worker nodes. We can accomplish this through the CLI or through the OpenShift Web Console. We'll explore both.

From the terminal run the following to imperatively scale up a machine set to 2 worker nodes for a total of 4. Remember that each machine set is tied to an availability zone so with 3 machine sets with 1 machine each, in order to get to a TOTAL of 4 nodes we need to select one of the machine sets to scale up to 2 machines.

`oc scale --replicas=2 machineset <machineset> -n openshift-machine-api`

For example:

```
$ oc scale --replicas=2 machineset ok0620-rq5tl-worker-westus23 -n openshift-machine-api
machineset.machine.openshift.io/ok0620-rq5tl-worker-westus23 scaled
```

View the machine set

`oc get machinesets -n openshift-machine-api`

You will now see that the desired number of machines in the machine set we scaled is "2".

```
$ oc get machinesets -n openshift-machine-api
NAME                           DESIRED   CURRENT   READY   AVAILABLE   AGE
ok0620-rq5tl-worker-westus21   1         1         1       1           73m
ok0620-rq5tl-worker-westus22   1         1         1       1           73m
ok0620-rq5tl-worker-westus23   2         2         1       1           73m
```

If we check the machines in the clusters

`oc get machine -n openshift-machine-api`

You will see that one is in the "Provisioned" phase (and in the zone of the machineset we scaled) and will shortly be in "running" phase.

```
$ oc get machine -n openshift-machine-api
NAME                                 PHASE         TYPE              REGION    ZONE   AGE
ok0620-rq5tl-master-0                Running       Standard_D8s_v3   westus2   1      74m
ok0620-rq5tl-master-1                Running       Standard_D8s_v3   westus2   2      74m
ok0620-rq5tl-master-2                Running       Standard_D8s_v3   westus2   3      74m
ok0620-rq5tl-worker-westus21-n6lcs   Running       Standard_D4s_v3   westus2   1      74m
ok0620-rq5tl-worker-westus22-ggcmv   Running       Standard_D4s_v3   westus2   2      74m
ok0620-rq5tl-worker-westus23-5fhm5   Provisioned   Standard_D4s_v3   westus2   3      54s
ok0620-rq5tl-worker-westus23-hzggb   Running       Standard_D4s_v3   westus2   3      74m
```

#### Scale the number of nodes down via the Web Console

Now let's scale the cluster back down to a total of 3 worker nodes, but this time, from the web console. (If you need the URL or credentials in order to access it please go back to the relevant portion of Lab 1)

Access your OpenShift web console from the relevant URL. If you need to find the URL you can run:

```
az aro show \
   --name <CLUSTER-NAME> \
   --resource-group <RESOURCEGROUP> \
   --query "consoleProfile.url" -o tsv
```

Expand "Compute" in the left menu and then click on "MachineSets"

![machinesets-console](media/managedlab/41-wc-machinesets.png)

In the main pane you will see the same information about the machine sets from the command line.  Now click on the "three dots" at the end of the line for the machine set that you scaled up to "2". Select "Edit machine count" and decrease it to "1". Click save.

![machinesets-edit](media/managedlab/42-edit-machinesets.png)

This will now decrease that machine set to only have one machine in it.

{% endcollapsible %}


### Cluster Autoscaling

{% collapsible %}

The cluster autoscaler adjusts the size of an OpenShift Container Platform cluster to meet its current deployment needs. The cluster autoscaler increases the size of the cluster when there are pods that fail to schedule on any of the current worker nodes due to insufficient resources or when another node is necessary to meet deployment needs. The cluster autoscaler does not increase the cluster resources beyond the limits that you specify. To learn more visit the documentation for [cluster autoscaling](https://docs.openshift.com/container-platform/latest/machine_management/applying-autoscaling.html).

A ClusterAutoscaler must have at least 1 machine autoscaler in order for the cluster autoscaler to scale the machines. The cluster autoscaler uses the annotations on machine sets that the machine autoscaler sets to determine the resources that it can scale. If you define a cluster autoscaler without also defining machine autoscalers, the cluster autoscaler will never scale your cluster.

#### Create a Machine Autoscaler

This can be accomplished via the Web Console or through the CLI with a YAML file for the custom resource definition. We'll use the latter.

Download the sample [MachineAutoscaler resource definition](https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/machine-autoscaler.yaml) and open it in your favorite editor.

For `metadata.name` give this machine autoscaler a name. Technically, this can be anything you want. But to make it easier to identify which machine set this machine autoscaler affects, specify or include the name of the machine set to scale. The machine set name takes the following form: \<clusterid>-\<machineset>-\<region-az>.

For `spec.ScaleTargetRef.name` enter the name of the exact MachineSet you want this to apply to. Below is an example of a completed file.

```
apiVersion: "autoscaling.openshift.io/v1beta1"
kind: "MachineAutoscaler"
metadata:
  name: "ok0620-rq5tl-worker-westus21-autoscaler"
  namespace: "openshift-machine-api"
spec:
  minReplicas: 1
  maxReplicas: 7
  scaleTargetRef:
    apiVersion: machine.openshift.io/v1beta1
    kind: MachineSet
    name: ok0620-rq5tl-worker-westus21
```

Save your file.

Then create the resource in the cluster. Assuming you kept the same filename:

```
$ oc create -f machine-autoscaler.yaml
machineautoscaler.autoscaling.openshift.io/ok0620-rq5tl-worker-westus21-mautoscaler created
```

You can also confirm this by checking the web console under "MachineAutoscalers" or by running:

```
$ oc get machineautoscaler -n openshift-machine-api
NAME                           REF KIND     REF NAME                      MIN   MAX   AGE
ok0620-rq5tl-worker-westus21   MachineSet   ok0620-rq5tl-worker-westus2   1     7     40s
```

#### Create the Cluster Autoscaler

This is the sample [ClusterAutoscaler resource definition](https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/cluster-autoscaler.yaml) for this lab.

See the [documentation](https://docs.openshift.com/container-platform/latest/machine_management/applying-autoscaling.html#cluster-autoscaler-cr_applying-autoscaling) for a detailed explanation of each parameter. You shouldn't need to edit this file.

Create the resource in the cluster:

```
$ oc create -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/cluster-autoscaler.yaml
clusterautoscaler.autoscaling.openshift.io/default created
```

#### Test the Cluster Autoscaler

Now we will test this out. Create a new project where we will define a job with a load that this cluster cannot handle. This should force the cluster to autoscale to handle the load.

Create a new project called "autoscale-ex":

`oc new-project autoscale-ex`

Create the job

`oc create -f https://raw.githubusercontent.com/openshift/training/master/assets/job-work-queue.yaml`

After a few seconds, run the following to see what pods have been created.

`oc get pods`


```
$ oc get pods
NAME                     READY   STATUS              RESTARTS   AGE
work-queue-28n9m-29qgj   1/1     Running             0          53s
work-queue-28n9m-2c9rm   0/1     Pending             0          53s
work-queue-28n9m-57vnc   0/1     Pending             0          53s
work-queue-28n9m-5gz7t   0/1     Pending             0          53s
work-queue-28n9m-5h4jv   0/1     Pending             0          53s
work-queue-28n9m-6jz7v   0/1     Pending             0          53s
work-queue-28n9m-6ptgh   0/1     Pending             0          53s
work-queue-28n9m-78rr9   1/1     Running             0          53s
work-queue-28n9m-898wn   0/1     ContainerCreating   0          53s
work-queue-28n9m-8wpbt   0/1     Pending             0          53s
work-queue-28n9m-9nm78   1/1     Running             0          53s
work-queue-28n9m-9ntxc   1/1     Running             0          53s
[...]
```

We see a lot of pods in a pending state.  This should trigger the cluster autoscaler to create more machines using the MachineAutoscaler we created. If we check on the MachineSets:

```
$ oc get machinesets -n openshift-machine-api
NAME                           DESIRED   CURRENT   READY   AVAILABLE   AGE
ok0620-rq5tl-worker-westus21   5         5         1       1           7h17m
ok0620-rq5tl-worker-westus22   1         1         1       1           7h17m
ok0620-rq5tl-worker-westus23   1         1         1       1           7h17m
```

We see that the cluster autoscaler has already scaled the machine set up to 5 in our example. Though it is still waiting for those machines to be ready.

If we check on the machines we should see that 4 are in a "Provisioned" state (there was 1 already existing from before for a total of 5 in this machine set).

```
$ oc get machines -n openshift-machine-api
NAME                                 PHASE         TYPE              REGION    ZONE   AGE
ok0620-rq5tl-master-0                Running       Standard_D8s_v3   westus2   1      7h18m
ok0620-rq5tl-master-1                Running       Standard_D8s_v3   westus2   2      7h18m
ok0620-rq5tl-master-2                Running       Standard_D8s_v3   westus2   3      7h18m
ok0620-rq5tl-worker-westus21-7hqgz   Provisioned   Standard_D4s_v3   westus2   1      72s
ok0620-rq5tl-worker-westus21-7j22r   Provisioned   Standard_D4s_v3   westus2   1      73s
ok0620-rq5tl-worker-westus21-7n7nf   Provisioned   Standard_D4s_v3   westus2   1      72s
ok0620-rq5tl-worker-westus21-8m94b   Provisioned   Standard_D4s_v3   westus2   1      73s
ok0620-rq5tl-worker-westus21-qnlfl   Running       Standard_D4s_v3   westus2   1      13m
ok0620-rq5tl-worker-westus22-9dtk5   Running       Standard_D4s_v3   westus2   2      22m
ok0620-rq5tl-worker-westus23-hzggb   Running       Standard_D4s_v3   westus2   3      7h15m
```

After a few minutes we should see all 5 are provisioned.

```
$ oc get machinesets -n openshift-machine-api
NAME                           DESIRED   CURRENT   READY   AVAILABLE   AGE
ok0620-rq5tl-worker-westus21   5         5         5       5           7h23m
ok0620-rq5tl-worker-westus22   1         1         1       1           7h23m
ok0620-rq5tl-worker-westus23   1         1         1       1           7h23m
```

If we now wait a few more minutes for the pods to complete, we should see the cluster autoscaler begin scale down the machine set and thus delete machines.

```
$ oc get machinesets -n openshift-machine-api
NAME                           DESIRED   CURRENT   READY   AVAILABLE   AGE
ok0620-rq5tl-worker-westus21   4         4         4       4           7h27m
ok0620-rq5tl-worker-westus22   1         1         1       1           7h27m
ok0620-rq5tl-worker-westus23   1         1         1       1           7h27m


$ oc get machines -n openshift-machine-api
NAME                                 PHASE      TYPE              REGION    ZONE   AGE
ok0620-rq5tl-master-0                Running    Standard_D8s_v3   westus2   1      7h28m
ok0620-rq5tl-master-1                Running    Standard_D8s_v3   westus2   2      7h28m
ok0620-rq5tl-master-2                Running    Standard_D8s_v3   westus2   3      7h28m
ok0620-rq5tl-worker-westus21-7hqgz   Running    Standard_D4s_v3   westus2   1      10m
ok0620-rq5tl-worker-westus21-7j22r   Running    Standard_D4s_v3   westus2   1      10m
ok0620-rq5tl-worker-westus21-8m94b   Deleting   Standard_D4s_v3   westus2   1      10m
ok0620-rq5tl-worker-westus21-qnlfl   Running    Standard_D4s_v3   westus2   1      22m
ok0620-rq5tl-worker-westus22-9dtk5   Running    Standard_D4s_v3   westus2   2      32m
ok0620-rq5tl-worker-westus23-hzggb   Running    Standard_D4s_v3   westus2   3      7h24m
```

{% endcollapsible %}


### Adding node labels

To add a node label it is recommended to set the label in the machine set. While you can directly add a label the node, this is not recommended since nodes could be overwritten and then the label would disappear.  Once the machine set is modified to contain the desired label any new machines created from that set would have the newly added labels.  This means that existing machines (nodes) will not get the label.  Therefore, to make sure all nodes have the label, you should scale the machine set down to zero and then scale the machine set back up.


#### Using the web console

Select "MachineSets" from the left menu.  You will see the list of machinesets.

![webconsollemachineset](media/managedlab/43-machinesets.png)

We'll select the first one "ok0620-rq5tl-worker-westus21"

Click on the second tab "YAML"

Click into the YAML and under `spec.template.spec.metadata` add "labels:" then under that add a key:value pair for the label you want.  In our example we can add a label "tier: frontend". Click Save.

![webconsollemachineset](media/managedlab/44-edit-machinesets.png)

The already existing machine won't get this label but any new machines will.  So to ensure that all machines get the label, we will scale down this machine set to zero, then once completed we will scale it back up as we did earlier.

Click on the node that was just created.

You can see that the label is now there.

![checklabel](media/managedlab/45-node-label.png)
