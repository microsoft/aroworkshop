# aroworkshop.io

This is the repository for the Azure Red Hat OpenShift Workshop website.

## Technology

- The website is statically built using Jekyll and you’ll find the different pages inside the `_entries` folder.
- If you’re on a Mac/Linux machine, you can preview your edits locally if you run `make build-run` inside the repo root.
- The build pipeline builds Docker images of the site and hosts it as a private repository on Azure Container Registry (`msworkshops.azurecr.io`).
- The release pipeline deploys the Docker image to an Azure Web App.

## Branching and contribution

- The `master` branch gets published to [aroworkshop.io](http://aroworkshop.io).
- The `staging` branch gets published to [staging.aroworkshop.io](http://staging.aroworkshop.io).
- Please branch off `staging` if you want to contribute, then submit a Pull Request to `staging`.
- If you want your name to show up in the [contributors](http://aroworkshop.io/#contributors), please add your GitHub username to `_entries/Contributors.md` in alphabetical order.