---
sectionid: lab2-network
sectionclass: h2
title: Networking and Scaling
parent-id: lab-clusterapp
---

In this section we'll see how OSToy uses intra-cluster networking to separate functions by using microservices and visualize the scaling of pods.

Let's review how this application is set up...

![OSToy Diagram](media/managedlab/4-ostoy-arch.png)

As can be seen in the image above we have defined at least 2 separate pods, each with its own service.  One is the frontend web application (with a service and a publicly accessible route) and the other is the backend microservice with a service object created so that the frontend pod can communicate with the microservice (across the pods if more than one).  Therefore this microservice is not accessible from outside this cluster (or from other namespaces/projects, if configured, due to OpenShifts' network policy, [ovs-networkpolicy](https://docs.openshift.com/container-platform/4.10/networking/network_policy/about-network-policy.html#nw-networkpolicy-about_about-network-policy)).  The sole purpose of this microservice is to serve internal web requests and return a JSON object containing the current hostname and a randomly generated color string.  This color string is used to display a box with that color displayed in the tile titled "Intra-cluster Communication".

### Networking

Click on *Networking* in the left menu. Review the networking configuration.

{% collapsible %}

The right tile titled "Hostname Lookup" illustrates how the service name created for a pod can be used to translate into an internal ClusterIP address. Enter the name of the microservice following the format of `my-svc.my-namespace.svc.cluster.local` which we created in our `ostoy-microservice.yaml` as seen here:

```
apiVersion: v1
kind: Service
metadata:
  name: ostoy-microservice-svc
  labels:
    app: ostoy-microservice
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
  selector:
    app: ostoy-microservice
```

In this case we will enter: `ostoy-microservice-svc.ostoy.svc.cluster.local`

We will see an IP address returned.  In our example it is `172.30.165.246`.  This is the intra-cluster IP address; only accessible from within the cluster.

![ostoy DNS](media/managedlab/20-ostoy-dns.png)

{% endcollapsible %}

### Scaling

OpenShift allows one to scale up/down the number of pods for each part of an application as needed.  This can be accomplished via changing our *replicaset/deployment* definition (declarative), by the command line (imperative), or via the web console (imperative). In our *deployment* definition (part of our `ostoy-fe-deployment.yaml`) we stated that we only want one pod for our microservice to start with. This means that the Kubernetes Replication Controller will always strive to keep one pod alive. We can also define pod autoscaling using the [Horizontal Pod Autoscaler](https://docs.openshift.com/container-platform/4.10/nodes/pods/nodes-pods-autoscaling.html) (HPA) based on load to expand past what we defined. We will do this in a later section of this lab.

{% collapsible %}

If we look at the tile on the left we should see one box randomly changing colors.  This box displays the randomly generated color sent to the frontend by our microservice along with the pod name that sent it. Since we see only one box that means there is only one microservice pod.  We will now scale up our microservice pods and will see the number of boxes change.

To confirm that we only have one pod running for our microservice, run the following command, or use the web console.

```
$ oc get pods
NAME                                   READY     STATUS    RESTARTS   AGE
ostoy-frontend-679cb85695-5cn7x       1/1       Running   0          1h
ostoy-microservice-86b4c6f559-p594d   1/1       Running   0          1h
```

Let's change our microservice definition yaml to reflect that we want 3 pods instead of the one we see. Download the [ostoy-microservice-deployment.yaml](/yaml/ostoy-microservice-deployment.yaml) and save it on your local machine.

Open the file using your favorite editor. Ex: `vi ostoy-microservice-deployment.yaml`.

Find the line that states `replicas: 1` and change that to `replicas: 3`. Then save and quit.

It will look like this

```
spec:
    selector:
      matchLabels:
        app: ostoy-microservice
    replicas: 3
 ```

Assuming you are still logged in via the CLI, execute the following command:

`oc apply -f ostoy-microservice-deployment.yaml`

Confirm that there are now 3 pods via the CLI (`oc get pods`) or the web console (*Workloads > Deployments > ostoy-microservice*).

See this visually by visiting the OSToy app and seeing how many boxes you now see.  It should be three.

![UI Scale](media/managedlab/22-ostoy-colorspods.png)

Now we will scale the pods down using the command line.  Execute the following command from the CLI:

`oc scale deployment ostoy-microservice --replicas=2`

Confirm that there are indeed 2 pods, via the CLI (`oc get pods`) or the web console.

See this visually by visiting the OSToy App and seeing how many boxes you now see.  It should be two.

Lastly, let's use the web console to scale back down to one pod.  Make sure you are in the project you created for this app (i.e., "ostoy"), in the left menu click *Workloads > Deployments > ostoy-microservice*.  On the left you will see a blue circle with the number 2 in the middle. Click on the down arrow to the right of that to scale the number of pods down to 1.

![UI Scale](media/managedlab/21-ostoy-uiscale.png)

See this visually by visiting the OSToy app and seeing how many boxes you now see.  It should be one.  You can also confirm this via the CLI or the web console.

{% endcollapsible %}
