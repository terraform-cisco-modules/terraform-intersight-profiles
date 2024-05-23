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
    time_sleep.discovery
  ]
  for_each    = { for k, v in local.server : k => v }
  description = lookup(each.value, "description", "${each.value.name} Server Profile.")
  name        = each.value.name
  server_assignment_mode = length(regexall("UNUSED", each.value.resource_pool)) == 0 ? "Pool" : length(regexall(
    "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
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
  uuid_address_type = length([for v in each.value.policy_bucket : v if length(regexall("uuidpool.Pool", v.object_type)) > 0]
  ) > 0 ? "POOL" : length(compact([each.value.static_uuid_address])) > 0 ? "STATIC" : "NONE"
  lifecycle { ignore_changes = [action, config_context, mod_time, uuid_lease, scheduled_actions, wait_for_completion] }
  organization { moid = var.orgs[each.value.org] }
  dynamic "assigned_server" {
    for_each = {
      for v in compact([each.value.serial_number]) : v => v if each.value.resource_pool == "UNUSED" && length(
        regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
      ) > 0
    }
    content {
      moid        = data.intersight_compute_physical_summary.server[each.value.serial_number].results[0].moid
      object_type = data.intersight_compute_physical_summary.server[each.value.serial_number].results[0].source_object_type
    }
  }
  dynamic "associated_server_pool" {
    for_each = { for v in each.value.policy_bucket : v.name => v if v.object_type == "resourcepool.Pool" }
    content {
      moid = contains(keys(lookup(local.pools, "resource", {})), associated_server_pool.value.name
      ) == true ? local.pools.resource[associated_server_pool.value.name] : local.pools_data.resource[associated_server_pool.value.name].moid
      object_type = "resourcepool.Pool"
    }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)) == 0 && element(split("/", v.name), 1
    ) != "UNUSED" && element(split("/", each.value.ucs_server_profile_template), 1) == "UNUSED" && each.value.attach_template == false }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), policy_bucket.value.name
      ) == true ? local.policies[policy_bucket.value.policy][policy_bucket.value.name] : local.policies_data[policy_bucket.value.policy][policy_bucket.value.name].moid
      object_type = policy_bucket.value.object_type
    }
  }
  dynamic "reservation_references" {
    for_each = { for v in each.value.reservations : v.identity => v }
    content {
      additional_properties = length(regexall("^(ip|mac|wwnn|wwpn)$", reservation_references.value.identity_type)
        ) > 0 ? jsonencode({
          ConsumerType = reservation_references.value.identity_type == "ip" && length(regexall("band", reservation_references.value.management_type)
            ) > 0 ? "${title(lower(reservation_references.value.management_type))}${title(lower(reservation_references.value.ip_type))}-Access" : length(
            regexall("ip", reservation_references.value.identity_type)) > 0 ? "ISCSI" : length(regexall("mac", reservation_references.value.identity_type)) > 0 ? "Vnic" : length(
            regexall("wwnn", reservation_references.value.identity_type)
          ) > 0 ? "WWNN" : "Vhba"
          ConsumerName = length(regexall("band", reservation_references.value.management_type)
          ) == 0 && reservation_references.value.identity_type != "wwnn" ? reservation_references.value.interface : ""
      }) : ""
      class_id    = length(regexall("^(wwnn|wwpn)$", reservation_references.value.identity_type)) > 0 ? "fcpool.ReservationReference" : "${reservation_references.value.identity_type}pool.ReservationReference"
      object_type = length(regexall("^(wwnn|wwpn)$", reservation_references.value.identity_type)) > 0 ? "fcpool.ReservationReference" : "${reservation_references.value.identity_type}pool.ReservationReference"
      reservation_moid = length(regexall("/", reservation_references.value.pool_name)
        ) > 0 ? local.pools["${reservation_references.value.identity_type}_reservations"]["${reservation_references.value.pool_name}/${reservation_references.value.identity}"
      ] : local.pools["${reservation_references.value.identity_type}_reservations"]["${each.value.org}/${reservation_references.value.pool_name}/${reservation_references.value.identity}"]
    }
  }
  dynamic "src_template" {
    for_each = { for v in compact([each.value.ucs_server_profile_template]) : v => v if each.value.attach_template == true && element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.server_template), src_template.value) == true ? intersight_server_profile_template.map[src_template.value
      ].moid : local.templates_data.ucs_server_profile_template[src_template.value].moid
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
      for v in each.value.policy_bucket : v.name => v if v.object_type == "uuidpool.Pool" && element(split("/", v.name), 1
      ) != "UNUSED" && element(split("/", each.value.ucs_server_profile_template), 1) == "UNUSED" && each.value.attach_template == false
    }
    content {
      moid = contains(keys(lookup(local.pools, "uuid", {})), uuid_pool.value.name
      ) == true ? local.pools.uuid[uuid_pool.value.name] : local.pools_data.uuid[uuid_pool.value.name].moid
      object_type = "uuidpool.Pool"
    }
  }
}

#_________________________________________________________________________________________
#
# Sleep Timer between creating server profile and waiting for Validation
#_________________________________________________________________________________________
resource "time_sleep" "server" {
  depends_on      = [intersight_bulk_mo_merger.trigger_profile_update]
  for_each        = { for v in ["wait_for_validation_2m"] : v => v if length(local.switch_profiles) > 0 }
  create_duration = length([for k, v in local.switch_profiles : 1 if v.action == "Deploy"]) > 0 ? "2m" : "1s"
  triggers        = { always_run = length(local.wait_for_domain) > 0 ? timestamp() : 1 }
}

#_________________________________________________________________________________________
#
# Intersight: UCS Server Profiles
# GUI Location: Infrastructure Service > Configure > Profiles : UCS Server Profiles
#_________________________________________________________________________________________
resource "intersight_server_profile" "deploy" {
  depends_on = [time_sleep.server]
  for_each   = local.server
  action = length(regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? each.value.action : "No-op"
  target_platform = each.value.target_platform
  dynamic "scheduled_actions" {
    for_each = { for v in ["activate"] : v => v if length(regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
    ) > 0 && each.value.action == "Deploy" }
    content {
      action            = "Activate"
      object_type       = "policy.ScheduledAction"
      proceed_on_reboot = true
    }
  }
  lifecycle { ignore_changes = [
    action_params, ancestors, assigned_server, associated_server, associated_server_pool, create_time, description, domain_group_moid,
    mod_time, owners, parent, permission_resources, policy_bucket, reservation_references, running_workflows, server_assignment_mode,
    server_pool, shared_scope, src_template, tags, target_platform, uuid, uuid_address_type, uuid_lease, uuid_pool, version_context
  ] }
  name = each.value.name
  uuid_address_type = length([for v in each.value.policy_bucket : v if length(regexall("uuidpool.Pool", v.object_type)) > 0]
  ) > 0 ? "POOL" : length(compact([each.value.static_uuid_address])) > 0 ? "STATIC" : "NONE"
  organization { moid = var.orgs[each.value.org] }
}
