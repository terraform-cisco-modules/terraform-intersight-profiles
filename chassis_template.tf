#__________________________________________________________________________
#
# Intersight Chassis Profile Template Resource
# GUI Location: Templates > Create UCS Chassis Profile Template
#__________________________________________________________________________

resource "intersight_chassis_profile_template" "map" {
  depends_on = [
    data.intersight_search_search_item.policies,
  ]
  for_each        = { for k, v in local.chassis_template : k => v if v.create_template == true }
  description     = each.value.description
  name            = each.value.name
  target_platform = each.value.target_platform
  lifecycle { ignore_changes = [action, config_context, mod_time] }
  organization { moid = var.orgs[each.value.org] }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if element(split("/", v.name), 1) != "UNUSED" }
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

resource "intersight_bulk_mo_merger" "trigger_chassis_profile_update" {
  depends_on   = [intersight_chassis_profile.map]
  for_each     = { for k, v in local.chassis : k => v if v.attach_template == true }
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    object_type = "chassis.ProfileTemplate"
    moid        = local.ucs_templates.chassis[each.value.ucs_chassis_profile_template].moid
  }
  targets {
    object_type = "chassis.Profile"
    moid        = intersight_chassis_profile.map[each.key].moid
  }
}