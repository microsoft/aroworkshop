---
sectionid: heathcheck
sectionclass: h2
title: Exploring Health Checks
parent-id: lab-clusterapp
---

## Part 3: Using OSToy to become familiar with OpenShift (continued)

### Health Checks
In this section we will intentionally crash our pods as well as make a pod non-responsive to the liveliness probes from Kubernetes and see how Kubernetes behaves.  We will first intentionally crash our pod and see that Kubernetes will self-heal and immediately spin it back up. Then we will trigger the health check by stopping the response on the `/health` endpoint in our app. After three consecutive failures Kubernetes should kill the pod and then recreate it.

**Step 1:** It would be best to prepare by splitting your screen between the OpenShift Web UI and the OSToy application so that you can see the results of our actions immediately.

![Splitscreen](/media/managedlab/23-ostoy-splitscreen.png)

But if your screen is too small or that just won't work, then open the OSToy application in another tab so you can quickly switch to OpenShift Web Console once you click the button. To get to this deployment in the OpenShift Web Console go to: 

Applications > Deployments > click the number in the "Last Version" column for the "ostoy-frontend" row

![Deploy Num](/media/managedlab/11-ostoy-deploynum.png)

**Step 2:** Go to the OSToy app, click on *Home* in the left menu, and enter a message in the "Crash Pod" tile (ie: "This is goodbye!") and press the "Crash Pod" button.  This will cause the pod to crash and Kubernetes should restart the pod. After you press the button you will see:

![Crash Message](/media/managedlab/12-ostoy-crashmsg.png)

**Step 3:** Quickly switch to the Deployment screen. You will see that the pod is red, meaning it is down but should quickly come back up and show blue.

![Pod Crash](/media/managedlab/13-ostoy-podcrash.png)

**Step 4:** You can also check in the pod events and further verify that the container has crashed and been restarted.

![Pod Events](/media/managedlab/14-ostoy-podevents.png)

**Step 5:** Keep the page from the pod events still open from step 4.  Then in the OSToy app click on the "Toggle Health" button, in the "Toggle Health Status" tile.  You will see the "Current Health" switch to "I'm not feeling all that well".

![Pod Events](/media/managedlab/15-ostoy-togglehealth.png)

This will cause the app to stop responding with a "200 HTTP code". After 3 such consecutive failures ("A"), Kubernetes will kill the pod ("B") and restart it ("C"). Quickly switch back to the pod events tab and you will see that the liveliness probe failed and the pod as being restarted.

![Pod Events2](/media/managedlab/16-ostoy-podevents2.png)
