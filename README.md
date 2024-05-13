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
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.48 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.9.1 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.48 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.11.1 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | YAML to HCL Data - global\_settings. | `any` | n/a | yes |
| <a name="input_model"></a> [model](#input\_model) | YAML to HCL Data - model. | `any` | n/a | yes |
| <a name="input_orgs"></a> [orgs](#input\_orgs) | Intersight Organizations Moid Data. | `any` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies - Module Output. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pools - Module Output. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data"></a> [data](#output\_data) | Moid's of the Policies/Pools/Templates that were not defined locally. |
| <a name="output_profiles"></a> [profiles](#output\_profiles) | Moids of the Chassis/Domain/Server Profiles. |
| <a name="output_templates"></a> [templates](#output\_templates) | Moids of the Chassis/Domain/Server Profiles Templates. |
## Resources

| Name | Type |
|------|------|
| [intersight_bulk_mo_merger.trigger_chassis_profile_update](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_merger) | resource |
| [intersight_bulk_mo_merger.trigger_domain_profile_update](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_merger) | resource |
| [intersight_bulk_mo_merger.trigger_profile_update](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_merger) | resource |
| [intersight_bulk_mo_merger.trigger_switch_profile_update](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_merger) | resource |
| [intersight_chassis_profile.deploy](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile) | resource |
| [intersight_chassis_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile) | resource |
| [intersight_chassis_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile_template) | resource |
| [intersight_fabric_switch_cluster_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_cluster_profile) | resource |
| [intersight_fabric_switch_cluster_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_cluster_profile_template) | resource |
| [intersight_fabric_switch_profile.deploy](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_profile) | resource |
| [intersight_fabric_switch_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_profile) | resource |
| [intersight_fabric_switch_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_profile_template) | resource |
| [intersight_server_profile.deploy](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile) | resource |
| [intersight_server_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile) | resource |
| [intersight_server_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile_template) | resource |
| [time_sleep.chassis](https://registry.terraform.io/providers/time/latest/docs/resources/sleep) | resource |
| [time_sleep.discovery](https://registry.terraform.io/providers/time/latest/docs/resources/sleep) | resource |
| [time_sleep.domain](https://registry.terraform.io/providers/time/latest/docs/resources/sleep) | resource |
| [time_sleep.server](https://registry.terraform.io/providers/time/latest/docs/resources/sleep) | resource |
| [intersight_compute_physical_summary.server](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/compute_physical_summary) | data source |
| [intersight_equipment_chassis.chassis](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/equipment_chassis) | data source |
| [intersight_network_element_summary.fis](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/network_element_summary) | data source |
| [intersight_search_search_item.policies](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.pools](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
| [intersight_search_search_item.templates](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/search_search_item) | data source |
<!-- END_TF_DOCS -->