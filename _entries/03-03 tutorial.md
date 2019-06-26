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

**Step 2:** Click on message box located in "Log Message (stderr)" and write any message you want outputted to the stderr stream. You can try "**Oh no! Error!**".  Then click *Send Message*.

**Step 4:** 
