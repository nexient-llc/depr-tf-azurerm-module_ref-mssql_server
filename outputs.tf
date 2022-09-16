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

output "sql_server_id" {
  description = "ID of the MS Sql Server"
  value       = module.mssql_server.sql_server_id
}

output "sql_server_fqdn" {
  description = "FQDN of the MS Sql Server"
  value       = module.mssql_server.sql_server_fqdn
}

output "sql_server_name" {
  description = "Name of the MS Sql Server"
  value       = module.mssql_server.name
}

output "admin_login_username" {
  description = "Admin Login Username of the MS Sql Server"
  value       = module.mssql_server.admin_login_username
  sensitive   = true
}

output "admin_login_password" {
  description = "Admin Login Password of the MS Sql Server"
  value       = module.mssql_server.admin_login_password
  sensitive   = true
}

output "restorable_dropped_database_ids" {
  description = "A list of dropped restorable database IDs on this server"
  value       = module.mssql_server.restorable_dropped_database_ids
}

output "identity_pricipal_id" {
  description = "System Assigned Identity Principal ID"
  value       = try(module.mssql_server.identity_pricipal_id, "")

}

output "resource_group_name" {
  description = "Name of the resource group in which the MS SQL Server is provisioned"
  value       = module.resource_group.resource_group.name
}

output "storage_account_name" {
  description = "Name of the storage account for audit logs of the SQL Server"
  value       = nonsensitive(module.storage_account.storage_account.name)
}
