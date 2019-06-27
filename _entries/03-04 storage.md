---
sectionid: storage
sectionclass: h2
title: Persistent Storage
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift (continued)

### Persistent Storage
In this section we will execute a simple example of using persistent storage by creating a file that will be stored on a persistent volume in our cluster and then confirm that it will "persist" across pod failures and recreation.

**Step 1:** Inside the OpenShift web UI click on "Storage" in the left menu and the you will see a list of all peristent volume claims that our application has made.  In this case there is just one called "shifty-pvc".  You will also see some other pertinent information such as whether it is bound or not, size, access mode and age.  

In this case it is RWO (Read-Write-Once) which means that the volume can only be mounted to one node, but the pod(s) can both read and write to that volume.  The default in ARO is for Persistent Volumes to be backed by Azure Disk, but it is possible to chose Azure Files so that you can use the RWX (Read-Write-Many) access mode.  ([See here for more info on access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)

**Step 2:** In the Shifty app click on "Persistent Storage" in the left menu.  In the "Filename" area enter a filename for the file you will create. (ie: "shifty-file.txt")

**Step 3:** Underneath that in the "File Contents" box enter in some text to be stored in the file. (ie: "Azure Red Hat OpenShift is the greatest thing since sliced bread!" or "test" :) ).  Then click "Create file".

image

**Step 4:** You will then see the file you created appear on the right under "Existing files".  Click on the file and you will see the filename and the contents you entered.

image

**Step 5:** We now want to kill the pod and ensure that the new pod that spins up will be able to see the file we created.  Click on "Home" in the left menu.

**Step 6:** Click on the "Crash pod" button.  (you can enter a message if you'd like).

**Step 7:** Click on "Perisitent Storage" in the left menu

**Step 8:** You should see the file you created is still there and you can open it to view its contents to confirm.

image


