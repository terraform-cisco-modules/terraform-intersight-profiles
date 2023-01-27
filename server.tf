#____________________________________________________________
#
# Intersight UCS Server Profile Resource
# GUI Location: Profiles > UCS Server Profile > Create
#____________________________________________________________

#data "intersight_server_profile_template" "template" {
#  for_each = {
#    for v in compact([local.server_templates]) : v => v if length(
#      regexall("[[:xdigit:]]{24}", local.server_template)
#    ) == 0
#  }
#  name = each.value
#}

data "intersight_compute_physical_summary" "server" {
  for_each = { for v in local.server_serial_numbers : v => v }
  serial   = each.value
}

resource "intersight_server_profile" "server" {
  depends_on = [
    data.intersight_compute_physical_summary.server
  ]
  for_each    = local.server
  description = lookup(each.value, "description", "${each.value.name} Server Profile.")
  name        = each.value.name
  server_assignment_mode = length(compact(
    [each.value.resource_pool])) > 0 ? "Pool" : length(regexall(
    "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? "Static" : "None"
  static_uuid_address = each.value.static_uuid_address
  target_platform     = each.value.target_platform
  type                = "instance"
  uuid_address_type = length(
    compact([each.value.uuid_pool])
  ) > 0 ? "POOL" : length(compact([each.value.static_uuid_address])) > 0 ? "STATIC" : "NONE"
  wait_for_completion = each.value.wait_for_completion
  lifecycle {
    ignore_changes = [
      action,
      config_context,
      mod_time,
      uuid_lease,
      wait_for_completion
    ]
  }
  organization {
    moid = length(regexall(true, var.moids)
      ) > 0 ? local.orgs[each.value.organization
    ] : data.intersight_organization_organization.orgs[each.value.organization].results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "assigned_server" {
    for_each = {
      for v in compact(
        [each.value.serial_number]
        ) : v => v if length(compact([each.value.resource_pool])) == 0 && length(
        regexall("^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", each.value.serial_number)
      ) > 0
    }
    content {
      moid = data.intersight_compute_physical_summary.server[each.value.serial_number].results[0].moid
      object_type = data.intersight_compute_physical_summary.server[
        each.value.serial_number].results[0
      ].source_object_type
    }
  }
  dynamic "associated_server_pool" {
    for_each = { for v in compact([each.value.resource_pool]) : v => v }
    content {
      moid = length(regexall(true, local.moids)
        ) > 0 ? var.pools.resource[associated_server_pool.value
        ].moid : [for i in data.intersight_resourcepool_pool.resource_pool[associated_server_pool.value
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
      ][0]
      object_type = "resourcepool.Pool"
    }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v }
    content {
      moid = length(regexall(true, var.moids)
        ) > 0 ? var.policies[policy_bucket.value.policy][policy_bucket.value.name
        ] : length(regexall("adapter.ConfigPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_adapter_config_policy.adapter_configuration[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("bios.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_bios_policy.bios[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("boot.PrecisionPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_boot_precision_policy.boot_order[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("certificatemanagement.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_certificatemanagement_policy.certificate_management[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("deviceconnector.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_deviceconnector_policy.device_connector[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("access.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_access_policy.imc_access[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("ipmioverlan.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_ipmioverlan_policy.ipmi_over_lan[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("vnic.LanConnectivityPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_vnic_lan_connectivity_policy.lan_connectivity[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("iam.LdapPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_iam_ldap_policy.ldap[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("iam.EndPointUserPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_iam_end_point_user_policy.local_user[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("networkconfig.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_networkconfig_policy.network_connectivity[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("ntp.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_ntp_policy.ntp[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("memory.PersistentMemoryPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_memory_persistent_memory_policy.persistent_memory[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("power.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_power_policy.power[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("vnic.SanConnectivityPolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_vnic_san_connectivity_policy.san_connectivity[
          policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("sdcard.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_sdcard_policy.sd_card[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("sol.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_sol_policy.serial_over_lan[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("smtp.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_smtp_policy.smtp[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("snmp.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_snmp_policy.snmp[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("ssh.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_ssh_policy.ssh[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("storage.StoragePolicy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_storage_storage_policy.storage[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("syslog.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_syslog_policy.syslog[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("kvm.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_kvm_policy.virtual_kvm[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("vmedia.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_vmedia_policy.virtual_media[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
      ][0] : ""
      object_type = policy_bucket.value.object_type
    }
  }
  dynamic "reservation_references" {
    for_each = { for v in each.value.reservations : v.identity => v }
    content {
      additional_properties = length(regexall("ip", v.reservation_type)
        ) > 0 ? jsonencode({
          ConsumerType = length(regexall("IP", each.value.ip_type)
            ) > 0 && length(regexall("Band", each.value.management_type)
          ) > 0 ? "${each.value.management_type}${title(each.value.ip_type)}-Access" : "ISCSI"
          ConsumerName = each.value.vnic_name
        }) : length(regexall("mac", each.value.reservation_type)
        ) > 0 ? jsonencode({
          ConsumerType = "Vnic"
          ConsumerName = each.value.vnic_name
        }) : length(regexall("ww", each.value.reservation_type)
        ) > 0 ? jsonencode({
          ConsumerType = length(regexall("wwnn", each.value.reservation_type)
          ) > 0 ? "WWNN" : "Vhba"
          ConsumerName = each.value.vhba_name
      }) : ""
      object_type = length(regexall("(wwnn|wwpn)", v.reservation_type)
      ) > 0 ? "fcpool.ReservationReference" : "${each.value.reservations_type}pool.ReservationReference"
      reservation_moid = length(regexall("ip", v.reservation_type)
        ) > 0 ? var.pools.ip_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("iqn", v.reservation_type)
        ) > 0 ? var.pools.iqn_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("mac", v.reservation_type)
        ) > 0 ? var.pools.mac_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("uuid", v.reservation_type)
        ) > 0 ? var.pools.uuid_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("wwnn", v.reservation_type)
        ) > 0 ? var.pools.wwnn_reservations["${each.value.pool_name}:${each.value.identity}"
      ].moid : var.pools.wwpn_reservations["${each.value.pool_name}:${each.value.identity}"].moid
    }
  }
  #dynamic "src_template" {
  #  for_each = { for v in compact([each.value.server_template]) : v => v }
  #  content {
  #    moid = length(
  #      regexall("[[:xdigit:]]{24}", each.value.server_template)
  #      ) > 0 ? each.value.server_template : data.intersight_server_profile_template.template[
  #      src_template.value].results[0
  #    ].moid
  #  }
  #}
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "uuid_pool" {
    for_each = { for v in compact([each.value.uuid_pool]) : v => v }
    content {
      moid = length(regexall(true, local.moids)
        ) > 0 ? var.pools.uuid[uuid_pool.value
        ] : [for i in data.intersight_uuidpool_pool.uuid[uuid_pool.value
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
      ][0]
      object_type = "uuidpool.Pool"
    }
  }
}
