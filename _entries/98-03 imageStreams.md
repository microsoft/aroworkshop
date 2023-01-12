---
title: ImageStreams
sectionid: imagestreams
parent-id: concepts
---

### ImageStreams

An ImageStream stores a mapping of tags to images, metadata overrides that are applied when images are tagged in a stream, and an optional reference to a Docker image repository on a registry.

#### What are the benefits

{% collapsible %}

Using an ImageStream makes it easy to change a tag for a container image.  Otherwise to change a tag you need to download the whole image, change it locally, then push it all back. Also promoting applications by having to do that to change the tag and then update the deployment object entails many steps.  With ImageStreams you upload a container image once and then you manage it’s virtual tags internally in OpenShift.  In one project you may use the `dev` tag and only change reference to it internally, in prod you may use a `prod` tag and also manage it internally. You don't really have to deal with the registry!

You can also use ImageStreams in conjunction with DeploymentConfigs to set a trigger that will start a deployment as soon as a new image appears or a tag changes its reference.

{% endcollapsible %}

See here for more details: [https://blog.openshift.com/image-streams-faq/](https://blog.openshift.com/image-streams-faq/) <br>
OpenShift Docs: [https://docs.openshift.com/aro/4/openshift_images/managing_images/managing-images-overview.html](https://docs.openshift.com/aro/4/openshift_images/managing_images/managing-images-overview.html)<br>
ImageStream and Builds: [https://cloudowski.com/articles/why-managing-container-images-on-openshift-is-better-than-on-kubernetes/](https://cloudowski.com/articles/why-managing-container-images-on-openshift-is-better-than-on-kubernetes/)


