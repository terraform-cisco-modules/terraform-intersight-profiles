#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

data "intersight_adapter_config_policy" "adapter_configuration" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "adapter.ConfigPolicy"
  }
  name = each.value.name
}

data "intersight_bios_policy" "bios" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "bios.Policy"
  }
  name = each.value.name
}

data "intersight_boot_precision_policy" "boot_order" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "boot.PrecisionPolicy"
  }
  name = each.value.name
}

data "intersight_certificatemanagement_policy" "certificate_management" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "certificatemanagement.Policy"
  }
  name = each.value.name
}

data "intersight_deviceconnector_policy" "device_connector" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "deviceconnector.Policy"
  }
  name = each.value.name
}

data "intersight_access_policy" "imc_access" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "access.Policy"
  }
  name = each.value.name
}

data "intersight_ipmioverlan_policy" "ipmi_over_lan" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "ipmioverlan.Policy"
  }
  name = each.value.name
}

data "intersight_vnic_lan_connectivity_policy" "lan_connectivity" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "vnic.LanConnectivityPolicy"
  }
  name = each.value.name
}

data "intersight_iam_ldap_policy" "ldap" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "iam.LdapPolicy"
  }
  name = each.value.name
}

data "intersight_iam_end_point_user_policy" "local_user" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "iam.EndPointUserPolicy"
  }
  name = each.value.name
}

data "intersight_networkconfig_policy" "network_connectivity" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "networkconfig.Policy"
  }
  name = each.value.name
}

data "intersight_ntp_policy" "ntp" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "ntp.Policy"
  }
  name = each.value.name
}

data "intersight_memory_persistent_memory_policy" "persistent_memory" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "memory.PersistentMemoryPolicy"
  }
  name = each.value.name
}

data "intersight_power_policy" "power" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "power.Policy"
  }
  name = each.value.name
}

data "intersight_resourcepool_pool" "resource_pool" {
  for_each = {
    for v in local.resource_pools : v => v if local.moids == false
  }
  name = each.value
}

data "intersight_vnic_san_connectivity_policy" "san_connectivity" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "vnic.SanConnectivityPolicy"
  }
  name = each.value.name
}

data "intersight_sdcard_policy" "sd_card" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "sdcard.Policy"
  }
  name = each.value.name
}

data "intersight_sol_policy" "serial_over_lan" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "sol.Policy"
  }
  name = each.value.name
}

data "intersight_smtp_policy" "smtp" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "smtp.Policy"
  }
  name = each.value.name
}

data "intersight_snmp_policy" "snmp" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "snmp.Policy"
  }
  name = each.value.name
}

data "intersight_ssh_policy" "ssh" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "ssh.Policy"
  }
  name = each.value.name
}

data "intersight_storage_storage_policy" "storage" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "storage.StoragePolicy"
  }
  name = each.value.name
}

data "intersight_syslog_policy" "syslog" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "syslog.Policy"
  }
  name = each.value.name
}

data "intersight_thermal_policy" "thermal" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "thermal.Policy"
  }
  name = each.value.name
}

data "intersight_kvm_policy" "virtual_kvm" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "kvm.Policy"
  }
  name = each.value.name
}

data "intersight_vmedia_policy" "virtual_media" {
  for_each = {
    for v in local.data_policies : v.name => v if local.moids == false && v.object_type == "vmedia.Policy"
  }
  name = each.value.name
}

data "intersight_uuidpool_pool" "uuid" {
  for_each = {
    for v in local.uuid_pools : v => v if local.moids == false
  }
  name = each.value
}
