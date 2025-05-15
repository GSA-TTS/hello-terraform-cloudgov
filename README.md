# hello-terraform-cloudgov
A TTS-flavored [Copier](https://copier.readthedocs.io/) template for creating and maintaining a Terraform module that deploys of a set of applications onto cloud.gov

## Why this project

This template supports scaffolding *and maintaining* a Terraform module that will deploy a set of applications onto cloud.gov, configured to the local tastes of TTS.

It's usable standalone, but you'll have to explicitly answer questions about your system and applications. It's really intended to be used in composition with [other `GSA-TTS/hello-*` templates](https://github.com/orgs/GSA-TTS/repositories?type=all&q=hello-) which specify those answers for this template.

## Status

Copying the template works, but the resulting Terraform module is not yet working.

## Features
- Provides utilities for bootstrapping Terraform state into a cloud.gov S3 bucket
- Deploys to either your unmanaged sandbox space, or to managed staging and production spaces

## Requirements
- [uv](https://docs.astral.sh/uv/getting-started/installation/) (for running Copier)
- [git](https://git-scm.com/)

## Usage

### Creating a system module
1. [Install uv](https://docs.astral.sh/uv/getting-started/installation/) (if you haven't already)
2. Generate a new project...\
  ...from your local clone of the repository:
   ```sh
   uvx copier copy --trust ./hello-terraform-cloudgov <destination-folder>
   ```
   ...or directly from the repository on GitHub:
   ```sh
   uvx copier copy --trust gh:GSA-TTS/hello-terraform-cloudgov <destination-folder>
   ```
3. Answer the prompts:
   - Name the system
   - Enable space management, if you have a target org
   - Describe your applications, using JSON

### Updating the module later

If you'd like to...

- change your answers or 
- incorporate improvements made after you copied this template

...you can run the Copier `update` command: 

1. Make sure that your destination folder contains no uncommitted changes 
2. Update your destination folder from the template
    ```
    uvx copier update --trust <destination-folder>
    ```

To learn how updating works and what additional options are available, read [the Copier `update` documentation](https://copier.readthedocs.io/en/stable/updating/) .

## Tasks
After copying, the following tasks are run automatically in the destination folder:
- `git init .`

Follow instructions in the README.md in the destination folder to work with the new module.

## Directory Structure
- `templates/terraform/`: Template for the module, with an included standalone module for bootstrapping Terraform state into an S3 bucket.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
