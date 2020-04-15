---
sectionid: lab3-deploy-cdcd-demo
sectionclass: h2
title: Deploy CI/CD Demo
parent-id: lab-cicd
---

### Clone the GitHub Repo 

To deploy the CI/CD demo, you need to download the required deployment files from GitHub repository `https://github.com/nichochen/openshift-cd-demo.git`.

{% collapsible %}
On your Azure Cloud Shell, clone the OpenShift CI/CD demo repository. Currently ARO supports OpenShift 3.11, you'll need to checkout branch `azure-redhat-openshift-3.11`.

```sh
git clone https://github.com/siamaksade/openshift-cd-demo -b ocp-4.3 cicd
```
{% endcollapsible %}

### Deploy the demo 

{% collapsible %}


Now you can proceed to deploy the demo by running the script file `provision.sh`, which is under the folder `scripts`. In the following command, we specified to install Eclipse Che, and setting the project name suffix as `aro`.

```sh
./cicd/scripts/provision.sh deploy --ephemeral --project-suffix aro
```
{% endcollapsible %}

### Verify the deployment

After the deployment is completed, you can verify the newly created resources.

{% collapsible %}

Run the following command to review the list of projects.

```sh
oc get project
```

You'll see following projects are created by the demo provision script.
```sh
$ oc get project
NAME        DISPLAY NAME    STATUS
cicd-aro    CI/CD           Active
dev-aro     Tasks - Dev     Active
openshift                   Active
stage-aro   Tasks - Stage   Active

```

Confirm the status of all related containers is `Running` or `Completed`.

```sh
$ oc get pod -n cicd-aro
```

If the deployment finished successfully, you will see something similar to the following output.
```sh
NAME                        READY     STATUS      RESTARTS   AGE
che-2-l4q5k                 1/1       Running     0          2m
cicd-demo-installer-w46dp   0/1       Completed   0          1m
gogs-1-krr7x                1/1       Running     2          2m
gogs-postgresql-1-fftjn     1/1       Running     0          2m
jenkins-2-mqpwv             1/1       Running     0          3m
nexus-2-8wvwx               0/1       Running     0          2m
nexus-2-deploy              1/1       Running     0          2m
sonardb-1-4b6kg             1/1       Running     0          2m
sonarqube-1-844q7           1/1       Running     0          2m
```

From the Azure Red Hat OpenShift web console, you can see the newly created project and resources as well.

{% endcollapsible %}
