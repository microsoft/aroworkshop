# aroworkshop.io

This is the repository for the Azure Red Hat OpenShift Workshop website.

## Technology

- The website is statically built using Jekyll and you’ll find the different pages inside the `_entries` folder
- You can preview your edits locally if you run `make build-run` inside the repository root
- The build pipeline builds Docker images of the site and hosts it on a private repository on Azure Container Registry (`msworkshops.azurecr.io`)
- The website is running on an [Azure Web App for Containers](https://azure.microsoft.com/en-us/services/app-service/containers/)
- The `master` branch gets deployed to the production slot [aroworkshop.io](http://aroworkshop.io)
- The `staging` branch gets deployed to the staging slot [staging.aroworkshop.io](http://staging.aroworkshop.io)

## Companion repositories

The application consists of 3 components:

| Component                                           | Link                                                              |
|-----------------------------------------------------|-------------------------------------------------------------------|
| A public facing web frontend `rating-web`          | [GitHub repo](https://github.com/microsoft/rating-web)         |
| A public facing API `rating-api`                   | [GitHub repo](https://github.com/microsoft/rating-api)         |
| A MongoDB with pre-loaded data                      |                 |

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

 Please fork and branch off `staging`, then submit a Pull Request against `staging`.
 If you want your name to show up in the [contributors](http://aroworkshop.io/#contributors), please add your GitHub username to `_entries/99 Contributors.md` in alphabetical order.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
