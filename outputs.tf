#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data" {
  description = "Moid's of the Policies/Pools/Templates that were not defined locally."
  value = {
    policies = { for e in sort(keys(local.policies_data)) : e => { for k, v in local.policies_data[e] : k => v.moid } }
    pools    = { for e in sort(keys(local.pools_data)) : e => { for k, v in local.pools_data[e] : k => v.moid } if length(local.pools_data[e]) > 0 }
  }
}

#__________________________________________________________
#
# UCS Profiles Outputs
#__________________________________________________________

output "profiles" {
  description = "Moids of the Chassis/Domain/Server Profiles."
  value = {
    chassis = { for e in sort(keys(intersight_chassis_profile.map)) : e => intersight_chassis_profile.map[e].moid }
    domain = {
      cluster = { for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid }
      switch  = { for v in sort(keys(intersight_fabric_switch_profile.map)) : v => intersight_fabric_switch_profile.map[v].moid }
    }
    server = { for e in sort(keys(intersight_server_profile.map)) : e => intersight_server_profile.map[e].moid }
  }
}

#__________________________________________________________
#
# UCS Templates Outputs
#__________________________________________________________

output "templates" {
  description = "Moids of the Chassis/Domain/Server Profiles Templates."
  value = {
    chassis = { for k, v in local.ucs_templates.chassis : k => v.moid }
    domain = {
      domain = { for k, v in local.ucs_templates.domain : k => v.moid }
      switch = { for k, v in local.ucs_templates.switch : k => v.moid }
    }
    server = { for k, v in local.ucs_templates.server : k => v.moid }
  }
}
