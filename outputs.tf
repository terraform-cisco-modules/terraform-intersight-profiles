#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moid's of the UCS Chassis Profiles."
  value = length(local.chassis) > 0 ? { for v in sort(
    keys(intersight_chassis_profile.chassis)
  ) : v => intersight_chassis_profile.chassis[v].moid } : {}
}


#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moid's of the UCS Server Profiles."
  value = length(lookup(local.profiles, "server", [])) > 0 ? { for v in sort(
    keys(intersight_server_profile.server)
  ) : v => intersight_server_profile.server[v].moid } : {}
}
