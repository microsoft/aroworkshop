---
sectionid: config
sectionclass: h2
title: Configuration
parent-id: lab-clusterapp
---

## Part 3: Using Shifty to become familiar with OpenShift (continued)

### Ways to configure applications
In this section we'll take a look at how Shifty can be configured using [ConfigMaps](https://docs.openshift.com/container-platform/3.11/dev_guide/configmaps.html), [Secrets](https://docs.openshift.com/container-platform/3.11/dev_guide/secrets.html), and [Environment Variables](https://docs.openshift.com/container-platform/3.11/dev_guide/environment_variables.html).  This section won't go into details explaining each, but show you how they are exposed to the application.  Click the links above if you want to find out more about each or you can also go to the Kubernetes documentation.

### ConfigMaps
ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

**Step 1:** Click on "Config Maps" on the left menu

**Step 2:** This will display the contents of the configmap available to the Shifty application.  We defined this in the `shifty-fe-deployment.yaml` here:

```
kind: ConfigMap
apiVersion: v1
metadata:
  name: shifty-configmap-files
data:
  config.json:  '{ "default": "123" }'
```


### Secrets
Kubernetes Secret objects allow you to store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it, verbatim, into a Pod definition or a container image.

**Step 1:** Click on "Secrets" in the left menu.

**Step 2:** This will display the contents of the secrets available to the Shifty application.  We defined this in the `shifty-fe-deployment.yaml` here:

```
apiVersion: v1
kind: Secret
metadata:
  name: shifty-secret
data:
  secret.txt: VVNFUk5BTUU9bXlfdXNlcgpQQVNTV09SRD1AT3RCbCVYQXAhIzYzMlk1RndDQE1UUWsKU01UUD1sb2NhbGhvc3QKU01UUF9QT1JUPTI1
type: Opaque
```


### Environment Variables
Using environment variables is an easy way to change application behavior without requiring code changes. It allows different deployments of the same application to potentially behave differently based on the environment variables, and OpenShift makes it simple to set, view, and update environment variables for Pods/Deployments. 

**Step 1:** Click on the "ENV Variables" in the left menu

**Step 2:** This will display the contents of the secrets available to the Shifty application.  We added three as defined in the deployment spec of `shifty-fe-deployment.yaml` here:

```
  env:
  - name: ENV_TOY_CONFIGMAP
    valueFrom:
      configMapKeyRef:
        name: shifty-configmap-env
        key: ENV_TOY_CONFIGMAP
  - name: ENV_TOY_SECRET
    valueFrom:
      secretKeyRef:
        name: shifty-secret-env
        key: ENV_TOY_SECRET
  - name: MICROSERVICE_NAME
    value: SHIFTY_MICROSERVICE_SVC
```

The last one, `MICROSERVICE_NAME` is used for the intra-cluster communications between pods for this application.  This  tells the application how to access the microservice.   ****ADD MORE DETIALS FROM WILL****
