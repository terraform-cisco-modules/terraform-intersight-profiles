#____________________________________________________________
#
# Intersight UCS Domain Profile Resource
# GUI Location: Profiles > UCS Domain Profile > Create
#____________________________________________________________

data "intersight_network_element_summary" "fis" {
  for_each = { for s in local.domain_serial_numbers : s => s }
  serial   = each.value
}

resource "intersight_fabric_switch_cluster_profile" "map" {
  depends_on = [
    intersight_fabric_switch_cluster_profile_template.map
  ]
  for_each    = { for k, v in local.domain : k => v }
  description = lookup(each.value, "description", "${each.value.name} Domain Profile.")
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


resource "intersight_fabric_switch_profile" "map" {
  depends_on = [
    data.intersight_network_element_summary.fis,
    intersight_fabric_switch_cluster_profile.map
  ]
  for_each = local.switch_profiles
  dynamic "assigned_switch" {
    for_each = { for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown" }
    content {
      moid = data.intersight_network_element_summary.fis[each.value.serial_number].results[0].moid
    }
  }
  description = lookup(each.value, "description", "${each.value.name} Switch Profile.")
  lifecycle {
    ignore_changes = [
      #action,
      additional_properties,
      mod_time,
      #wait_for_completion
    ]
  }
  name = each.value.name
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
  dynamic "policy_bucket" {
    for_each = { for k, v in each.value.policy_bucket : v.object_type => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), "${policy_bucket.value.org}/${policy_bucket.value.name}"
        ) == true ? local.policies[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"
        ] : [for i in data.intersight_search_search_item.policies[policy_bucket.value.policy
          ].results : i.moid if jsondecode(i.additional_properties).Name == policy_bucket.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[policy_bucket.value.org]][0]
      object_type = policy_bucket.value.object_type
    }
  }
  switch_cluster_profile { moid = intersight_fabric_switch_cluster_profile.map[each.value.domain_profile].moid }
  type = "instance"
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#_________________________________________________________________________________________
#
# Sleep Timer between creating domain profile and waiting for Validation
#_________________________________________________________________________________________
resource "time_sleep" "domain" {
  depends_on      = [intersight_fabric_switch_profile.map]
  for_each        = { for v in ["wait_for_validation_2m"] : v => v if length(local.switch_profiles) > 0 }
  create_duration = length([for k, v in local.switch_profiles : 1 if v.action == "Deploy"]) > 0 ? "2m" : "1s"
  triggers        = { always_run = length(local.wait_for_domain) > 0 ? timestamp() : 1 }
}

#_________________________________________________________________________________________
#
# Intersight: UCS Domain Profiles
# GUI Location: Infrastructure Service > Configure > Profiles : UCS Domain Profiles
#_________________________________________________________________________________________
resource "intersight_fabric_switch_profile" "deploy" {
  depends_on = [time_sleep.domain]
  for_each   = { for k, v in local.switch_profiles : k => v }
  action = length(regexall("^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
  ) > 0 ? each.value.action : "No-op"
  lifecycle {
    ignore_changes = [
      action_params, ancestors, assigned_switch, create_time, description, domain_group_moid, mod_time, owners, parent,
      permission_resources, policy_bucket, running_workflows, shared_scope, src_template, tags, version_context
    ]
  }
  name = each.value.name
  switch_cluster_profile { moid = intersight_fabric_switch_cluster_profile.map[each.value.domain_profile].moid }
  wait_for_completion = local.switch_profiles[element(keys(local.switch_profiles), length(keys(local.switch_profiles)) - 1)
  ].name == each.value.name ? true : false
}

#_________________________________________________________________________________________
#
# Sleep Timer between Deploying the Domain and Waiting for Server Discovery
#_________________________________________________________________________________________
resource "time_sleep" "discovery" {
  depends_on      = [intersight_fabric_switch_profile.deploy]
  for_each        = { for v in ["wait_time_30min"] : v => v if length(local.switch_profiles) > 0 }
  create_duration = length([for k, v in local.switch_profiles : 1 if v.action == "Deploy"]) > 0 ? "30m" : "1s"
  triggers        = { always_run = length(local.wait_for_domain) > 0 ? timestamp() : 1 }
}
