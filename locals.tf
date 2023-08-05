locals {
  defaults  = yamldecode(file("${path.module}/defaults.yaml"))
  lchassis  = local.defaults.profiles.chassis
  lserver   = local.defaults.profiles.server
  ltemplate = local.defaults.templates.server
  model     = var.model

  name_prefix = [for v in [merge(lookup(local.profiles, "name_prefix", {}), local.defaults.profiles.name_prefix)] : {
    chassis  = v.chassis != "" ? v.chassis : v.default
    server   = v.server != "" ? v.server : v.default
    template = v.template != "" ? v.template : v.default
  }][0]
  name_suffix = [for v in [merge(lookup(local.profiles, "name_suffix", {}), local.defaults.profiles.name_suffix)] : {
    chassis  = v.chassis != "" ? v.chassis : v.default
    server   = v.server != "" ? v.server : v.default
    template = v.template != "" ? v.template : v.default
  }][0]

  orgs      = var.orgs
  profiles  = lookup(var.profiles, "profiles", {})
  templates = lookup(var.profiles, "templates", {})

  data_search = {
    adapter_configuration  = data.intersight_search_search_item.adapter_configuration
    bios                   = data.intersight_search_search_item.bios
    boot_order             = data.intersight_search_search_item.boot_order
    certificate_management = data.intersight_search_search_item.certificate_management
    device_connector       = data.intersight_search_search_item.device_connector
    drive_security         = data.intersight_search_search_item.drive_security
    imc_access             = data.intersight_search_search_item.imc_access
    ipmi_over_lan          = data.intersight_search_search_item.ipmi_over_lan
    lan_connectivity       = data.intersight_search_search_item.lan_connectivity
    ldap                   = data.intersight_search_search_item.ldap
    local_user             = data.intersight_search_search_item.local_user
    network_connectivity   = data.intersight_search_search_item.network_connectivity
    ntp                    = data.intersight_search_search_item.ntp
    persistent_memory      = data.intersight_search_search_item.persistent_memory
    power                  = data.intersight_search_search_item.power
    resource               = data.intersight_search_search_item.resource
    san_connectivity       = data.intersight_search_search_item.san_connectivity
    sd_card                = data.intersight_search_search_item.sd_card
    serial_over_lan        = data.intersight_search_search_item.serial_over_lan
    smtp                   = data.intersight_search_search_item.smtp
    snmp                   = data.intersight_search_search_item.snmp
    ssh                    = data.intersight_search_search_item.ssh
    storage                = data.intersight_search_search_item.storage
    syslog                 = data.intersight_search_search_item.syslog
    thermal                = data.intersight_search_search_item.thermal
    uuid                   = data.intersight_search_search_item.uuid
    virtual_kvm            = data.intersight_search_search_item.virtual_kvm
    virtual_media          = data.intersight_search_search_item.virtual_media
  }

  #_________________________________________________________________________________________
  #
  # Get Policy Names from Profiles and Templates
  #_________________________________________________________________________________________

  pb = { for i in local.bucket.policies : "${trimsuffix(trimsuffix(i, "_policy"), "_pool")}" => distinct(compact(concat(
    [for e in local.chassis : lookup(e, "${i}", "UNUSED") if lookup(e, "${i}", "UNUSED") != "UNUSED"],
    [for e in local.server : lookup(e, "${i}", "") if lookup(e, "${i}", "UNUSED") != "UNUSED"],
    [for e in local.template : lookup(e, "${i}", "") if lookup(e, "${i}", "UNUSED") != "UNUSED"]
  ))) }

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

  chassis = { for i in flatten([for v in lookup(local.profiles, "chassis", []) : [
    for i in v.targets : merge(local.lchassis, v, i, {
      name         = "${local.name_prefix.chassis}${i.name}${local.name_suffix.chassis}"
      organization = var.organization
      policy_bucket = [
        for e in local.bucket.chassis : {
          name        = lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = var.organization
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED"
      ]
      tags = lookup(v, "tags", var.tags)
    })
  ]]) : i.name => i }

  chassis_serial_numbers = compact([for v in local.chassis : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])

  #_________________________________________________________________________________________
  #
  # Server Profile Templates
  #_________________________________________________________________________________________
  template = { for i in flatten([for v in lookup(local.templates, "server", []) : merge(
    local.defaults.policy_bucket, local.ltemplate, v, {
      key          = v.name
      name         = "${local.name_prefix.template}${v.name}${local.name_suffix.template}"
      organization = var.organization
      policy_bucket = [
        for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]) : {
          name        = lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = var.organization
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED"
      ]
      tags = lookup(v, "tags", var.tags)
    }
  )]) : i.key => i }

  #_________________________________________________________________________________________
  #
  # Server Profiles
  #_________________________________________________________________________________________

  servers = { for i in flatten([for v in lookup(local.profiles, "server", []) : [
    for i in v.targets : merge(local.defaults.policy_bucket, local.lserver, v, i, {
      name         = "${local.name_prefix.server}${i.name}${local.name_suffix.server}"
      organization = var.organization
      policy_bucket = [
        for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]) : {
          name        = lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED"
      ]
      pre_assign = merge(local.lserver.pre_assign, lookup(i, "pre_assign", {}), {
        domain_name = lookup(v, "domain_name", "") }
      )
      reservations = [for e in lookup(v, "reservations", []) : merge(local.lserver.reservations, e)]
      tags         = lookup(v, "tags", var.tags)
    })
  ]]) : i.name => i }

  server = { for v in local.servers : v.name => merge(v, {
    policy_bucket = length(compact([v.ucs_server_template])
    ) > 0 ? concat(v.policy_bucket, local.template[v.ucs_server_template].policy_bucket) : v.policy_bucket
    target_platform = v.create_from_template == true && length(compact([v.ucs_server_template])
    ) > 0 ? local.template[v.ucs_server_template].target_platform : v.target_platform
    uuid_pool = length(compact([v.ucs_server_template])) > 0 ? local.template[v.ucs_server_template].uuid_pool : v.uuid_pool
  }) }

  server_serial_numbers = compact([for v in local.server : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])
}