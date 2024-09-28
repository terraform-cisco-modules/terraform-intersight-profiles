#__________________________________________________________________________
#
# Intersight Server Profile Resource
# GUI Location: Profiles > UCS Server Profiles > Create UCS Server Profile
#__________________________________________________________________________

data "intersight_compute_physical_summary" "server" {
  for_each = { for v in local.server_serial_numbers : v => v }
  serial   = each.value
}

#_________________________________________________________________________________________
#
# Intersight: UCS Server Profiles
# GUI Location: Infrastructure Service > Configure > Profiles : UCS Server Profiles
#_________________________________________________________________________________________
resource "intersight_server_profile" "reservations" {
  depends_on      = [
    data.intersight_compute_physical_summary.server,
    intersight_chassis_profile.deploy,
    intersight_server_profile_template.map,
    time_sleep.discovery
  ]
  for_each        = local.server_final
  target_platform = each.value.target_platform
  lifecycle { ignore_changes = [
    action, action_params, ancestors, assigned_server, associated_server, associated_server_pool, create_time, description, domain_group_moid,
    mod_time, owners, parent, permission_resources, policy_bucket, running_workflows, scheduled_actions, server_assignment_mode,
    server_pool, shared_scope, src_template, tags, target_platform, version_context
  ] }
  name              = each.value.name
  uuid_address_type = each.value.uuid_address_type
  organization { moid = var.orgs[each.value.org] }
  dynamic "reservation_references" {
    for_each = { for v in each.value.reservations : v.identity => v }
    content {
      additional_properties = length(regexall("^(ip|mac|wwnn|wwpn)$", reservation_references.value.identity_type)
        ) > 0 ? jsonencode({
          ConsumerType = reservation_references.value.identity_type == "ip" && length(regexall("band", reservation_references.value.management_type)
            ) > 0 ? "${title(lower(reservation_references.value.management_type))}${title(lower(reservation_references.value.ip_type))}-Access" : length(
            regexall("ip", reservation_references.value.identity_type)) > 0 ? "ISCSI" : length(
            regexall("mac", reservation_references.value.identity_type)) > 0 ? "Vnic" : length(
            regexall("wwnn", reservation_references.value.identity_type)
          ) > 0 ? "WWNN" : "Vhba"
          ConsumerName = length(regexall("band", reservation_references.value.management_type)
          ) == 0 && reservation_references.value.identity_type != "wwnn" ? reservation_references.value.interface : ""
      }) : ""
      class_id = length(regexall("^(wwnn|wwpn)$", reservation_references.value.identity_type)
      ) > 0 ? "fcpool.ReservationReference" : "${reservation_references.value.identity_type}pool.ReservationReference"
      object_type = length(regexall("^(wwnn|wwpn)$", reservation_references.value.identity_type)
      ) > 0 ? "fcpool.ReservationReference" : "${reservation_references.value.identity_type}pool.ReservationReference"
      reservation_moid = local.pools.reservations[reservation_references.value.identity_type][
        "${reservation_references.value.pool_name}/${reservation_references.value.identity}"
      ]
    }
  }
  dynamic "uuid_pool" {
    for_each = { for v in [each.value.uuid_pool] : v => v if length(regexall("UNUSED", v)) == 0 }
    content {
      moid        = each.value.attach_template == true ? uuid_pool.value : local.pools_data.uuid[uuid_pool.value].moid
      object_type = "uuidpool.Pool"
    }
  }
}

resource "intersight_server_profile" "map" {
  depends_on = [
    intersight_server_profile.reservations,
  ]
  for_each = { for k, v in local.server_final : k => v }
  additional_properties = jsonencode({
    SrcTemplate = each.value.attach_template == true && each.value.detach_template == false && length(regexall("UNUSED", each.value.ucs_server_profile_template)
    ) == 0 ? { Moid = local.ucs_templates.server[each.value.ucs_server_profile_template].moid, ObjectType = "server.ProfileTemplate" } : null
  })
  name = each.value.name
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
  user_label          = each.value.user_label
  uuid_address_type   = each.value.uuid_address_type
  lifecycle { ignore_changes = [
    action, config_context, description, mod_time, reservation_references, scheduled_actions, src_template, uuid_lease, wait_for_completion
  ] }
  organization { moid = var.orgs[each.value.org] }
  dynamic "assigned_server" {
    for_each = {
      for v in compact([each.value.serial_number]) : v => v if length(regexall("UNUSED", each.value.resource_pool)) > 0 && length(
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
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)
    ) == 0 && element(split("/", v.name), 1) != "UNUSED" && each.value.attach_template == false }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), policy_bucket.value.name
      ) == true ? local.policies[policy_bucket.value.policy][policy_bucket.value.name] : local.policies_data[policy_bucket.value.policy][policy_bucket.value.name].moid
      object_type = policy_bucket.value.object_type
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#_________________________________________________________________________________________
#
# Sleep Timer between creating server profile and waiting for Validation
#_________________________________________________________________________________________
resource "time_sleep" "server" {
  depends_on      = [intersight_bulk_mo_merger.trigger_profile_update]
  for_each        = { for v in ["wait_for_validation_2m"] : v => v if length(local.server_final) > 0 }
  create_duration = length([for k, v in local.server_final : 1 if v.action == "Deploy"]) > 0 ? "2m" : "1s"
  triggers        = { always_run = length([for k, v in local.server_final : 1 if v.action == "Deploy"]) > 0 ? timestamp() : 1 }
}

#_________________________________________________________________________________________
#
# Intersight: UCS Server Profiles
# GUI Location: Infrastructure Service > Configure > Profiles : UCS Server Profiles
#_________________________________________________________________________________________
resource "intersight_server_profile" "deploy" {
  depends_on = [time_sleep.server]
  for_each   = local.server_final
  action = length(regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? each.value.action : "No-op"
  description     = coalesce(each.value.description, "${each.value.name} Server Profile")
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
    action_params, ancestors, assigned_server, associated_server, associated_server_pool, create_time, domain_group_moid,
    mod_time, owners, parent, permission_resources, policy_bucket, reservation_references, running_workflows, server_assignment_mode,
    server_pool, shared_scope, src_template, tags, target_platform, uuid, uuid_address_type, uuid_lease, uuid_pool, version_context
  ] }
  name              = each.value.name
  uuid_address_type = each.value.uuid_address_type
  organization { moid = var.orgs[each.value.org] }
}
