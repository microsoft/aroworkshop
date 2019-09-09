---
sectionid: lab3-cloud-native-ide
sectionclass: h2
title: Cloud Native IDE
parent-id: lab-cicd
---

To provide your development team a cloud native experience, you can leverge the power of cloud native IDE. Eclipse Che is an open-source web based IDE. It supports multi-users and wide range of programming languages and frameworks.

### Launch Eclipse Che

Please launch Eclipse Che and create a workspace for the demo application .
{% collapsible %}

Get the Route for Eclipse Che with following command.

```sh
oc get route -n cicd-aro che
```

You will see some output similar as followig.

```sh
NAME      HOST/PORT                                                 PATH      SERVICES   PORT      TERMINATION   WILDCARD
che       che-cicd-aro.apps.xxxxxx.eastus.azmosa.io             che-host   http                    None                                                                                                                                              
```
To access Eclipse Che web console, open the URL which is indicated by  `HOST/PORT` in a web browser.

On the Eclipse Che, select the `Blank` stack, and click button `CREATE & OPEN` to create a blank workspace.

![Eclipse Che UI](media/che-ui.png)

It will take some time for Eclipse Che to setup the workspace. Wait until the workspace is ready, then you can proceed to the next task.
{% endcollapsible %}

### Check Out Source Code

After the Eclipse Che workspace is ready, please check out the source code of the demo application on Eclipse Che.

{% collapsible %}

Check out the Route URL of Gogs server. Gogs is a light-weight self-hosted Git service. 

```sh
$ oc get route -n cicd-aro gogs
```

Please login to Gogs as user `gogs` with password `gogs`. Copy the address of the repository `openshift-tasks`.

![Gogs Repo](media/gogs-repo.png)

Back to Eclipse Che, click `Import Project` from menu `Workspace` to import the source code from the remote repository. Make sure select `GIT` as the version control system, paste the repository URL which you copied from Gogs into the filed `URL`. Check the Branch checkbox, and put `eap-7` in the textbox for branch. Click button `import`, in the next screen, select `Maven` for project configuration.

![Check out source code](media/che-import.png)
{% endcollapsible %}
### Change and Deploy

Please make some changes to the demo application, and commit the changes to the remote Git repository.

{% collapsible %}

Open file `src` > `main` > `webapp` > `index.jsp`. Change line 7 and line 45 from `OpenShift Tasks Demo` to `Azure Red Hat OpenShift Tasks Demo`. Then save the changes.

Before you can commit your changes to Git, you need to setup your Git profile. From top menu `Profile`, select menu item `Preferences`. In the `Preferences` dialog, click `Committer` which is under the section `Git`. Put in user name `gogs` and email `admin@gogs.com`. Click button `save`, then button `close`, to save the changes and close the dialog.

![Code change](media/che-codechange.png)


Next, you need to commit the changes. Click menu item `Commit` from menu `Git` which is at the top. Put 'Update title' in the comment text area. Click button `commit` to commit the changes.

In the `Terminal` window, which is down at the button in the Eclipse Che window, run following commands to push the changes to remote Gogs Git repository. You will be asked to enter the user name and password for the repository, which are both `gogs`.

```sh
$ cd openshift-tasks/
$ git push origin
```
{% endcollapsible %}

### Verify the update

After pushing the commit to the remote repository, the CICD pipeline will be triggered automatically. You will see a new pipeline execution has been launched for the new commit. After the execution finished successfully, you will be able to see your changes on the web page of the application.

From this example you can see, it's easy to build up a CICD pipeline with Open Source tool chains and Azure Red Hat OpenShift. With container & cloud based CICD, application development and delivery are significantly accelerated.

