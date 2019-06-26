---
sectionid: appoverview
sectionclass: h2
title: Becoming Familiar with OpenShift
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift


Continuing from part 2, and assuming you can access the application via the Route provided and are still logged into the CLI (Please go back to Part 2 if you need to do any of those) lets become familiar with this application.  As stated earlier this application will allow you to "push the buttons" of OpenShift and see how it works.

### Familiarization with the Application UI
  1. Shows the pod name that served your browser the page.
  2. Home: The main page of the applicaiton where you can perform some of the functions listed which we will explore.
  3. Persistent Storage:  Allows us to write data to the persistent volume bound to this application.
  4. Config Maps:  Shows the contents of configmaps available to the application and the key:value pairs.
  5. Secrets: Shows the contents of secrets available to the application and the key:value pairs.
  6. ENV Variables: Shows the environment varaibles available to the application.
  7. Networking: Tools to illustrate networking within the application.
  8. Shows some more information about the application.

### Logging

**Step 1:** Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want outputted to the stdout stream.  You can try "**All is well!**".  Then click *Send Message*.

![Logging stdout](/media/managedlab/8-shifty-stdout.png)

**Step 2:** Click on message box located in "Log Message (stderr)" and write any message you want outputted to the stderr stream. You can try "**Oh no! Error!**".  Then click *Send Message*.

![Logging stderr](/media/managedlab/9-shifty-stderr.png)

**Step 3:** Go to the CLI and enter the following command to retrieve the name of your frontend pod

```[okashi@ok-vm ~]# oc get pods -o name
pod/shifty-frontend-5bf5dcfcdc-x9snr
pod/shifty-microservice-86b4c6f559-p594d```

So the pod name in this case is **shifty-frontend-5bf5dcfcdc-x9snr**

Then run `oc get logs shifty-frontend-5bf5dcfcdc-x9snr` and you should see your message

```[okashi@ok-vm ~]# oc logs shifty-frontend-5bf5dcfcdc-x9snr
Responding to /health endpoint healthy
Responding to /health endpoint healthy
**stdout: All is well!**
Responding to /health endpoint healthy
```
