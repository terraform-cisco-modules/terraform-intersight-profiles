#__________________________________________________________________________
#
# Intersight Server Profile Template Resource
# GUI Location: Templates > Create UCS Server Profile Template
#__________________________________________________________________________

resource "intersight_server_profile_template" "map" {
  depends_on = [
    intersight_resourcepool_pool.data,
    intersight_uuidpool_pool.data,
    intersight_access_policy.data,
    intersight_adapter_config_policy.data,
    intersight_bios_policy.data,
    intersight_boot_precision_policy.data,
    intersight_certificatemanagement_policy.data,
    intersight_deviceconnector_policy.data,
    intersight_firmware_policy.data,
    intersight_iam_end_point_user_policy.data,
    intersight_iam_ldap_policy.data,
    intersight_ipmioverlan_policy.data,
    intersight_kvm_policy.data,
    intersight_memory_persistent_memory_policy.data,
    intersight_networkconfig_policy.data,
    intersight_ntp_policy.data,
    intersight_power_policy.data,
    intersight_sdcard_policy.data,
    intersight_smtp_policy.data,
    intersight_snmp_policy.data,
    intersight_sol_policy.data,
    intersight_ssh_policy.data,
    intersight_storage_drive_security_policy.data,
    intersight_storage_storage_policy.data,
    intersight_syslog_policy.data,
    intersight_thermal_policy.data,
    intersight_vmedia_policy.data,
    intersight_vnic_lan_connectivity_policy.data,
    intersight_vnic_san_connectivity_policy.data
  ]
  for_each          = { for k, v in local.template : k => v if v.create_template == true }
  name              = each.value.name
  target_platform   = each.value.target_platform
  uuid_address_type = length(regexall("UNUSED", each.value.uuid_pool)) == 0 && length(compact([each.value.uuid_pool])) > 0 ? "POOL" : "NONE"
  lifecycle { ignore_changes = [action, config_context, description, mod_time] }
  organization { moid = local.orgs[each.value.organization] }
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
      moid = contains(lookup(lookup(local.pools, "locals", {}), "uuid", []), "${uuid_pool.value.org}/${uuid_pool.value.name}"
      ) == true ? local.pools.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"] : local.data_sources.uuid["${uuid_pool.value.org}/${uuid_pool.value.name}"]
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
    object_type = intersight_server_profile_template.map[each.value.ucs_server_template].object_type
    moid        = intersight_server_profile_template.map[each.value.ucs_server_template].moid
  }
  targets {
    object_type = "server.Profile"
    moid        = intersight_server_profile.map[each.key].moid
  }
}