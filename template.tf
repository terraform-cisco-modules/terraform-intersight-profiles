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
  lifecycle { ignore_changes = [action, config_context, description, mod_time] }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if length(regexall("pool", v.object_type)) == 0 }
    content {
      moid = contains(lookup(lookup(local.policies, "locals", {}), policy_bucket.value.policy, []), "${policy_bucket.value.org}/${policy_bucket.value.name}"
        ) == true ? local.policies[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"
      ] : local.data_sources[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"]
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
      moid = contains(lookup(lookup(local.pools, "locals", {}), uuid_pool.value.policy, []), "${uuid_pool.value.org}/${uuid_pool.value.name}"
        ) == true ? local.pools.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"
      ] : local.data_sources.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"]
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