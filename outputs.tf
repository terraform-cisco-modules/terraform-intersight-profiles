#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data_policies" {
  value = { for e in keys(data.intersight_search_search_item.policies) : e => {
    for i in data.intersight_search_search_item.policies[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}
output "data_pools" {
  value = { for e in keys(data.intersight_search_search_item.pools) : e => {
    for i in data.intersight_search_search_item.pools[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moid and Policies for the Chassis Profiles."
  value       = { for e in sort(keys(intersight_chassis_profile.map)) : e => intersight_chassis_profile.map[e].moid }
}

#____________________________________________________________
#
# UCS Domain Profile Outputs
#____________________________________________________________

output "domains" {
  description = "Moid of the Domain Cluster Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid }
}

output "switch_profiles" {
  description = "Moid and Policies of the Domain Switch Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_profile.map)) : v => intersight_fabric_switch_profile.map[v].moid }
}

#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moid and Policies for the Server Profiles."
  value       = { for e in sort(keys(intersight_server_profile.map)) : e => intersight_server_profile.map[e].moid }
}

#__________________________________________________________
#
# UCS Server Template Profile Outputs
#__________________________________________________________

output "template" {
  description = "Moid and Policies for the Server Profile Templates."
  value       = { for e in sort(keys(intersight_server_profile_template.map)) : e => intersight_server_profile_template.map[e].moid }
}
