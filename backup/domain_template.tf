#__________________________________________________________________________
#
# Intersight Domain Profile Template Resource
# GUI Location: Templates > Create UCS Domain Profile Template
#__________________________________________________________________________

resource "intersight_fabric_switch_cluster_profile_template" "map" {
  for_each    = { for k, v in local.domain_template : k => v }
  description = lookup(each.value, "description", "${each.value.name} Domain Profile Template.")
  name        = each.value.name
  type        = "instance"
  organization {    moid        = var.orgs[each.value.org]  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


resource "intersight_fabric_switch_profile_template" "map" {
  depends_on = [
    data.intersight_search_search_item.policies,
    data.intersight_search_search_item.pools,
    intersight_fabric_switch_cluster_profile_template.map
  ]
  for_each    = { for k, v in local.switch_templates : k => v if v.create_template == true }
  description = each.value.description
  name        = each.value.name
  lifecycle { ignore_changes = [action, config_context, mod_time] }
  switch_cluster_profile_template { moid = intersight_fabric_switch_cluster_profile_template.map[each.value.domain_template].moid }
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

resource "intersight_bulk_mo_merger" "trigger_domain_profile_update" {
  depends_on   = [intersight_fabric_switch_cluster_profile.map]
  for_each     = { for k, v in local.domain : k => v if v.attach_template == true }
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    object_type = "fabric.SwitchClusterProfileTemplate"
    moid = contains(keys(local.switch_templates), each.value.ucs_domain_profile_template
      ) == true ? intersight_fabric_switch_cluster_profile_template.map[each.value.ucs_domain_profile_template
    ].moid : local.templates_data.ucs_domain_profile_template[each.value.ucs_domain_profile_template].moid
  }
  targets {
    object_type = "fabric.SwitchClusterProfile"
    moid        = intersight_fabric_switch_cluster_profile.map[each.key].moid
  }
}

resource "intersight_bulk_mo_merger" "trigger_switch_profile_update" {
  depends_on = [
    intersight_bulk_mo_merger.trigger_domain_profile_update,
    intersight_fabric_switch_profile.map
  ]
  for_each     = { for k, v in local.switch_profiles : k => v if v.attach_template == true }
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    object_type = "fabric.SwitchProfileTemplate"
    moid = contains(keys(local.switch_templates), each.value.ucs_switch_profile_template
      ) == true ? intersight_fabric_switch_profile_template.map[each.value.ucs_switch_profile_template
    ].moid : local.templates_data.ucs_switch_profile_template[each.value.ucs_switch_profile_template].moid
  }
  targets {
    object_type = "fabric.SwitchProfile"
    moid        = intersight_fabric_switch_profile.map[each.key].moid
  }
}
