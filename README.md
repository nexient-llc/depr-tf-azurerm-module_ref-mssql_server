# tf-azurerm-module_ref-mssql_server

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform reference architecture module with provision a MS SQL Server on Azure Portal. It can create an optional extended audit policy to store the audit logs for the server as well as the databases on this server. It also creates the firewall rules to white list range of ip-addresses which can access this server.

List of dependent infrastructure created by this module are as follows
- Resource group (tf-azurerm-module-resource_group)
- Storage account (tf-azurerm-module-storage_account) : Used to store audit logs

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# Terradocs
Below are the details that are generated by Terradocs plugin. It contains information about the module, inputs, outputs etc.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_name"></a> [resource\_name](#module\_resource\_name) | github.com/nexient-llc/tf-module-resource_name.git | 0.2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | github.com/nexient-llc/tf-azurerm-module-resource_group.git | 0.1.0 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | github.com/nexient-llc/tf-azurerm-module-storage_account.git | 0.2.0 |
| <a name="module_mssql_server"></a> [mssql\_server](#module\_mssql\_server) | github.com/nexient-llc/tf-azurerm-module-mssql_server.git | 0.1.1 |

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_name"></a> [logical\_product\_name](#input\_logical\_product\_name) | (Required) Name of the application for which the resource is created. | `string` | n/a | yes |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For ex. dev, qa, uat | `string` | n/a | yes |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_use_azure_region_abbr"></a> [use\_azure\_region\_abbr](#input\_use\_azure\_region\_abbr) | Whether to use region abbreviation e.g. eastus -> eus | `bool` | `false` | no |
| <a name="input_resource_types"></a> [resource\_types](#input\_resource\_types) | Map of cloud resource types to be used in this module | <pre>map(object({<br>    type           = string<br>    maximum_length = number<br>  }))</pre> | <pre>{<br>  "mssql_server": {<br>    "maximum_length": 60,<br>    "type": "dbser"<br>  },<br>  "resource_group": {<br>    "maximum_length": 63,<br>    "type": "rg"<br>  },<br>  "storage_account": {<br>    "maximum_length": 24,<br>    "type": "sa"<br>  }<br>}</pre> | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | resource group primitive options | <pre>object({<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | The account\_tier of the Storage account | `string` | `"Standard"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | The Replication type of the storage account | `string` | `"LRS"` | no |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Choose between Hot or Cool | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the kind of account | `string` | `"StorageV2"` | no |
| <a name="input_sql_server_version"></a> [sql\_server\_version](#input\_sql\_server\_version) | Version of the Microsoft SQL server | `string` | `"12.0"` | no |
| <a name="input_administrator_login_username"></a> [administrator\_login\_username](#input\_administrator\_login\_username) | The admin username for the server | `string` | n/a | yes |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The admin password for the server. If no value is provided by user, then a random password would be generated | `string` | `""` | no |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | The length of the random generated password. | `number` | `16` | no |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy for the server. Possible values are Default, Proxy or Redirect | `string` | `"Default"` | no |
| <a name="input_enable_system_managed_identity"></a> [enable\_system\_managed\_identity](#input\_enable\_system\_managed\_identity) | Should the system managed identity be enabled for SQL Server? | `bool` | `true` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version for the server. Default is 1.2. Possible values are 1.0, 1.1, 1.2 or Disabled | `string` | `"1.2"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is enabled for this server? Defaults to true | `bool` | `true` | no |
| <a name="input_outbound_network_restriction_enabled"></a> [outbound\_network\_restriction\_enabled](#input\_outbound\_network\_restriction\_enabled) | Whether outbound network traffic is restricted for this server. Defaults to false | `bool` | `false` | no |
| <a name="input_extended_auditing_enabled"></a> [extended\_auditing\_enabled](#input\_extended\_auditing\_enabled) | Whether the extended auditing should be enabled? | `bool` | `true` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain the logs in the storage account. Required if extended\_auditing\_enabled=true | `number` | `30` | no |
| <a name="input_allow_access_to_azure_services"></a> [allow\_access\_to\_azure\_services](#input\_allow\_access\_to\_azure\_services) | If true, it enables all the azure services to access the database server. | `bool` | `true` | no |
| <a name="input_allow_firewall_ip_list"></a> [allow\_firewall\_ip\_list](#input\_allow\_firewall\_ip\_list) | A list of IP Address to whitelist, in order to access the database server | `list(string)` | `[]` | no |
| <a name="input_allow_firewall_ip_ranges_list"></a> [allow\_firewall\_ip\_ranges\_list](#input\_allow\_firewall\_ip\_ranges\_list) | A list of IP Address ranges to whitelist, in order to access the database server | <pre>list(object({<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | A map of custom tags to be attached to this SQL Server instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sql_server_id"></a> [sql\_server\_id](#output\_sql\_server\_id) | ID of the MS Sql Server |
| <a name="output_sql_server_fqdn"></a> [sql\_server\_fqdn](#output\_sql\_server\_fqdn) | FQDN of the MS Sql Server |
| <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name) | Name of the MS Sql Server |
| <a name="output_admin_login_username"></a> [admin\_login\_username](#output\_admin\_login\_username) | Admin Login Username of the MS Sql Server |
| <a name="output_admin_login_password"></a> [admin\_login\_password](#output\_admin\_login\_password) | Admin Login Password of the MS Sql Server |
| <a name="output_restorable_dropped_database_ids"></a> [restorable\_dropped\_database\_ids](#output\_restorable\_dropped\_database\_ids) | A list of dropped restorable database IDs on this server |
| <a name="output_identity_pricipal_id"></a> [identity\_pricipal\_id](#output\_identity\_pricipal\_id) | System Assigned Identity Principal ID |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group in which the MS SQL Server is provisioned |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account for audit logs of the SQL Server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
