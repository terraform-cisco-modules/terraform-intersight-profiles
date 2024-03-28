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
  for_each          = { for k, v in local.template : k => v if v.create_template == true }
  name              = each.value.name
  target_platform   = each.value.target_platform
  uuid_address_type = length(regexall("UNUSED", each.value.uuid_pool)) == 0 && length(compact([each.value.uuid_pool])) > 0 ? "POOL" : "NONE"
  lifecycle { ignore_changes = [action, config_context, description, mod_time] }
  organization { moid = var.orgs[each.value.organization] }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)) == 0 && v.name != "UNUSED" }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), "${policy_bucket.value.org}/${policy_bucket.value.name}"
        ) == true ? local.policies[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"
        ] : [for i in data.intersight_search_search_item.policies[policy_bucket.value.policy
          ].results : i.moid if jsondecode(i.additional_properties).Name == policy_bucket.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[policy_bucket.value.org]][0]
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
      moid = contains(keys(lookup(local.pools, "uuid", {})), "${uuid_pool.value.org}/${uuid_pool.value.name}"
        ) == true ? local.pools.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["uuid"
          ].results : i.moid if jsondecode(i.additional_properties).Name == uuid_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[uuid_pool.value.org]][0]
      object_type = "uuidpool.Pool"
    }
  }
}

resource "intersight_bulk_mo_merger" "trigger_profile_update" {
  depends_on   = [intersight_server_profile.map]
  for_each     = { for k, v in local.server : k => v if v.attach_template == true }
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    object_type = "server.ProfileTemplate"
    moid = contains(keys(local.template), each.value.ucs_server_template
      ) == true ? intersight_server_profile_template.map[each.value.ucs_server_template
      ].moid : [for i in data.intersight_search_search_item.templates["ucs_server_template"].results : i.moid if jsondecode(
        i.additional_properties).Name == element(split("/", each.value.ucs_server_template), 1) && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[element(split("/", each.value.ucs_server_template), 0)]][0]
    #moid        = intersight_server_profile_template.map[each.value.ucs_server_template].moid
  }
  targets {
    object_type = "server.Profile"
    moid        = intersight_server_profile.map[each.key].moid
  }
}