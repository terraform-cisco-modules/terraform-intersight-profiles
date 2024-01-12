#__________________________________________________________________________
#
# Intersight Server Profile Resource
# GUI Location: Profiles > UCS Server Profiles > Create UCS Server Profile
#__________________________________________________________________________

data "intersight_compute_physical_summary" "server" {
  for_each = { for v in local.server_serial_numbers : v => v }
  serial   = each.value
}

resource "intersight_server_profile" "map" {
  depends_on = [
    data.intersight_compute_physical_summary.server,
    intersight_server_profile_template.map,
    intersight_bulk_mo_cloner.servers_from_template
  ]
  for_each    = { for k, v in local.server : k => v }
  description = lookup(each.value, "description", "${each.value.name} Server Profile.")
  name        = each.value.name
  server_assignment_mode = length(regexall("UNUSED", each.value.resource_pool)) == 0 ? "Pool" : length(regexall(
    "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? "Static" : "None"
  server_pre_assign_by_serial = each.value.pre_assign.serial_number
  server_pre_assign_by_slot = [{
    additional_properties = ""
    chassis_id            = each.value.pre_assign.chassis_id
    class_id              = "server.ServerAssignTypeSlot"
    domain_name           = each.value.pre_assign.domain_name
    object_type           = "server.ServerAssignTypeSlot"
    slot_id               = each.value.pre_assign.slot_id
  }]
  static_uuid_address = each.value.static_uuid_address
  target_platform     = each.value.target_platform
  type                = "instance"
  uuid_address_type = length(regexall("UNUSED", each.value.uuid_pool)
  ) == 0 ? "POOL" : length(compact([each.value.static_uuid_address])) > 0 ? "STATIC" : "NONE"
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
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "assigned_server" {
    for_each = {
      for v in compact([each.value.serial_number]) : v => v if each.value.resource_pool == "UNUSED" && length(
        regexall("^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
      ) > 0
    }
    content {
      moid = data.intersight_compute_physical_summary.server[each.value.serial_number].results[0].moid
      object_type = data.intersight_compute_physical_summary.server[each.value.serial_number].results[0
      ].source_object_type
    }
  }
  dynamic "associated_server_pool" {
    for_each = { for v in each.value.policy_bucket : v.name => v if v.object_type == "resourcepool.Pool" }
    content {
      moid = contains(lookup(lookup(local.pools, "locals", {}), "resource", []), "${associated_server_pool.value.org}/${associated_server_pool.value.name}"
        ) == true ? local.pools.uuid["${associated_server_pool.value.org}/${associated_server_pool.value.name}"
      ] : local.data_sources.uuid["${associated_server_pool.value.org}/${associated_server_pool.value.name}"]
      object_type = "resourcepool.Pool"
    }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)
    ) == 0 && each.value.create_from_template == false }
    content {
      moid = contains(lookup(lookup(local.policies, "locals", {}), policy_bucket.value.policy, []), "${policy_bucket.value.org}/${policy_bucket.value.name}"
        ) == true ? local.policies[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"
      ] : local.data_sources[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"]
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
          ConsumerType = length(regexall("wwnn", each.value.reservation_type)) > 0 ? "WWNN" : "Vhba"
          ConsumerName = each.value.vhba_name
      }) : ""
      object_type = length(regexall("(wwnn|wwpn)", v.reservation_type)
      ) > 0 ? "fcpool.ReservationReference" : "${each.value.reservations_type}pool.ReservationReference"
      reservation_moid = length(regexall("ip", v.reservation_type)
        ) > 0 ? local.pools[each.value.organization].ip_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("iqn", v.reservation_type)
        ) > 0 ? local.pools[each.value.organization].iqn_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("mac", v.reservation_type)
        ) > 0 ? local.pools[each.value.organization].mac_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("uuid", v.reservation_type)
        ) > 0 ? local.pools[each.value.organization].uuid_reservations["${each.value.pool_name}:${each.value.identity}"
        ].moid : length(regexall("wwnn", v.reservation_type)
        ) > 0 ? local.pools[each.value.organization].wwnn_reservations["${each.value.pool_name}:${each.value.identity}"
      ].moid : local.pools[each.value.organization].wwpn_reservations["${each.value.pool_name}:${each.value.identity}"].moid
    }
  }
  dynamic "src_template" {
    for_each = { for v in compact([each.value.ucs_server_template]
    ) : v => v if each.value.create_from_template == true }
    content {
      moid        = intersight_server_profile_template.map[src_template.value].moid
      object_type = "server.ProfileTemplate"
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "uuid_pool" {
    for_each = {
      for v in each.value.policy_bucket : v.name => v if length(regexall("uuidpool.Pool", v.object_type)
      ) > 0 && each.value.create_from_template == false
    }
    content {
      moid = contains(lookup(lookup(local.pools, "locals", {}), "uuid", []), "${uuid_pool.value.org}/${uuid_pool.value.name}"
        ) == true ? local.pools.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"
      ] : local.data_sources.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"]
      object_type = "uuidpool.Pool"
    }
  }
}
