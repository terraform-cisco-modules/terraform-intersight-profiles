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

resource "intersight_server_profile_template" "map" {
  for_each        = { for k, v in local.template : k => v if v.create_template == true }
  name            = each.value.name
  description     = lookup(each.value, "description", "${each.value.name} Server Profile Template.")
  target_platform = each.value.target_platform
  uuid_address_type = length(regexall("UNUSED", each.value.uuid_pool)
  ) == 0 && length(compact([each.value.uuid_pool])) > 0 ? "POOL" : "NONE"
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
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)) == 0 }
    content {
      moid = length(regexall(false, local.moids_policies)) > 0 && length(regexall(
        policy_bucket.value.org, each.value.organization)) > 0 ? local.policies[policy_bucket.value.org][
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
  dynamic "uuid_pool" {
    for_each = { for v in each.value.policy_bucket : v.name => v if v.object_type == "uuidpool.Pool" }
    content {
      moid = length(regexall(false, local.moids_pools)) > 0 ? local.pools[uuid_pool.value.org].uuid[
        uuid_pool.value.name
        ] : [for i in data.intersight_search_search_item.uuid[0].results : i.moid if jsondecode(
          i.additional_properties).Organization[0].Moid == local.orgs[uuid_pool.value.org
      ] && jsondecode(i.additional_properties).Name == uuid_pool.value.name][0]
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
    object_type = intersight_server_profile_template.map[each.value.ucs_server_template].object_type
    moid        = intersight_server_profile_template.map[each.value.ucs_server_template].moid
  }
  targets {
    object_type = "server.Profile"
    additional_properties = jsonencode({
      Name = each.key
    })
  }
}