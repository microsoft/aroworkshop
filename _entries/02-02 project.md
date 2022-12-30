---
sectionid: createproject
sectionclass: h2
title: Create Project
parent-id: lab-ratingapp
---

### Create a project

{% collapsible %}

A project allows a community of users to organize and manage their content in isolation from other communities. A project has a 1-to-1 mapping with a standard Kubernetes namespace.

```sh
oc new-project workshop
```

![Create new project](media/oc-newproject.png)

{% endcollapsible %}

> **Resources**
> * [ARO Documentation - Getting started with the CLI](https://docs.openshift.com/aro/4/cli_reference/openshift_cli/getting-started-cli.html)
> * [ARO Documentation - Projects](https://docs.openshift.com/aro/4/applications/projects/working-with-projects.html)
