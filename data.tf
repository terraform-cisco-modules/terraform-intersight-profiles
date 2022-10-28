#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = { for v in local.organizations : v => v }
  name     = each.value
}

#____________________________________________________________
#
# Server Moid Data Source
# GUI Location:
#   Operate > Server > Copy the Serial from the Column.
#____________________________________________________________

data "intersight_adapter_config_policy" "adapter_configuration" {
  for_each = { for v in lookup(local.data_policies, "adapter_configuration", []) : v => v }
  name     = each.value
}

data "intersight_bios_policy" "bios" {
  for_each = { for v in lookup(local.data_policies, "bios", []) : v => v }
  name     = each.value
}

data "intersight_boot_precision_policy" "boot_order" {
  for_each = { for v in lookup(local.data_policies, "boot_order", []) : v => v }
  name     = each.value
}

data "intersight_certificatemanagement_policy" "certificate_management" {
  for_each = { for v in lookup(local.data_policies, "certificate_management", []) : v => v }
  name     = each.value
}

data "intersight_deviceconnector_policy" "device_connector" {
  for_each = { for v in lookup(local.data_policies, "device_connector", []) : v => v }
  name     = each.value
}

data "intersight_access_policy" "imc_access" {
  for_each = { for v in lookup(local.data_policies, "imc_access", []) : v => v }
  name     = each.value
}

data "intersight_ipmioverlan_policy" "ipmi_over_lan" {
  for_each = { for v in lookup(local.data_policies, "ipmi_over_lan", []) : v => v }
  name     = each.value
}

data "intersight_vnic_lan_connectivity_policy" "lan_connectivity" {
  for_each = { for v in lookup(local.data_policies, "lan_connectivity", []) : v => v }
  name     = each.value
}

data "intersight_iam_ldap_policy" "ldap" {
  for_each = { for v in lookup(local.data_policies, "ldap", []) : v => v }
  name     = each.value
}

data "intersight_iam_end_point_user_policy" "local_user" {
  for_each = { for v in lookup(local.data_policies, "local_user", []) : v => v }
  name     = each.value
}

data "intersight_networkconfig_policy" "network_connectivity" {
  for_each = { for v in lookup(local.data_policies, "network_connectivity", []) : v => v }
  name     = each.value
}

data "intersight_ntp_policy" "ntp" {
  for_each = { for v in lookup(local.data_policies, "ntp", []) : v => v }
  name     = each.value
}

data "intersight_memory_persistent_memory_policy" "persistent_memory" {
  for_each = { for v in lookup(local.data_policies, "persistent_memory", []) : v => v }
  name     = each.value
}

data "intersight_power_policy" "power" {
  for_each = { for v in lookup(local.data_policies, "power", []) : v => v }
  name     = each.value
}

data "intersight_resourcepool_pool" "resource" {
  for_each = { for v in lookup(local.data_pools, "resource", []) : v => v }
  name     = each.value
}

data "intersight_vnic_san_connectivity_policy" "san_connectivity" {
  for_each = { for v in lookup(local.data_policies, "san_connectivity", []) : v => v }
  name     = each.value
}

data "intersight_sdcard_policy" "sd_card" {
  for_each = { for v in lookup(local.data_policies, "sd_card", []) : v => v }
  name     = each.value
}

data "intersight_sol_policy" "serial_over_lan" {
  for_each = { for v in lookup(local.data_policies, "serial_over_lan", []) : v => v }
  name     = each.value
}

data "intersight_smtp_policy" "smtp" {
  for_each = { for v in lookup(local.data_policies, "smtp", []) : v => v }
  name     = each.value
}

data "intersight_snmp_policy" "snmp" {
  for_each = { for v in lookup(local.data_policies, "snmp", []) : v => v }
  name     = each.value
}

data "intersight_ssh_policy" "ssh" {
  for_each = { for v in lookup(local.data_policies, "ssh", []) : v => v }
  name     = each.value
}

data "intersight_storage_storage_policy" "storage" {
  for_each = { for v in lookup(local.data_policies, "storage", []) : v => v }
  name     = each.value
}

data "intersight_syslog_policy" "syslog" {
  for_each = { for v in lookup(local.data_policies, "syslog", []) : v => v }
  name     = each.value
}

data "intersight_thermal_policy" "thermal" {
  for_each = { for v in lookup(local.data_policies, "thermal", []) : v => v }
  name     = each.value
}

data "intersight_kvm_policy" "virtual_kvm" {
  for_each = { for v in lookup(local.data_policies, "virtual_kvm", []) : v => v }
  name     = each.value
}

data "intersight_vmedia_policy" "virtual_media" {
  for_each = { for v in lookup(local.data_policies, "virtual_media", []) : v => v }
  name     = each.value
}

data "intersight_uuidpool_pool" "uuid" {
  for_each = { for v in lookup(local.data_pools, "uuid", []) : v => v if local.moids == false }
}
