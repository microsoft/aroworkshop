---
sectionid: config
sectionclass: h2
title: Configuration
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift (continued)

### Ways to configure applications
In this section well take a look at what ways Shifty can be configured using [ConfigMaps](https://docs.openshift.com/container-platform/3.11/dev_guide/configmaps.html), [Secrets](https://docs.openshift.com/container-platform/3.11/dev_guide/secrets.html), and [Environment Variables](https://docs.openshift.com/container-platform/3.11/dev_guide/environment_variables.html).  This section won't go into details explaining each but just how they are exposed for you to view through the applcation.  Click the links above if you want to find out more about each or you can also go to the Kubernetes documentation.

### ConfigMaps
**Step 1:** Click on Config Maps on the left menu

**Step 2:** This will display the contents of the configmap available to the Shifty application.  We defined this in the `shifty-fe-deployment.yaml` here:

```
kind: ConfigMap
apiVersion: v1
metadata:
  name: shifty-configmap-files
data:
  config.json:  '{ "default": "123" }'
```

If we wanted to add some more key-value pairs we could do so right there and then issues the `oc apply..` command to be able to utilize the additions.

### Secrets
Kubernetes secret objects let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it verbatim in a Pod definition or in a container image .
