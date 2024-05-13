#____________________________________________________________
#
# Intersight UCS Chassis Profile Resource
# GUI Location: Profiles > UCS Chassis Profile > Create
#____________________________________________________________

data "intersight_equipment_chassis" "chassis" {
  for_each = { for v in local.chassis_serial_numbers : v => v }
  serial   = each.value
}

resource "intersight_chassis_profile" "map" {
  depends_on = [
    data.intersight_equipment_chassis.chassis,
    data.intersight_search_search_item.policies,
    data.intersight_search_search_item.pools,
    intersight_chassis_profile_template.map,
    time_sleep.discovery
  ]
  for_each        = local.chassis
  description     = lookup(each.value, "description", "${each.value.name} Chassis Profile.")
  name            = each.value.name
  target_platform = each.value.target_platform
  type            = "instance"
  lifecycle {
    ignore_changes = [action, additional_properties, config_context, mod_time, wait_for_completion]
  }
  organization { moid = var.orgs[each.value.organization] }
  dynamic "assigned_chassis" {
    for_each = { for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown" }
    content { moid = data.intersight_equipment_chassis.chassis[assigned_chassis.value].results[0].moid }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if element(split("/", v.name), 1) != "UNUSED" }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), policy_bucket.value.name
      ) == true ? local.policies[policy_bucket.value.policy][policy_bucket.value.name] : local.policies_data[policy_bucket.value.policy][policy_bucket.value.name].moid
      object_type = policy_bucket.value.object_type
    }
  }
  dynamic "src_template" {
    for_each = { for v in compact([each.value.ucs_chassis_profile_template]) : v => v if each.value.attach_template == true && element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.chassis_template), src_template.value) == true ? intersight_chassis_profile_template.map[src_template.value
      ].moid : local.templates_data.ucs_chassis_profile_template[src_template.value].moid
      object_type = "chassis.ProfileTemplate"
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
# Sleep Timer between Creating the Chassis Profile and Waiting for Validation
#_________________________________________________________________________________________
resource "time_sleep" "chassis" {
  depends_on      = [intersight_chassis_profile.map]
  for_each        = { for v in ["wait_for_validation_2m"] : v => v if length(local.chassis) > 0 }
  create_duration = length([for k, v in local.chassis : 1 if v.action == "Deploy"]) > 0 ? "2m" : "1s"
  triggers        = { always_run = length(local.wait_for_domain) > 0 ? timestamp() : 1 }
}

#_________________________________________________________________________________________
#
# Intersight: UCS Chassis Profiles
# GUI Location: Infrastructure Service > Configure > Profiles : UCS Chassis Profiles
#_________________________________________________________________________________________
resource "intersight_chassis_profile" "deploy" {
  depends_on = [time_sleep.chassis]
  for_each   = local.chassis
  action = length(regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? each.value.action : "No-op"
  lifecycle { ignore_changes = [
    action_params, ancestors, create_time, description, domain_group_moid, mod_time, owners, parent,
    permission_resources, policy_bucket, running_workflows, shared_scope, src_template, tags, version_context
  ] }
  name            = each.value.name
  target_platform = each.value.target_platform
  organization { moid = var.orgs[each.value.organization] }
}
