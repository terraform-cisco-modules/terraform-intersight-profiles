<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight Profiles Module

A Terraform module to configure Intersight Profiles.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/iac-intersight-comprehensive-example

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | >=1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies Moids. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pool Moids. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chassis"></a> [chassis](#output\_chassis) | Moid's of the UCS Chassis Profiles. |
| <a name="output_server"></a> [server](#output\_server) | Moid's of the UCS Server Profiles. |
## Resources

| Name | Type |
|------|------|
| [intersight_access_policy.imc_access](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/access_policy) | data source |
| [intersight_adapter_config_policy.adapter_configuration](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/adapter_config_policy) | data source |
| [intersight_bios_policy.bios](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/bios_policy) | data source |
| [intersight_boot_precision_policy.boot_order](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/boot_precision_policy) | data source |
| [intersight_certificatemanagement_policy.certificate_management](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/certificatemanagement_policy) | data source |
| [intersight_deviceconnector_policy.device_connector](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/deviceconnector_policy) | data source |
| [intersight_iam_end_point_user_policy.local_user](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_end_point_user_policy) | data source |
| [intersight_iam_ldap_policy.ldap](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_ldap_policy) | data source |
| [intersight_ipmioverlan_policy.ipmi_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/ipmioverlan_policy) | data source |
| [intersight_kvm_policy.virtual_kvm](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/kvm_policy) | data source |
| [intersight_memory_persistent_memory_policy.persistent_memory](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/memory_persistent_memory_policy) | data source |
| [intersight_networkconfig_policy.network_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/networkconfig_policy) | data source |
| [intersight_ntp_policy.ntp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/ntp_policy) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_power_policy.power](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/power_policy) | data source |
| [intersight_resourcepool_pool.resource](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/resourcepool_pool) | data source |
| [intersight_sdcard_policy.sd_card](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/sdcard_policy) | data source |
| [intersight_smtp_policy.smtp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/smtp_policy) | data source |
| [intersight_snmp_policy.snmp](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/snmp_policy) | data source |
| [intersight_sol_policy.serial_over_lan](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/sol_policy) | data source |
| [intersight_ssh_policy.ssh](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/ssh_policy) | data source |
| [intersight_storage_storage_policy.storage](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/storage_storage_policy) | data source |
| [intersight_syslog_policy.syslog](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/syslog_policy) | data source |
| [intersight_thermal_policy.thermal](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/thermal_policy) | data source |
| [intersight_uuidpool_pool.uuid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/uuidpool_pool) | data source |
| [intersight_vmedia_policy.virtual_media](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/vmedia_policy) | data source |
| [intersight_vnic_lan_connectivity_policy.lan_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/vnic_lan_connectivity_policy) | data source |
| [intersight_vnic_san_connectivity_policy.san_connectivity](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/vnic_san_connectivity_policy) | data source |
<!-- END_TF_DOCS -->