![Build and deploy](https://github.com/microsoft/aroworkshop/workflows/Build%20and%20deploy/badge.svg)

# aroworkshop.io

This is the repository for the Azure Red Hat OpenShift Workshop website.

## Technology

- The website is statically built using Jekyll and you’ll find the different pages inside the `_entries` folder
- The build pipeline builds uses GitHub Actions to publish to the `gh-pages` branch which gets published to [microsoft.github.io/aroworkshop/](https://microsoft.github.io/aroworkshop/)

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
