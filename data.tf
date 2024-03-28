#__________________________________________________________________
#
# Data Objects - Pools and Policies
#__________________________________________________________________

data "intersight_search_search_item" "policies" {
  for_each = { for v in local.policy_types : v => v if length(local.data_policies[v]) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_policy"].object_type}' and Name in ('${trim(join("', '", local.data_policies[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_policy"].object_type}" }
  )
}

data "intersight_search_search_item" "pools" {
  for_each = { for v in ["resource", "uuid"] : v => v if length(local.data_pools[v]) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_pool"].object_type}' and Name in ('${trim(join("', '", local.data_pools[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_pool"].object_type}" }
  )
}

data "intersight_search_search_item" "templates" {
  for_each = { for v in ["ucs_server_template"] : v => v if length(local.data_templates[v]) > 0 }
  additional_properties = jsonencode(
    { "ClassId" = "server.ProfileTemplate' and Name in ('${trim(join("', '", local.data_templates[each.key]), ", '")
    }') and ObjectType eq 'server.ProfileTemplate" }
  )
}
