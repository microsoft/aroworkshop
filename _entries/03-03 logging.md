---
sectionid: lab2-logging
sectionclass: h2
title: Logging on ARO
parent-id: lab-clusterapp
---

### Part 3: Using OSToy to become familiar with OpenShift

Continuing from part 2; assuming you can access the application via the Route provided and are still logged into the CLI (please go back to part 2 if you need to do any of those) we'll start to use this application.  As stated earlier, this application will allow you to "push the buttons" of OpenShift and see how it works.

#### Logging

**Step 1:** Click on the *Home* menu item and then click in the message box for "Log Message (stdout)" and write any message you want to output to the *stdout* stream.  You can try "**All is well!**".  Then click "Send Message".

![Logging stdout](/media/managedlab/8-ostoy-stdout.png)

**Step 2:** Click in the message box for "Log Message (stderr)" and write any message you want to output to the *stderr* stream. You can try "**Oh no! Error!**".  Then click "Send Message".

![Logging stderr](/media/managedlab/9-ostoy-stderr.png)

**Step 3:** Go to the CLI and enter the following command to retrieve the name of your frontend pod which we will use to view the pod logs:

```sh
[okashi@ok-vm ~]# oc get pods -o name
pod/ostoy-frontend-679cb85695-5cn7x
pod/ostoy-microservice-86b4c6f559-p594d
```

So the pod name in this case is **ostoy-frontend-679cb85695-5cn7x**.  Then run `oc logs ostoy-frontend-679cb85695-5cn7x` and you should see your messages:

```sh
[okashi@ok-vm ostoy]# oc logs ostoy-frontend-679cb85695-5cn7x
[...]
ostoy-frontend-679cb85695-5cn7x: server starting on port 8080
Redirecting to /home
stdout: All is well!
stderr: Oh no! Error!
```

You should see both the *stdout* and *stderr* messages.
