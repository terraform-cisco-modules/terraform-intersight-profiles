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
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
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
  for_each = { for k, v in local.switch_templates : k => v if v.create_template == true }
  name     = each.value.name
  lifecycle { ignore_changes = [action, config_context, mod_time] }
  switch_cluster_profile_template { moid = intersight_fabric_switch_cluster_profile_template.map[each.value.domain_profile].moid }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v if v.name != "UNUSED" }
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
}

resource "intersight_bulk_mo_merger" "trigger_domain_profile_update" {
  depends_on   = [intersight_fabric_switch_cluster_profile.map]
  for_each     = { for k, v in local.domain : k => v if v.attach_template == true }
  merge_action = "Merge"
  lifecycle { ignore_changes = all }
  sources {
    object_type = "fabric.SwitchClusterProfileTemplate"
    moid = contains(keys(local.domain_template), each.value.ucs_domain_template
      ) == true ? intersight_fabric_switch_cluster_profile_template.map[each.value.ucs_domain_template
      ].moid : [for i in data.intersight_search_search_item.templates["ucs_domain_template"].results : i.moid if jsondecode(
        i.additional_properties).Name == element(split("/", each.value.ucs_domain_template), 1) && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[element(split("/", each.value.ucs_domain_template), 0)]][0]
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
    moid = contains(keys(local.switch_templates), each.value.ucs_switch_template
      ) == true ? intersight_fabric_switch_profile_template.map[each.value.ucs_switch_template
      ].moid : [for i in data.intersight_search_search_item.templates["ucs_switch_template"].results : i.moid if jsondecode(
        i.additional_properties).Name == element(split("/", each.value.ucs_switch_template), 1) && jsondecode(i.additional_properties
    ).Organization.Moid == var.orgs[element(split("/", each.value.ucs_switch_template), 0)]][0]
  }
  targets {
    object_type = "fabric.SwitchProfile"
    moid        = intersight_fabric_switch_profile.map[each.key].moid
  }
}
