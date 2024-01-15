#__________________________________________________________
#
# UCS Chassis Profile Outputs
#__________________________________________________________

output "chassis" {
  description = "Moid and Policies for the Chassis Profiles."
  value = {
    for e in sort(keys(intersight_chassis_profile.map)) : e => merge({ moid = intersight_chassis_profile.map[e].moid
    }, { for k, v in local.chassis[e] : k => v if k != "targets" && v != "UNUSED" && k != "policy_bucket" })
  }
}

#__________________________________________________________
#
# UCS Server Profile Outputs
#__________________________________________________________

output "server" {
  description = "Moid and Policies for the Server Profiles."
  value = {
    for e in sort(keys(intersight_server_profile.map)) : e => merge({ moid = intersight_server_profile.map[e].moid
    }, { for k, v in local.server[e] : k => v if k != "targets" && v != "UNUSED" })
  }
}

#__________________________________________________________
#
# UCS Server Template Profile Outputs
#__________________________________________________________

output "template" {
  description = "Moid and Policies for the Server Profile Templates."
  value = {
    for e in sort(keys(intersight_server_profile_template.map)) : e => merge({
      moid = intersight_server_profile_template.map[e].moid
    }, { for k, v in local.template[e] : k => v if v != "UNUSED" && k != "policy_bucket" })
  }
}

output "z_moids_of_policies_that_were_referenced_in_the_profiles_but_not_already_created" {
  description = "moids of Pools that were referenced in server profiles but not defined"
  value = lookup(var.global_settings, "debugging", false) == true ? {
    adapter_configuration  = { for v in sort(keys(intersight_adapter_config_policy.data)) : v => intersight_adapter_config_policy.data[v].moid }
    bios                   = { for v in sort(keys(intersight_bios_policy.data)) : v => intersight_bios_policy.data[v].moid }
    boot_order             = { for v in sort(keys(intersight_boot_precision_policy.data)) : v => intersight_boot_precision_policy.data[v].moid }
    certificate_management = { for v in sort(keys(intersight_certificatemanagement_policy.data)) : v => intersight_certificatemanagement_policy.data[v].moid }
    device_connector       = { for v in sort(keys(intersight_deviceconnector_policy.data)) : v => intersight_deviceconnector_policy.data[v].moid }
    drive_security         = { for v in sort(keys(intersight_storage_drive_security_policy.data)) : v => intersight_storage_drive_security_policy.data[v].moid }
    firmware               = { for v in sort(keys(intersight_firmware_policy.data)) : v => intersight_firmware_policy.data[v].moid }
    imc_access             = { for v in sort(keys(intersight_access_policy.data)) : v => intersight_access_policy.data[v].moid }
    ipmi_over_lan          = { for v in sort(keys(intersight_ipmioverlan_policy.data)) : v => intersight_ipmioverlan_policy.data[v].moid }
    lan_connectivity       = { for v in sort(keys(intersight_vnic_lan_connectivity_policy.data)) : v => intersight_vnic_lan_connectivity_policy.data[v].moid }
    ldap                   = { for v in sort(keys(intersight_iam_ldap_policy.data)) : v => intersight_iam_ldap_policy.data[v].moid }
    local_user             = { for v in sort(keys(intersight_iam_end_point_user_policy.data)) : v => intersight_iam_end_point_user_policy.data[v].moid }
    network_connectivity   = { for v in sort(keys(intersight_networkconfig_policy.data)) : v => intersight_networkconfig_policy.data[v].moid }
    ntp                    = { for v in sort(keys(intersight_ntp_policy.data)) : v => intersight_ntp_policy.data[v].moid }
    persistent_memory      = { for v in sort(keys(intersight_memory_persistent_memory_policy.data)) : v => intersight_memory_persistent_memory_policy.data[v].moid }
    power                  = { for v in sort(keys(intersight_power_policy.data)) : v => intersight_power_policy.data[v].moid }
    resource               = { for v in sort(keys(intersight_resourcepool_pool.data)) : v => intersight_resourcepool_pool.data[v].moid }
    san_connectivity       = { for v in sort(keys(intersight_vnic_san_connectivity_policy.data)) : v => intersight_vnic_san_connectivity_policy.data[v].moid }
    sd_card                = { for v in sort(keys(intersight_sdcard_policy.data)) : v => intersight_sdcard_policy.data[v].moid }
    serial_over_lan        = { for v in sort(keys(intersight_sol_policy.data)) : v => intersight_sol_policy.data[v].moid }
    smtp                   = { for v in sort(keys(intersight_smtp_policy.data)) : v => intersight_smtp_policy.data[v].moid }
    snmp                   = { for v in sort(keys(intersight_snmp_policy.data)) : v => intersight_snmp_policy.data[v].moid }
    ssh                    = { for v in sort(keys(intersight_ssh_policy.data)) : v => intersight_ssh_policy.data[v].moid }
    storage                = { for v in sort(keys(intersight_storage_storage_policy.data)) : v => intersight_storage_storage_policy.data[v].moid }
    syslog                 = { for v in sort(keys(intersight_syslog_policy.data)) : v => intersight_syslog_policy.data[v].moid }
    thermal                = { for v in sort(keys(intersight_thermal_policy.data)) : v => intersight_thermal_policy.data[v].moid }
    uuid                   = { for v in sort(keys(intersight_uuidpool_pool.data)) : v => intersight_uuidpool_pool.data[v].moid }
    virtual_kvm            = { for v in sort(keys(intersight_kvm_policy.data)) : v => intersight_kvm_policy.data[v].moid }
    virtual_media          = { for v in sort(keys(intersight_vmedia_policy.data)) : v => intersight_vmedia_policy.data[v].moid }
  } : {}
}
