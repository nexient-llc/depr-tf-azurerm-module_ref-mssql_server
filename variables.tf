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

#################################################
#Variables associated with resource naming module
##################################################

variable "logical_product_name" {
  type        = string
  description = "(Required) Name of the application for which the resource is created."
  nullable    = false

  validation {
    condition     = length(trimspace(var.logical_product_name)) <= 15 && length(trimspace(var.logical_product_name)) > 0
    error_message = "Length of the logical product name must be between 1 to 15 characters."
  }
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For ex. dev, qa, uat"
  nullable    = false

  validation {
    condition     = length(trimspace(var.class_env)) <= 15 && length(trimspace(var.class_env)) > 0
    error_message = "Length of the environment must be between 1 to 15 characters."
  }

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 1 to 999."
  }
}


variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 1 to 100."
  }
}

variable "use_azure_region_abbr" {
  description = "Whether to use region abbreviation e.g. eastus -> eus"
  type        = bool
  default     = false
}

variable "resource_types" {
  description = "Map of cloud resource types to be used in this module"
  type = map(object({
    type           = string
    maximum_length = number
  }))

  default = {
    "resource_group" = {
      type           = "rg"
      maximum_length = 63
    }
    "storage_account" = {
      type           = "sa"
      maximum_length = 24
    }
    "mssql_server" = {
      type           = "dbser"
      maximum_length = 60
    }
  }
}

#################################################
#Variables associated with resource group module
##################################################
variable "resource_group" {
  description = "resource group primitive options"
  type = object({
    location = string
  })
  validation {
    condition     = length(regexall("\\b \\b", var.resource_group.location)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

########################################################
# Variables associated with storage account module
########################################################

variable "account_tier" {
  description = "The account_tier of the Storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The Replication type of the storage account"
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "Choose between Hot or Cool"
  type        = string
  default     = "Hot"
  validation {
    condition     = (contains(["Hot", "Cold"], var.access_tier))
    error_message = "The access_tier must be either \"Hot\" or \"Cold\"."
  }

}

variable "account_kind" {
  description = "Defines the kind of account"
  type        = string
  default     = "StorageV2"
}

########################################################
# Variables associated with MS SQL Server module
########################################################

variable "sql_server_version" {
  description = "Version of the Microsoft SQL server"
  type        = string
  default     = "12.0"
  validation {
    condition     = contains(["2.0", "12.0"], var.sql_server_version)
    error_message = "The sql_server_version must be one of '2.0' or '12.0'."
  }
}

variable "administrator_login_username" {
  description = "The admin username for the server"
  type        = string
  sensitive   = true
}

variable "administrator_login_password" {
  description = "The admin password for the server. If no value is provided by user, then a random password would be generated"
  type        = string
  sensitive   = true
  default     = ""
}

variable "password_length" {
  description = "The length of the random generated password."
  type        = number
  default     = 16
}

variable "connection_policy" {
  description = "The connection policy for the server. Possible values are Default, Proxy or Redirect"
  type        = string
  default     = "Default"
  validation {
    condition     = contains(["Default", "Proxy", "Redirect"], var.connection_policy)
    error_message = "The connection_policy must be one of 'Default', 'Proxy' or 'Redirect'."
  }
}

variable "enable_system_managed_identity" {
  description = "Should the system managed identity be enabled for SQL Server?"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for the server. Default is 1.2. Possible values are 1.0, 1.1, 1.2 or Disabled"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2", "Disabled"], var.minimum_tls_version)
    error_message = "The minimum_tls_version must be one of '1.0', '1.1', '1.2' or 'Disabled'."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for this server? Defaults to true"
  type        = bool
  default     = true
}

variable "outbound_network_restriction_enabled" {
  description = "Whether outbound network traffic is restricted for this server. Defaults to false"
  type        = bool
  default     = false

}

variable "extended_auditing_enabled" {
  description = "Whether the extended auditing should be enabled?"
  type        = bool
  default     = true
}

variable "retention_in_days" {
  description = "Number of days to retain the logs in the storage account. Required if extended_auditing_enabled=true"
  type        = number
  default     = 30
}

variable "allow_access_to_azure_services" {
  description = "If true, it enables all the azure services to access the database server. "
  type        = bool
  default     = true
}

variable "allow_firewall_ip_list" {
  description = "A list of IP Address to whitelist, in order to access the database server"
  type        = list(string)
  default     = []
}

variable "allow_firewall_ip_ranges_list" {
  description = "A list of IP Address ranges to whitelist, in order to access the database server"
  type = list(object({
    start_ip_address = string
    end_ip_address   = string
  }))

  default = []
}

variable "custom_tags" {
  description = "A map of custom tags to be attached to this SQL Server instance"
  type        = map(string)
  default     = {}
}
