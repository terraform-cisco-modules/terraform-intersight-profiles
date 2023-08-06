<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight - Profiles Module

A Terraform module to configure Intersight Infrastructure Profiles.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY IMM"

### A comprehensive example using this module is available below:

## [Easy IMM](https://github.com/terraform-cisco-modules/easy-imm)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.36 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.36 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | YAML to HCL data. | `any` | n/a | yes |
| <a name="input_moids_policies"></a> [moids\_policies](#input\_moids\_policies) | Flag to Determine if Policies Should be associated using resource or data object. | `bool` | `false` | no |
| <a name="input_moids_pools"></a> [moids\_pools](#input\_moids\_pools) | Flag to Determine if Pools Should be associated using data object or from var.pools. | `bool` | `false` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the default intersight Organization. | `string` | `"default"` | no |
| <a name="input_orgs"></a> [orgs](#input\_orgs) | Input orgs List. | `any` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies Moids. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pool Moids. | `any` | n/a | yes |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | Profiles - YAML to HCL data. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Key/Value Pairs to Assign as Attributes to the Policy. | `list(map(string))` | `[]` | no |
| <a name="input_time_sleep"></a> [time\_sleep](#input\_time\_sleep) | This is just a dummy place holder to get around the challenge with depends\_on | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chassis"></a> [chassis](#output\_chassis) | Moid and Policies for the Chassis Profiles. |
| <a name="output_server"></a> [server](#output\_server) | Moid and Policies for the Server Profiles. |
| <a name="output_template"></a> [template](#output\_template) | Moid and Policies for the Server Profile Templates. |
## Resources

| Name | Type |
|------|------|
| [intersight_bulk_mo_cloner.servers_from_template](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_cloner) | resource |
| [intersight_chassis_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile) | resource |
| [intersight_server_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile) | resource |
| [intersight_server_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile_template) | resource |
| [intersight_compute_physical_summary.server](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/compute_physical_summary) | data source |
| [intersight_equipment_chassis.chassis](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/equipment_chassis) | data source |
| [intersight_search_search_item.adapter_configuration](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.bios](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.boot_order](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.certificate_management](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.device_connector](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.drive_security](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.firmware](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.imc_access](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ipmi_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.lan_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ldap](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.local_user](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.network_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ntp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.persistent_memory](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.power](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.resource](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.san_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.sd_card](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.serial_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.smtp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.snmp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.ssh](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.storage](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.syslog](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.thermal](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.uuid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.virtual_kvm](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.virtual_media](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
<!-- END_TF_DOCS -->