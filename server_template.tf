#__________________________________________________________________________
#
# Intersight Server Profile Template Resource
# GUI Location: Templates > Create UCS Server Profile Template
#__________________________________________________________________________

resource "intersight_server_profile_template" "map" {
  depends_on = [
    data.intersight_search_search_item.policies,
    data.intersight_search_search_item.pools,
  ]
  for_each          = { for k, v in local.server_template : k => v if v.create_template == true }
  description       = lookup(each.value, "description", "${each.value.name} Server Profile Template.")
  name              = each.value.name
  target_platform   = each.value.target_platform
  uuid_address_type = each.value.uuid_address_type
  lifecycle { ignore_changes = [action, config_context, description, mod_time] }
  organization { moid = var.orgs[each.value.org] }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)) == 0 && element(split("/", v.name), 1) != "UNUSED" }
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
  dynamic "uuid_pool" {
    for_each = { for v in each.value.policy_bucket : v.name => v if v.object_type == "uuidpool.Pool" && element(split("/", v.name), 1) != "UNUSED" }
    content {
      moid = contains(keys(lookup(local.pools, "uuid", {})), uuid_pool.value.name
      ) == true ? local.pools.uuid[uuid_pool.value.name] : local.pools_data["uuid"][uuid_pool.value.name].moid
      object_type = "uuidpool.Pool"
    }
  }
}

resource "intersight_bulk_mo_merger" "trigger_profile_update" {
  depends_on   = [intersight_server_profile.map]
  for_each     = { for k, v in local.server_final : k => v if v.attach_template == true && v.detach_template == false }
  class_id     = "bulk.MoMerger"
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    class_id    = "server.ProfileTemplate"
    moid        = local.ucs_templates.server[each.value.ucs_server_profile_template].moid
    object_type = "server.ProfileTemplate"
  }
  targets {
    class_id    = "server.Profile"
    moid        = intersight_server_profile.map[each.key].moid
    object_type = "server.Profile"
  }
}