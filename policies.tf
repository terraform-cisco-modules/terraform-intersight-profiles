resource "intersight_access_policy" "data" {
  for_each = { for v in local.pb.imc_access : v => v if contains(lookup(lookup(local.policies, "locals", {}), "imc_access", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_adapter_config_policy" "data" {
  for_each = { for v in local.pb.adapter_configuration : v => v if contains(lookup(lookup(local.policies, "locals", {}), "adapter_configuration", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_bios_policy" "data" {
  for_each = { for v in local.pb.bios : v => v if contains(lookup(lookup(local.policies, "locals", {}), "bios", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_boot_precision_policy" "data" {
  for_each = { for v in local.pb.boot_order : v => v if contains(lookup(lookup(local.policies, "locals", {}), "boot_order", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_certificatemanagement_policy" "data" {
  for_each = { for v in local.pb.certificate_management : v => v if contains(lookup(lookup(local.policies, "locals", {}), "certificate_management", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_deviceconnector_policy" "data" {
  for_each = { for v in local.pb.device_connector : v => v if contains(lookup(lookup(local.policies, "locals", {}), "device_connector", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_firmware_policy" "data" {
  for_each = { for v in local.pb.firmware : v => v if contains(lookup(lookup(local.policies, "locals", {}), "firmware", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_iam_end_point_user_policy" "data" {
  for_each = { for v in local.pb.local_user : v => v if contains(lookup(lookup(local.policies, "locals", {}), "local_user", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_iam_ldap_policy" "data" {
  for_each = { for v in local.pb.ldap : v => v if contains(lookup(lookup(local.policies, "locals", {}), "ldap", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_kvm_policy" "data" {
  for_each = { for v in local.pb.virtual_kvm : v => v if contains(lookup(lookup(local.policies, "locals", {}), "virtual_kvm", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_ipmioverlan_policy" "data" {
  for_each = { for v in local.pb.ipmi_over_lan : v => v if contains(lookup(lookup(local.policies, "locals", {}), "ipmi_over_lan", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_memory_persistent_memory_policy" "data" {
  for_each = { for v in local.pb.persistent_memory : v => v if contains(lookup(lookup(local.policies, "locals", {}), "persistent_memory", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_networkconfig_policy" "data" {
  for_each = { for v in local.pb.network_connectivity : v => v if contains(lookup(lookup(local.policies, "locals", {}), "network_connectivity", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_ntp_policy" "data" {
  for_each = { for v in local.pb.ntp : v => v if contains(lookup(lookup(local.policies, "locals", {}), "ntp", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_power_policy" "data" {
  for_each = { for v in local.pb.power : v => v if contains(lookup(lookup(local.policies, "locals", {}), "power", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_sdcard_policy" "data" {
  for_each = { for v in local.pb.sd_card : v => v if contains(lookup(lookup(local.policies, "locals", {}), "sd_card", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_smtp_policy" "data" {
  for_each = { for v in local.pb.smtp : v => v if contains(lookup(lookup(local.policies, "locals", {}), "smtp", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_snmp_policy" "data" {
  for_each = { for v in local.pb.snmp : v => v if contains(lookup(lookup(local.policies, "locals", {}), "snmp", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_sol_policy" "data" {
  for_each = { for v in local.pb.serial_over_lan : v => v if contains(lookup(lookup(local.policies, "locals", {}), "serial_over_lan", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_ssh_policy" "data" {
  for_each = { for v in local.pb.ssh : v => v if contains(lookup(lookup(local.policies, "locals", {}), "ssh", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_storage_drive_security_policy" "data" {
  for_each = { for v in local.pb.drive_security : v => v if contains(lookup(lookup(local.policies, "locals", {}), "drive_security", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_storage_storage_policy" "data" {
  for_each = { for v in local.pb.storage : v => v if contains(lookup(lookup(local.policies, "locals", {}), "storage", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_syslog_policy" "data" {
  for_each = { for v in local.pb.syslog : v => v if contains(lookup(lookup(local.policies, "locals", {}), "syslog", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_thermal_policy" "data" {
  for_each = { for v in local.pb.thermal : v => v if contains(lookup(lookup(local.policies, "locals", {}), "thermal", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_vmedia_policy" "data" {
  for_each = { for v in local.pb.virtual_media : v => v if contains(lookup(lookup(local.policies, "locals", {}), "virtual_media", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_vnic_lan_connectivity_policy" "data" {
  for_each = { for v in local.pb.lan_connectivity : v => v if contains(lookup(lookup(local.policies, "locals", {}), "lan_connectivity", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_vnic_san_connectivity_policy" "data" {
  for_each = { for v in local.pb.san_connectivity : v => v if contains(lookup(lookup(local.policies, "locals", {}), "san_connectivity", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}
