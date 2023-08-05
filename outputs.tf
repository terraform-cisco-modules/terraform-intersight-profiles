#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moid and Policies for the Chassis Profiles."
  value = {
    for v in sort(keys(intersight_chassis_profile.chassis)) : v => merge({
      moid = intersight_chassis_profile.chassis[v].moid
    }, { for k, v in local.chassis[v] : k => v if k != "targets" && v != "UNUSED" && k != "policy_bucket" })
  }
}

#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moid and Policies for the Server Profiles."
  value = {
    for v in sort(keys(intersight_server_profile.server)) : v => merge({
      moid = intersight_server_profile.server[v].moid
    }, { for k, v in local.server[v] : k => v if k != "targets" && v != "UNUSED" && k != "policy_bucket" })
  }
}

#__________________________________________________________
#
# UCS Server Template Profile Outputs
#__________________________________________________________

output "template" {
  description = "Moid and Policies for the Server Profile Templates."
  value = {
    for v in sort(keys(intersight_server_profile_template.template)) : v => merge({
      moid = intersight_server_profile_template.template[v].moid
    }, { for k, v in local.template[v] : k => v if v != "UNUSED" && k != "policy_bucket" })
  }
}
