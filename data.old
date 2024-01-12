#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

data "intersight_search_search_item" "adapter_configuration" {
  for_each              = { for v in [0] : v => v if length(local.pb.adapter_configuration) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "adapter.ConfigPolicy" })
}

data "intersight_search_search_item" "bios" {
  for_each              = { for v in [0] : v => v if length(local.pb.bios) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "bios.Policy" })
}

data "intersight_search_search_item" "boot_order" {
  for_each              = { for v in [0] : v => v if length(local.pb.boot_order) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "boot.PrecisionPolicy" })
}

data "intersight_search_search_item" "certificate_management" {
  for_each              = { for v in [0] : v => v if length(local.pb.certificate_management) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "certificatemanagement.Policy" })
}

data "intersight_search_search_item" "device_connector" {
  for_each              = { for v in [0] : v => v if length(local.pb.device_connector) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "deviceconnector.Policy" })
}

data "intersight_search_search_item" "drive_security" {
  for_each              = { for v in [0] : v => v if length(local.pb.drive_security) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "storage.DriveSecurityPolicy" })
}

data "intersight_search_search_item" "firmware" {
  for_each              = { for v in [0] : v => v if length(local.pb.firmware) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "firmware.Policy" })
}

data "intersight_search_search_item" "imc_access" {
  for_each              = { for v in [0] : v => v if length(local.pb.imc_access) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "access.Policy" })
}

data "intersight_search_search_item" "ipmi_over_lan" {
  for_each              = { for v in [0] : v => v if length(local.pb.ipmi_over_lan) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "ipmioverlan.Policy" })
}

data "intersight_search_search_item" "lan_connectivity" {
  for_each              = { for v in [0] : v => v if length(local.pb.lan_connectivity) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "vnic.LanConnectivityPolicy" })
}

data "intersight_search_search_item" "ldap" {
  for_each              = { for v in [0] : v => v if length(local.pb.ldap) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "iam.LdapPolicy" })
}

data "intersight_search_search_item" "local_user" {
  for_each              = { for v in [0] : v => v if length(local.pb.local_user) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "iam.EndPointUserPolicy" })
}

data "intersight_search_search_item" "network_connectivity" {
  for_each              = { for v in [0] : v => v if length(local.pb.network_connectivity) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "networkconfig.Policy" })
}

data "intersight_search_search_item" "ntp" {
  for_each              = { for v in [0] : v => v if length(local.pb.ntp) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "ntp.Policy" })
}

data "intersight_search_search_item" "persistent_memory" {
  for_each              = { for v in [0] : v => v if length(local.pb.persistent_memory) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "memory.PersistentMemoryPolicy" })
}

data "intersight_search_search_item" "power" {
  for_each              = { for v in [0] : v => v if length(local.pb.power) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "power.Policy" })
}

data "intersight_search_search_item" "resource" {
  for_each              = { for v in [0] : v => v if length(local.pb.resource) > 0 && local.moids_pools == true }
  additional_properties = jsonencode({ "ObjectType" = "resourcepool.Pool" })
}

data "intersight_search_search_item" "san_connectivity" {
  for_each              = { for v in [0] : v => v if length(local.pb.san_connectivity) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "vnic.SanConnectivityPolicy" })
}

data "intersight_search_search_item" "sd_card" {
  for_each              = { for v in [0] : v => v if length(local.pb.sd_card) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "sdcard.Policy" })
}

data "intersight_search_search_item" "serial_over_lan" {
  for_each              = { for v in [0] : v => v if length(local.pb.serial_over_lan) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "sol.Policy" })
}

data "intersight_search_search_item" "smtp" {
  for_each              = { for v in [0] : v => v if length(local.pb.smtp) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "smtp.Policy" })
}

data "intersight_search_search_item" "snmp" {
  for_each              = { for v in [0] : v => v if length(local.pb.snmp) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "snmp.Policy" })
}

data "intersight_search_search_item" "ssh" {
  for_each              = { for v in [0] : v => v if length(local.pb.ssh) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "ssh.Policy" })
}

data "intersight_search_search_item" "storage" {
  for_each              = { for v in [0] : v => v if length(local.pb.storage) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "storage.StoragePolicy" })
}

data "intersight_search_search_item" "syslog" {
  for_each              = { for v in [0] : v => v if length(local.pb.syslog) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "syslog.Policy" })
}

data "intersight_search_search_item" "thermal" {
  for_each              = { for v in [0] : v => v if length(local.pb.thermal) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "thermal.Policy" })
}

data "intersight_search_search_item" "uuid" {
  for_each              = { for v in [0] : v => v if length(local.pb.uuid) > 0 && local.moids_pools == true }
  additional_properties = jsonencode({ "ObjectType" = "uuidpool.Pool" })
}

data "intersight_search_search_item" "virtual_kvm" {
  for_each              = { for v in [0] : v => v if length(local.pb.virtual_kvm) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "kvm.Policy" })
}

data "intersight_search_search_item" "virtual_media" {
  for_each              = { for v in [0] : v => v if length(local.pb.virtual_media) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "vmedia.Policy" })
}
