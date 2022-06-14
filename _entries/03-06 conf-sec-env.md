---
sectionid: lab2-config
sectionclass: h2
title: Configuration
parent-id: lab-clusterapp
---

In this section we'll take a look at how OSToy can be configured using [ConfigMaps](https://docs.openshift.com/container-platform/4.10/nodes/pods/nodes-pods-configmaps.html), [Secrets](https://docs.openshift.com/container-platform/4.10/cicd/builds/creating-build-inputs.html#builds-input-secrets-configmaps_creating-build-inputs), and [Environment Variables](https://docs.openshift.com/container-platform/3.11/dev_guide/environment_variables.html).  This section won't go into details explaining each (the links above are for that), but will show you how they are exposed to the application.  

### Configuration using ConfigMaps

ConfigMaps allow you to decouple configuration artifacts from container image content to keep containerized applications portable.

{% collapsible %}

Click on *Config Maps* in the left menu.

This will display the contents of the configmap available to the OSToy application.  We defined this in the `ostoy-fe-deployment.yaml` here:

```
kind: ConfigMap
apiVersion: v1
metadata:
  name: ostoy-configmap-files
data:
  config.json:  '{ "default": "123" }'
```

{% endcollapsible %}

### Configuration using Secrets

Kubernetes Secret objects allow you to store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it, verbatim, into a pod definition or a container image.

{% collapsible %}

Click on *Secrets* in the left menu.

This will display the contents of the secrets available to the OSToy application.  We defined this in the `ostoy-fe-deployment.yaml` here:

```
apiVersion: v1
kind: Secret
metadata:
  name: ostoy-secret
data:
  secret.txt: VVNFUk5BTUU9bXlfdXNlcgpQQVNTV09SRD1AT3RCbCVYQXAhIzYzMlk1RndDQE1UUWsKU01UUD1sb2NhbGhvc3QKU01UUF9QT1JUPTI1
type: Opaque
```

{% endcollapsible %}

### Configuration using Environment Variables

Using environment variables is an easy way to change application behavior without requiring code changes. It allows different deployments of the same application to potentially behave differently based on the environment variables, and OpenShift makes it simple to set, view, and update environment variables for Pods/Deployments.

{% collapsible %}

Click on *ENV Variables* in the left menu.

This will display the environment variables available to the OSToy application.  We added three as defined in the deployment spec of `ostoy-fe-deployment.yaml` here:

```
  env:
  - name: ENV_TOY_CONFIGMAP
    valueFrom:
      configMapKeyRef:
        name: ostoy-configmap-env
        key: ENV_TOY_CONFIGMAP
  - name: ENV_TOY_SECRET
    valueFrom:
      secretKeyRef:
        name: ostoy-secret-env
        key: ENV_TOY_SECRET
  - name: MICROSERVICE_NAME
    value: OSTOY_MICROSERVICE_SVC
```

The last one, `MICROSERVICE_NAME` is used for the intra-cluster communications between pods for this application.  The application looks for this environment variable to know how to access the microservice in order to get the colors.

{% endcollapsible %}
