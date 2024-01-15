locals {
  defaults  = yamldecode(file("${path.module}/defaults.yaml"))
  lchassis  = local.defaults.profiles.chassis
  lserver   = local.defaults.profiles.server
  ltemplate = local.defaults.templates.server

  name_prefix = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.profile_names : e => lookup(lookup(var.model[org], "name_prefix", local.npfx), e, local.npfx[e]) },
    { organization = org })
  }
  name_suffix = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.profile_names : e => lookup(lookup(var.model[org], "name_suffix", local.nsfx), e, local.nsfx[e]) },
    { organization = org })
  }
  npfx          = local.defaults.profiles.name_prefix
  nsfx          = local.defaults.profiles.name_suffix
  orgs          = var.orgs
  policies      = lookup(var.policies, "map", {})
  pools         = lookup(var.pools, "map", {})
  profile_names = ["chassis", "server", "template"]

  data_sources = {
    adapter_configuration = { for v in sort(keys(intersight_adapter_config_policy.data)) : v => intersight_adapter_config_policy.data[v].moid }
    bios                  = { for v in sort(keys(intersight_bios_policy.data)) : v => intersight_bios_policy.data[v].moid }
    boot_order            = { for v in sort(keys(intersight_boot_precision_policy.data)) : v => intersight_boot_precision_policy.data[v].moid }
    certificate_management = {
      for v in sort(keys(intersight_certificatemanagement_policy.data)) : v => intersight_certificatemanagement_policy.data[v].moid
    }
    device_connector = { for v in sort(keys(intersight_deviceconnector_policy.data)) : v => intersight_deviceconnector_policy.data[v].moid }
    drive_security = {
      for v in sort(keys(intersight_storage_drive_security_policy.data)) : v => intersight_storage_drive_security_policy.data[v].moid
    }
    firmware         = { for v in sort(keys(intersight_firmware_policy.data)) : v => intersight_firmware_policy.data[v].moid }
    imc_access       = { for v in sort(keys(intersight_access_policy.data)) : v => intersight_access_policy.data[v].moid }
    ipmi_over_lan    = { for v in sort(keys(intersight_ipmioverlan_policy.data)) : v => intersight_ipmioverlan_policy.data[v].moid }
    lan_connectivity = { for v in sort(keys(intersight_vnic_lan_connectivity_policy.data)) : v => intersight_vnic_lan_connectivity_policy.data[v].moid }
    ldap             = { for v in sort(keys(intersight_iam_ldap_policy.data)) : v => intersight_iam_ldap_policy.data[v].moid }
    local_user       = { for v in sort(keys(intersight_iam_end_point_user_policy.data)) : v => intersight_iam_end_point_user_policy.data[v].moid }
    network_connectivity = {
      for v in sort(keys(intersight_networkconfig_policy.data)) : v => intersight_networkconfig_policy.data[v].moid
    }
    ntp = { for v in sort(keys(intersight_ntp_policy.data)) : v => intersight_ntp_policy.data[v].moid }
    persistent_memory = {
      for v in sort(keys(intersight_memory_persistent_memory_policy.data)) : v => intersight_memory_persistent_memory_policy.data[v].moid
    }
    power            = { for v in sort(keys(intersight_power_policy.data)) : v => intersight_power_policy.data[v].moid }
    resource         = { for v in sort(keys(intersight_resourcepool_pool.data)) : v => intersight_resourcepool_pool.data[v].moid }
    san_connectivity = { for v in sort(keys(intersight_vnic_san_connectivity_policy.data)) : v => intersight_vnic_san_connectivity_policy.data[v].moid }
    sd_card          = { for v in sort(keys(intersight_sdcard_policy.data)) : v => intersight_sdcard_policy.data[v].moid }
    serial_over_lan  = { for v in sort(keys(intersight_sol_policy.data)) : v => intersight_sol_policy.data[v].moid }
    smtp             = { for v in sort(keys(intersight_smtp_policy.data)) : v => intersight_smtp_policy.data[v].moid }
    snmp             = { for v in sort(keys(intersight_snmp_policy.data)) : v => intersight_snmp_policy.data[v].moid }
    ssh              = { for v in sort(keys(intersight_ssh_policy.data)) : v => intersight_ssh_policy.data[v].moid }
    storage          = { for v in sort(keys(intersight_storage_storage_policy.data)) : v => intersight_storage_storage_policy.data[v].moid }
    syslog           = { for v in sort(keys(intersight_syslog_policy.data)) : v => intersight_syslog_policy.data[v].moid }
    thermal          = { for v in sort(keys(intersight_thermal_policy.data)) : v => intersight_thermal_policy.data[v].moid }
    uuid             = { for v in sort(keys(intersight_uuidpool_pool.data)) : v => intersight_uuidpool_pool.data[v].moid }
    virtual_kvm      = { for v in sort(keys(intersight_kvm_policy.data)) : v => intersight_kvm_policy.data[v].moid }
    virtual_media    = { for v in sort(keys(intersight_vmedia_policy.data)) : v => intersight_vmedia_policy.data[v].moid }
  }

  #_________________________________________________________________________________________
  #
  # Get Policy Names from Profiles and Templates
  #_________________________________________________________________________________________

  pb = { for i in local.bucket.policies : trimsuffix(trimsuffix(i, "_policy"), "_pool") => setsubtract(distinct(compact(concat(
    [for e in local.chassis : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]],
    [for e in local.server : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]],
    [for e in local.template : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]]
  ))), ["UNUSED"]) }

  #_________________________________________________________________________________________
  #
  # Policy Bucket Settings
  #_________________________________________________________________________________________

  bucket = {
    adapter_configuration_policy  = { object_type = "adapter.ConfigPolicy", policy = "adapter_configuration", }
    bios_policy                   = { object_type = "bios.Policy", policy = "bios" }
    boot_order_policy             = { object_type = "boot.PrecisionPolicy", policy = "boot_order" }
    certificate_management_policy = { object_type = "certificatemanagement.Policy", policy = "certificate_management", }
    chassis                       = ["imc_access_policy", "power_policy", "snmp_policy", "thermal_policy", ]
    device_connector_policy       = { object_type = "deviceconnector.Policy", policy = "device_connector", }
    drive_security_policy         = { object_type = "storage.DriveSecurityPolicy", policy = "drive_security", }
    FIAttached = [
      "device_connector_policy", "ldap_policy", "network_connectivity_policy", "ntp_policy",
      "persistent_memory_policy", "thermal_policy"
    ]
    firmware_policy             = { object_type = "firmware.Policy", policy = "firmware", }
    imc_access_policy           = { object_type = "access.Policy", policy = "imc_access", }
    ipmi_over_lan_policy        = { object_type = "ipmioverlan.Policy", policy = "ipmi_over_lan", }
    lan_connectivity_policy     = { object_type = "vnic.LanConnectivityPolicy", policy = "lan_connectivity", }
    ldap_policy                 = { object_type = "iam.LdapPolicy", policy = "ldap", }
    local_user_policy           = { object_type = "iam.EndPointUserPolicy", policy = "local_user", }
    network_connectivity_policy = { object_type = "networkconfig.Policy", policy = "network_connectivity", }
    ntp_policy                  = { object_type = "ntp.Policy", policy = "ntp", }
    persistent_memory_policy    = { object_type = "memory.PersistentMemoryPolicy", policy = "persistent_memory", }
    policies = [
      "adapter_configuration_policy", "bios_policy", "boot_order_policy", "certificate_management_policy",
      "device_connector_policy", "drive_security_policy", "firmware_policy", "imc_access_policy",
      "ipmi_over_lan_policy", "lan_connectivity_policy", "ldap_policy", "local_user_policy",
      "network_connectivity_policy", "ntp_policy", "persistent_memory_policy", "power_policy", "resource_pool",
      "san_connectivity_policy", "sd_card_policy", "serial_over_lan_policy", "smtp_policy", "snmp_policy", "ssh_policy",
      "storage_policy", "syslog_policy", "thermal_policy", "uuid_pool", "virtual_kvm_policy", "virtual_media_policy",
    ]
    power_policy            = { object_type = "power.Policy", policy = "power", }
    resource_pool           = { object_type = "resourcepool.Pool", policy = "resource", }
    san_connectivity_policy = { object_type = "vnic.SanConnectivityPolicy", policy = "san_connectivity", }
    sd_card_policy          = { object_type = "sdcard.Policy", policy = "sd_card", }
    serial_over_lan_policy  = { object_type = "sol.Policy", policy = "serial_over_lan", }
    smtp_policy             = { object_type = "smtp.Policy", policy = "smtp", }
    snmp_policy             = { object_type = "snmp.Policy", policy = "snmp", }
    ssh_policy              = { object_type = "ssh.Policy", policy = "ssh", }
    Standalone              = ["imc_access_poicy", "power_policy", "resource_pool", "thermal_policy", "uuid_pool"]
    storage_policy          = { object_type = "storage.StoragePolicy", policy = "storage", }
    syslog_policy           = { object_type = "syslog.Policy", policy = "syslog", }
    thermal_policy          = { object_type = "thermal.Policy", policy = "thermal", }
    uuid_pool               = { object_type = "uuidpool.Pool", policy = "uuid", }
    virtual_kvm_policy      = { object_type = "kvm.Policy", policy = "virtual_kvm", }
    virtual_media_policy    = { object_type = "vmedia.Policy", policy = "virtual_media", }
  }

  #_________________________________________________________________________________________
  #
  # Chassis Profile
  #_________________________________________________________________________________________

  chassis = { for d in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "profiles", {}), "chassis", []) : [
      for i in v.targets : merge(local.lchassis, v, i, {
        key          = v.name
        name         = "${local.name_prefix[org].chassis}${i.name}${local.name_suffix[org].chassis}"
        organization = org
        policy_bucket = { for e in local.bucket.chassis : replace(local.bucket[e].object_type, ".", "") => {
          name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED" }
        tags = lookup(v, "tags", var.global_settings.tags)
      })
  ]] if length(lookup(lookup(var.model[org], "profiles", {}), "chassis", [])) > 0]) : "${d.organization}/${d.key}" => d }
  chassis_serial_numbers = compact([for v in local.chassis : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])

  #_________________________________________________________________________________________
  #
  # Server Profile Templates
  #_________________________________________________________________________________________
  template = { for d in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "templates", {}), "server", []) : merge(
      local.defaults.policy_bucket, local.ltemplate, v, {
        key          = v.name
        name         = "${local.name_prefix[org].template}${v.name}${local.name_suffix[org].template}"
        organization = org
        policy_bucket = { for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]) : replace(
          local.bucket[e].object_type, ".", "") => {
          name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
          policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
        }
        tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "templates", {}), "server", [])) > 0]) : "${d.organization}/${d.key}" => d }

  #_________________________________________________________________________________________
  #
  # Server Profiles
  #_________________________________________________________________________________________
  servers = { for d in flatten([for org in sort(keys(var.model)) : [for v in lookup(lookup(var.model[org], "profiles", {}), "server", []) : [
    for i in v.targets : merge(local.defaults.policy_bucket, local.lserver, v, i, {
      key          = v.name
      name         = "${local.name_prefix[org].server}${i.name}${local.name_suffix[org].server}"
      organization = org
      policy_bucket = { for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]
        ) : replace(local.bucket[e].object_type, ".", "") => {
        name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
        object_type = local.bucket[e].object_type
        org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
        policy      = local.bucket[e].policy
      } if lookup(v, e, "UNUSED") != "UNUSED" }
      pre_assign   = merge(local.lserver.pre_assign, lookup(i, "pre_assign", {}), { domain_name = lookup(v, "domain_name", "") })
      reservations = lookup(v, "ignore_reservations", true) == false ? [for e in lookup(i, "reservations", []) : merge(local.lserver.reservations, e)] : []
      tags         = lookup(v, "tags", var.global_settings.tags)
      ucs_server_template = length(regexall("/", lookup(v, "ucs_server_template", "UNUSED"))
      ) > 0 ? v.ucs_server_template : length(compact([lookup(v, "ucs_server_template", "")])) > 0 ? "${org}/${v.ucs_server_template}" : ""
    })
  ]] if length(lookup(lookup(var.model[org], "profiles", {}), "server", [])) > 0]) : "${d.organization}/${d.key}" => d }
  server = { for v in local.servers : v.name => merge(v, {
    policy_bucket = length(compact([v.ucs_server_template])) > 0 ? merge(local.template[v.ucs_server_template].policy_bucket, v.policy_bucket) : v.policy_bucket
    target_platform = v.create_from_template == true && length(compact([v.ucs_server_template])
    ) > 0 ? local.template[v.ucs_server_template].target_platform : v.target_platform
  }) }
  server_serial_numbers = compact([for v in local.server : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])
}