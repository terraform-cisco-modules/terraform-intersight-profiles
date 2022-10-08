<!-- BEGIN_TF_DOCS -->
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

No providers.
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

No resources.
<!-- END_TF_DOCS -->