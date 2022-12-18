#____________________________________________________________
#
# Intersight UCS Chassis Profile Resource
# GUI Location: Profiles > UCS Chassis Profile > Create
#____________________________________________________________

data "intersight_equipment_chassis" "chassis" {
  for_each = { for v in local.chassis_serial_numbers : v => v }
  serial   = each.value
}

resource "intersight_chassis_profile" "chassis" {
  depends_on = [
    data.intersight_equipment_chassis.chassis,
  ]
  for_each            = local.chassis
  description         = each.value.description != "" ? each.value.description : "${each.value.name} Chassis Profile."
  name                = each.value.name
  target_platform     = each.value.target_platform
  type                = "instance"
  wait_for_completion = each.value.wait_for_completion
  organization {
    moid = length(regexall(true, var.moids)
      ) > 0 ? local.orgs[each.value.organization
    ] : data.intersight_organization_organization.orgs[each.value.organization].results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "assigned_chassis" {
    for_each = { for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown" }
    content {
      moid = data.intersight_equipment_chassis.chassis[assigned_chassis.value].results[0].moid
    }
  }
  dynamic "policy_bucket" {
    for_each = { for v in each.value.policy_bucket : v.object_type => v }
    content {
      moid = length(regexall(true, local.moids)
        ) > 0 ? var.policies[policy_bucket.value.policy][policy_bucket.value.name
        ] : length(regexall("access.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_access_policy.imc_access[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("power.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_power_policy.power[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("snmp.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_snmp_policy.snmp[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
        ][0] : length(regexall("thermal.Policy", policy_bucket.value.object_type)
        ) > 0 ? [for i in data.intersight_thermal_policy.thermal[policy_bucket.value.name
        ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
      ][0] : ""
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
}
