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

output "deploy_chassis" {
  value = {
    for v in sort(keys(intersight_chassis_profile.chassis)
      ) : v => intersight_chassis_profile.chassis[v].moid if length(regexall(
      "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", local.chassis[v].serial_number)
    ) > 0 && local.chassis[v].action == "Deploy"
  }
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

output "deploy_servers" {
  value = {
    for v in sort(keys(intersight_server_profile.server)
      ) : v => intersight_server_profile.server[v].moid if length(regexall(
      "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", local.server[v].serial_number)
    ) > 0 && local.server[v].action == "Deploy"
  }
}
