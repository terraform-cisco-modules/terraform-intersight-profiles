#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data" {
  description = "Moid's of the Policies/Pools/Templates that were not defined locally."
  value = {
    policies  = { for e in sort(keys(local.policies_data)) : e => { for k, v in local.policies_data[e] : k => v.moid } }
    pools     = { for e in sort(keys(local.pools_data)) : e => { for k, v in local.pools_data[e] : k => v.moid } }
    templates = { for e in sort(keys(local.templates_data)) : e => { for k, v in local.templates_data[e] : k => v.moid } }
  }
}

#__________________________________________________________
#
# UCS Profiles Outputs
#__________________________________________________________

output "profiles" {
  description = "Moids of the Chassis/Domain/Server Profiles."
  value = {
    chassis       = { for e in sort(keys(intersight_chassis_profile.map)) : e => intersight_chassis_profile.map[e].moid }
    domain        = { for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid }
    domain_switch = { for v in sort(keys(intersight_fabric_switch_profile.map)) : v => intersight_fabric_switch_profile.map[v].moid }
    server        = { for e in sort(keys(intersight_server_profile.map)) : e => intersight_server_profile.map[e].moid }
  }
}

#__________________________________________________________
#
# UCS Templates Outputs
#__________________________________________________________

output "templates" {
  description = "Moids of the Chassis/Domain/Server Profiles Templates."
  value = {
    chassis       = { for e in sort(keys(intersight_chassis_profile_template.map)) : e => intersight_chassis_profile_template.map[e].moid }
    domain        = { for v in sort(keys(intersight_fabric_switch_cluster_profile_template.map)) : v => intersight_fabric_switch_cluster_profile_template.map[v].moid }
    domain_switch = { for v in sort(keys(intersight_fabric_switch_profile_template.map)) : v => intersight_fabric_switch_profile_template.map[v].moid }
    server        = { for e in sort(keys(intersight_server_profile_template.map)) : e => intersight_server_profile_template.map[e].moid }
  }
}
