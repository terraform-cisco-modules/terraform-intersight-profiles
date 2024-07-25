#__________________________________________________________________
#
# Data Objects - Pools and Policies
#__________________________________________________________________

data "intersight_search_search_item" "policies" {
  for_each = { for v in local.policy_types : v => v if length(compact(local.data_policies[v])) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_policy"].object_type}' and Name in ('${trim(join("', '", local.data_policies[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_policy"].object_type}" }
  )
}

data "intersight_search_search_item" "pools" {
  for_each = { for v in ["resource", "uuid"] : v => v if length(compact(local.data_pools[v])) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_pool"].object_type}' and Name in ('${trim(join("', '", local.data_pools[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_pool"].object_type}" }
  )
}

data "intersight_chassis_profile_template" "map" {
  for_each = { for v in local.data_templates.ucs_chassis_profile_template : v => v }
  name     = each.value
}
data "intersight_fabric_switch_cluster_profile_template" "map" {
  for_each = { for v in local.data_templates.ucs_domain_profile_template : v => v }
  name     = each.value
}
data "intersight_fabric_switch_profile_template" "map" {
  for_each = { for v in local.data_templates.ucs_switch_profile_template : v => v }
  name     = each.value
}
data "intersight_server_profile_template" "map" {
  for_each = { for v in local.data_templates.ucs_server_profile_template : v => v }
  name     = each.value
}
