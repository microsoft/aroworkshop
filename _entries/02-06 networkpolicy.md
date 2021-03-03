---
sectionid: networkpolicy
sectionclass: h2
title: Create Network Policy
parent-id: lab-ratingapp
---

Now that you have the application working, it is time to apply some security hardening. You'll use [network policies](https://docs.openshift.com/aro/admin_guide/managing_networking.html#admin-guide-networking-networkpolicy) to restrict communication to the `mslearn-aks-workshop-ratings-api`.

### Switch to the Cluster Console

{% collapsible %}

Switch to the **Cluster Console** page. Switch to project **workshop**. Click **Create Network Policy**.
![Cluster console page](media/cluster-console4-6.png)

{% endcollapsible %}

### Create network policy

{% collapsible %}

You will create a policy that applies to any pod matching the `app=mslearn-aks-workshop-ratings-api` label. The policy will allow ingress only from pods matching the `app=mslearn-aks-workshop-ratings-web` label.

Use the YAML below in the editor, and make sure you're targeting the **workshop** project.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow-from-web
  namespace: workshop
spec:
  podSelector:
    matchLabels:
      app: mslearn-aks-workshop-ratings-api
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: mslearn-aks-workshop-ratings-web
```

![Create network policy](media/create-networkpolicy4-6.png)

Click **Create**.

{% endcollapsible %}

> **Resources**
> * [ARO Documentation - Managing Networking with Network Policy](https://docs.openshift.com/aro/admin_guide/managing_networking.html#admin-guide-networking-networkpolicy)
