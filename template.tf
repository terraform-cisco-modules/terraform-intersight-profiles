#__________________________________________________________________________
#
# Intersight Server Profile Template Resource
# GUI Location: Templates > Create UCS Server Profile Template
#__________________________________________________________________________

#data "intersight_server_profile_template" "template" {
#  for_each = {
#    for v in compact([local.server_templates]) : v => v if length(
#      regexall("[[:xdigit:]]{24}", local.server_template)
#    ) == 0
#  }
#  name = each.value
#}

resource "intersight_server_profile_template" "template" {
  for_each        = { for k, v in local.template : k => v if v.create_template == true }
  name            = each.value.name
  description     = lookup(each.value, "description", "${each.value.name} Server Profile Template.")
  target_platform = each.value.target_platform
  uuid_address_type = length(regexall("UNUSED", each.value.uuid_pool.name)
  ) == 0 ? "POOL" : length(compact([each.value.static_uuid_address])) > 0 ? "STATIC" : "NONE"
  lifecycle {
    ignore_changes = [
      action,
      config_context,
      description,
      mod_time
    ]
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
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
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  dynamic "uuid_pool" {
    for_each = { for v in compact([each.value.uuid_pool.name]) : v => v }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.uuid_pool.org].uuid[
        each.value.uuid_pool.name
        ] : [for i in data.intersight_search_search_item.uuid[0].results : i.moid if jsondecode(
          i.additional_properties).Organization[0].Moid == local.orgs[each.value.uuid_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.uuid_pool.name][0]
      object_type = "uuidpool.Pool"
    }
  }
}

resource "intersight_bulk_mo_cloner" "servers_from_template" {
  for_each = { for k, v in local.server : k => v if v.create_from_template == true }
  lifecycle {
    ignore_changes = all # This is required for this resource type
  }
  sources {
    object_type = intersight_server_profile_template.template[each.value.ucs_server_profile_template].object_type
    moid        = intersight_server_profile_template.template[each.value.ucs_server_profile_template].moid
  }
  targets {
    object_type = "server.Profile"
    additional_properties = jsonencode({
      Name = each.key
    })
  }
}