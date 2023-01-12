---
title: Builds
sectionid: builds
parent-id: concepts
---

### Builds

A build is the process of transforming input parameters into a resulting object. Most often, the process is used to transform input parameters or source code into a runnable image. A BuildConfig object is the definition of the entire build process.

OpenShift Container Platform leverages Kubernetes by creating Docker-formatted containers from build images and pushing them to a container image registry.

Build objects share common characteristics: inputs for a build, the need to complete a build process, logging the build process, publishing resources from successful builds, and publishing the final status of the build. Builds take advantage of resource restrictions, specifying limitations on resources such as CPU usage, memory usage, and build or pod execution time.

See here for more details: [https://docs.openshift.com/aro/4/openshift_images/image-streams-manage.html](https://docs.openshift.com/aro/4/openshift_images/image-streams-manage.html)
