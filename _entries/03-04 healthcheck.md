---
sectionid: heathcheck
sectionclass: h2
title: Exploring Health Checks
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift (continued)

### Health Checks
In this section we will play with intentionally crashing our pods as well as making the pods non-responsive to the liveliness probes from Kubernetes and see how Kubernetes behaves.  We will first intentionally crash our pod and see how Kubernetes will immediately spin it back up and then we will trigger the health check buy stopping the response on the `/heatlh` endpoint in our app.  After three failures Kubernetes should kill the pod and then recreate it.


**Step 1:** It would be best to prepare the OpenShift Web UI in either split-screen or at least open in another tab so you can quickly switch to it once you click the button. To get to this deployment in the UI go to: 

Applications > Deployments > click the number in the "Last Version" column for the "shifty-frontend" row

![Deploy Num](/media/managedlab/11-shifty-deploynum.png)

**Step 2:** Go back to the Shifty app and enter a message in the "Crash Pod" tile and press the Crash Pod button.  This will cause the pod to crash and Kubernetes should restart the pod. After you press the button you will see:

![Crash Message](/media/managedlab/12-shifty-crashmsg.png)

**Step 3:** Quickly switch to the Deplyoment screen you will see that the pod is red, meaning it is down but should quickly come back up and show blue.

![Pod Crash](/media/managedlab/13-shifty-podcrash.png)

**Step 4:** You can also check in the pod events and further verify that the container has crashed and been restarted.

![Pod Events](/media/managedlab/14-shifty-podevents.png)
