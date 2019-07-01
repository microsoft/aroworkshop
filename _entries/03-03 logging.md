---
sectionid: logging
sectionclass: h2
title: Logging on ARO
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift

Continuing from part 2, and assuming you can access the application via the Route provided and are still logged into the CLI (please go back to part 2 if you need to do any of those) we'll start to use this application.  As stated earlier, this application will allow you to "push the buttons" of OpenShift and see how it works.

### Logging

**Step 1:** Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want outputted to the *stdout* stream.  You can try "**All is well!**".  Then click "Send Message".

![Logging stdout](/media/managedlab/8-shifty-stdout.png)

**Step 2:** Click in message box located in "Log Message (stderr)" and write any message you want to output to the *stderr* stream. You can try "**Oh no! Error!**".  Then click "Send Message".

![Logging stderr](/media/managedlab/9-shifty-stderr.png)

**Step 3:** Go to the CLI and enter the following command to retrieve the name of your frontend pod which we will use to view the pod logs:

```
[okashi@ok-vm ~]# oc get pods -o name
pod/shifty-frontend-679cb85695-5cn7x
pod/shifty-microservice-86b4c6f559-p594d
```

So the pod name in this case is **shifty-frontend-679cb85695-5cn7x**.  Then run `oc logs shifty-frontend-679cb85695-5cn7x` and you should see your messages:

```
[okashi@ok-vm Shifty]# oc logs shifty-frontend-679cb85695-5cn7x
[...]
shifty-frontend-679cb85695-5cn7x: server starting on port 8080
Redirecting to /home
stdout: All is well!
stderr: Oh no! Error!
```

You should see both the *stdout* and *stderr* messages.
