---
sectionid: scaling
sectionclass: h2
title: Scaling
parent-id: lab-ratingapp
---

### Scaling deployments
{% collapsible %}

{% endcollapsible %}

### Scale the Azure Red Hat OpenShift cluster

You can scale the number of application nodes in the cluster using the Azure CLI.

{% collapsible %}

Run the below on the [Azure Cloud Shell](https://shell.azure.com) to scale your cluster to 5 application nodes. Replace `<cluster name>` and `<resource group name>` with your applicable values. After a few minutes, `az openshift scale` will complete successfully and return a JSON document containing the scaled cluster details.

```sh
az openshift scale  --name <cluster name> --resource-group <resource group name> --compute-count 5
```

{% endcollapsible %}

> **Resources**
> * <https://docs.microsoft.com/en-us/azure/openshift/tutorial-scale-cluster>