---
sectionid: network
sectionclass: h2
title: Networking and Scaling
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift (continued)

### Intra-cluster networking and scalin
In this section we'll see how Shifty uses intra-cluster networking to seperate functions out by using microservices and visualize the scaling of pods.

Let's review how this application is set up...

![Shifty Diagram](/media/managedlab/4-shifty-arch.png)

As can be seen in the image above we see we have defined at least 2 seperate pods, each with its own service.  One is the frontend web application (with a service and a publicly accessible route) and the other is the backend microservice with a service object created so that the frontend pod can communicate with the microservice.  Therefore this microservice is not accessible from outside this cluster (and due to ARO's network policy, ovs-subnet) nor from other namespaces/projects.  The sole purpose of this microservice is to serve internal web requests and returns a JSON object containing the current hostname and a randomly generated color string.  This color string is used to display a box in that color displayed in the tile to the right (titled "Intra-cluster Communication").


### Networking
**Step 1:** Click on "Networking" in the left menu

**Step 2:** The left tile titled "Hostname Lookup" illustrates how the service name created for a pod can be used to translate into an internal ClusterIP address. Enter the name of the microservice following the format of `my-svc.my-namespace.svc.cluster.local` we created in our `shifty-microservice.yaml` which can be seen here:

```
apiVersion: v1
kind: Service
metadata:
  name: shifty-microservice-svc
  labels:
    app: shifty-microservice
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
  selector:
    app: shifty-microservice
```

**Step 3:** We should see an IP address returned.  In our example it is ```172.30.237.85```.

![Shifty DNS](/media/managedlab/20-shifty-dns.png)

### Scaling
OpenShift allows one to scale up/down the number of pods for each part of an application as needed.  This can be accomplished via changing our *replicaset* definition (declarative), by the commandline (imperative), or via the web UI (imperative). In our replicaset definition (part of our `shifty-fe-deployment.yaml`) we stated that we only want one pod for our microservice to start with. This means that the Kubernetes Replication Controler will always strive to keep one pod alive.  (We can also define [autoscalling](https://docs.openshift.com/container-platform/3.11/dev_guide/pod_autoscaling.html) based on load to expand past what we defined if needed)

If we look at the tile on the right we should see one box randomly changing colors.  This box represented the randomly generated color sent to the frontend by our microservice. Since we see only one box that means there is only one microservice pod.  We will now scale our microservice pods and will see the number of boxes changing.

**Step 1:** To confirm that we only have one pod running for our microservice we can run the following command, or use the web UI.
```
[okashi@ok-vm Shifty]# oc get pods
NAME                                   READY     STATUS    RESTARTS   AGE
shifty-frontend-679cb85695-5cn7x       1/1       Running   0          1h
shifty-microservice-86b4c6f559-p594d   1/1       Running   0          1h
```

**Step 2:** Let's change our microservice definition yaml to reflect that we want 3 pods instead of the one we see.  Download the `shifty-microservice-deployment.yaml` and save it on your local machine.

**Step 3:** Open the file using your favorite editor. Ex: `vi shifty-microservice-deployment.yaml`.

**Step 4:** Find the line that states `replicas: 1` and change that to 3 and save and quit.

It will look like this
```
spec:
    selector:
      matchLabels:
        app: shifty-microservice
    replicas: 3
 ```
 
 **Step 5:** Assuming you are still logged in via the cli, execute the following command:
 
 `oc apply -f shifty-microservice-deployment.yaml`
 
 **Step 6:** Confirn that there are inded 3 pods now via the CLI or the web UI.
 
 **Step 7:** See this visually by visiting the Shifty App and seeing how many boxes you now see.  It should be three.
 
 IMAGE!
