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
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.37 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.44 |
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
| <a name="output_chassis"></a> [chassis](#output\_chassis) | Moid and Policies for the Chassis Profiles. |
| <a name="output_server"></a> [server](#output\_server) | Moid and Policies for the Server Profiles. |
| <a name="output_template"></a> [template](#output\_template) | Moid and Policies for the Server Profile Templates. |
| <a name="output_z_moids_of_policies_that_were_referenced_in_the_profiles_but_not_already_created"></a> [z\_moids\_of\_policies\_that\_were\_referenced\_in\_the\_profiles\_but\_not\_already\_created](#output\_z\_moids\_of\_policies\_that\_were\_referenced\_in\_the\_profiles\_but\_not\_already\_created) | moids of Pools that were referenced in server profiles but not defined |
## Resources

| Name | Type |
|------|------|
| [intersight_access_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy) | resource |
| [intersight_adapter_config_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/adapter_config_policy) | resource |
| [intersight_bios_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bios_policy) | resource |
| [intersight_boot_precision_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/boot_precision_policy) | resource |
| [intersight_bulk_mo_cloner.servers_from_template](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_cloner) | resource |
| [intersight_bulk_mo_merger.trigger_profile_update](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/bulk_mo_merger) | resource |
| [intersight_certificatemanagement_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/certificatemanagement_policy) | resource |
| [intersight_chassis_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile) | resource |
| [intersight_deviceconnector_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/deviceconnector_policy) | resource |
| [intersight_firmware_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/firmware_policy) | resource |
| [intersight_iam_end_point_user_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_policy) | resource |
| [intersight_iam_ldap_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_ldap_policy) | resource |
| [intersight_ipmioverlan_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ipmioverlan_policy) | resource |
| [intersight_kvm_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/kvm_policy) | resource |
| [intersight_memory_persistent_memory_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/memory_persistent_memory_policy) | resource |
| [intersight_networkconfig_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/networkconfig_policy) | resource |
| [intersight_ntp_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ntp_policy) | resource |
| [intersight_power_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy) | resource |
| [intersight_resourcepool_pool.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/resourcepool_pool) | resource |
| [intersight_sdcard_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sdcard_policy) | resource |
| [intersight_server_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile) | resource |
| [intersight_server_profile_template.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/server_profile_template) | resource |
| [intersight_smtp_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/smtp_policy) | resource |
| [intersight_snmp_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/snmp_policy) | resource |
| [intersight_sol_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/sol_policy) | resource |
| [intersight_ssh_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ssh_policy) | resource |
| [intersight_storage_drive_security_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_drive_security_policy) | resource |
| [intersight_storage_storage_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/storage_storage_policy) | resource |
| [intersight_syslog_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/syslog_policy) | resource |
| [intersight_thermal_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy) | resource |
| [intersight_uuidpool_pool.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/uuidpool_pool) | resource |
| [intersight_vmedia_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vmedia_policy) | resource |
| [intersight_vnic_lan_connectivity_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_lan_connectivity_policy) | resource |
| [intersight_vnic_san_connectivity_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_san_connectivity_policy) | resource |
| [intersight_compute_physical_summary.server](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/compute_physical_summary) | data source |
| [intersight_equipment_chassis.chassis](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/equipment_chassis) | data source |
<!-- END_TF_DOCS -->