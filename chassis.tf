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
  ]
  for_each        = local.chassis
  description     = lookup(each.value, "description", "${each.value.name} Chassis Profile.")
  name            = each.value.name
  target_platform = each.value.target_platform
  type            = "instance"
  lifecycle {
    ignore_changes = [
      action,
      additional_properties,
      config_context,
      mod_time,
      wait_for_completion
    ]
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "assigned_chassis" {
    for_each = {
      for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown"
    }
    content {
      moid = data.intersight_equipment_chassis.chassis[assigned_chassis.value].results[0].moid
    }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v }
    content {
      moid = length(regexall(false, var.moids_policies)) > 0 && length(regexall(
        policy_bucket.value.org, each.value.organization)) > 0 ? var.policies[policy_bucket.value.org][
        policy_bucket.value.policy][policy_bucket.value.name] : [for i in local.data_search[
          policy_bucket.value.policy][0].results : i.moid if jsondecode(i.additional_properties
          ).Organization.Moid == local.orgs[policy_bucket.value.org] && jsondecode(i.additional_properties
      ).Name == policy_bucket.value.name][0]
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
