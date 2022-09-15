# Copyright 2022 Nexient LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {

  resource_group_name  = module.resource_name["resource_group"].recommended_per_length_restriction
  storage_account_name = length(module.resource_name["storage_account"].lower_case) > var.resource_types["storage_account"].maximum_length ? module.resource_name["storage_account"].recommended_per_length_restriction : module.resource_name["storage_account"].lower_case
  sql_server_name      = module.resource_name["mssql_server"].recommended_per_length_restriction

  resource_group = {
    location = var.resource_group.location
    name     = module.resource_group.resource_group.name
  }

  storage_account = {
    name    = local.storage_account_name
    rg_name = module.resource_group.resource_group.name
  }

  default_tags = {
    provisioner = "Terraform"
  }

  tags = merge(local.default_tags, var.custom_tags)

  storage_account_properties = {
    account_tier             = var.account_tier
    account_replication_type = var.account_replication_type
    tags                     = local.tags
  }
}
