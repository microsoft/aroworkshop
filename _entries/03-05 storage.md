---
sectionid: lab2-storage
sectionclass: h2
title: Persistent Storage
parent-id: lab-clusterapp
---

### Part 3: Using OSToy to become familiar with OpenShift (continued)

#### Persistent Storage

In this section we will execute a simple example of using persistent storage by creating a file that will be stored on a persistent volume in our cluster and then confirm that it will "persist" across pod failures and recreation.

**Step 1:** Inside the OpenShift web UI click on *Storage* in the left menu. You will then see a list of all persistent volume claims that our application has made.  In this case there is just one called "ostoy-pvc".  You will also see other pertinent information such as whether it is bound or not, size, access mode and age.  

In this case the mode is RWO (Read-Write-Once) which means that the volume can only be mounted to one node, but the pod(s) can both read and write to that volume.  The default in ARO is for Persistent Volumes to be backed by Azure Disk, but it is possible to chose Azure Files so that you can use the RWX (Read-Write-Many) access mode.  ([See here for more info on access modes](https://docs.openshift.com/aro/architecture/additional_concepts/storage.html#pv-access-modes))

**Step 2:** In the OSToy app click on *Persistent Storage* in the left menu.  In the "Filename" area enter a filename for the file you will create. (ie: "test-pv.txt")

**Step 3:** Underneath that, in the "File Contents" box, enter text to be stored in the file. (ie: "Azure Red Hat OpenShift is the greatest thing since sliced bread!" or "test" :) ).  Then click "Create file".

![Create File](/media/managedlab/17-ostoy-createfile.png)

**Step 4:** You will then see the file you created appear above under "Existing files".  Click on the file and you will see the filename and the contents you entered.

![View File](/media/managedlab/18-ostoy-viewfile.png)

**Step 5:** We now want to kill the pod and ensure that the new pod that spins up will be able to see the file we created. Exactly like we did in the previous section. Click on *Home* in the left menu.

**Step 6:** Click on the "Crash pod" button.  (You can enter a message if you'd like).

**Step 7:** Click on *Persistent Storage* in the left menu

**Step 8:** You will see the file you created is still there and you can open it to view its contents to confirm.

![Crash Message](/media/managedlab/19-ostoy-existingfile.png)