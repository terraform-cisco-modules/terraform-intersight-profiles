#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data_policies" {
  description = "Data Source for Policies."
  value = { for e in keys(data.intersight_search_search_item.policies) : e => {
    for i in data.intersight_search_search_item.policies[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

output "data_pools" {
  description = "Data Source for Pools."
  value = { for e in keys(data.intersight_search_search_item.pools) : e => {
    for i in data.intersight_search_search_item.pools[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

output "data_templates" {
  description = "Data Source for Templates."
  value = { for e in keys(data.intersight_search_search_item.templates) : e => {
    for i in data.intersight_search_search_item.templates[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moids of the Chassis Profiles."
  value       = { for e in sort(keys(intersight_chassis_profile.map)) : e => intersight_chassis_profile.map[e].moid }
}

#____________________________________________________________
#
# UCS Domain Profile Outputs
#____________________________________________________________

output "domains" {
  description = "Moids of the Domain Cluster Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid }
}

output "switch_profiles" {
  description = "Moids of the Domain Switch Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_profile.map)) : v => intersight_fabric_switch_profile.map[v].moid }
}

#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moids of the Server Profiles."
  value       = { for e in sort(keys(intersight_server_profile.map)) : e => intersight_server_profile.map[e].moid }
}

#__________________________________________________________
#
# UCS Server Template Profile Outputs
#__________________________________________________________

output "template" {
  description = "Moids of the Server Profile Templates."
  value       = { for e in sort(keys(intersight_server_profile_template.map)) : e => intersight_server_profile_template.map[e].moid }
}
