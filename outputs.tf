#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moid's of the UCS Chassis Profiles."
  value = length(lookup(local.profiles, "chassis", [])) > 0 ? { for v in sort(
    keys(module.chassis)
  ) : v => module.chassis[v].moid } : {}
}


#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moid's of the UCS Server Profiles."
  value = length(lookup(local.profiles, "server", [])) > 0 ? { for v in sort(
    keys(module.server)
  ) : v => module.server[v].moid } : {}
}
