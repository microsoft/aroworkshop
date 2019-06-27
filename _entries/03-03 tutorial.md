---
sectionid: appoverview
sectionclass: h2
title: Becoming Familiar with OpenShift
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift

Continuing from part 2, and assuming you can access the application via the Route provided and are still logged into the CLI (Please go back to Part 2 if you need to do any of those) lets become familiar with this application.  As stated earlier this application will allow you to "push the buttons" of OpenShift and see how it works.

### Logging

**Step 1:** Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want outputted to the stdout stream.  You can try "**All is well!**".  Then click *Send Message*.

![Logging stdout](/media/managedlab/8-shifty-stdout.png)

**Step 2:** Click on message box located in "Log Message (stderr)" and write any message you want outputted to the stderr stream. You can try "**Oh no! Error!**".  Then click *Send Message*.

![Logging stderr](/media/managedlab/9-shifty-stderr.png)

**Step 3:** Go to the CLI and enter the following command to retrieve the name of your frontend pod which we will use to view the pod logs:

```
[okashi@ok-vm ~]# oc get pods -o name
pod/shifty-frontend-679cb85695-5cn7x
pod/shifty-microservice-86b4c6f559-p594d
```

So the pod name in this case is **shifty-frontend-679cb85695-5cn7x**.  Then run `oc get logs shifty-frontend-679cb85695-5cn7x` and you should see your messages:

```
[okashi@ok-vm Shifty]# oc logs shifty-frontend-679cb85695-5cn7x
[...]
shifty-frontend-679cb85695-5cn7x: server starting on port 8080
Redirecting to /home
stdout: All is well!
stderr: Oh no! Error!
```

You should see both the stdout and std error messages.

### Health Checks

**Step 1:** It would be best to prepare the OpenShift Web UI in either split-screen or at least open in another tab so you can quickly switch to it once you click the button. To get to this deployment in the UI go to: 

Applications > Deployments > click the number in the "Last Version" column for the "shifty-frontend" row

![Deploy Num](/media/managedlab/11-shifty-deploynum.png)

**Step 2:** Go back to the Shifty app and enter a message in the "Crash Pod" tile and press the Crash Pod button.  This will cause the pod to crash and Kubernetes should restart the pod. After you press the button you will see:

![Crash Message](/media/managedlab/12-shifty-crashmsg.png)

**Step 3:** Quickly switch to the Deplyoment screen you will see that the pod is red, meaning it is down but should quickly come back up and show blue.

![Pod Crash](/media/managedlab/13-shifty-podcrash.png)

**Step 4:** You can also check in the pod events and further verify that the container has crashed and been restarted.

![Pod Events](/media/managedlab/14-shifty-podevents.png)
