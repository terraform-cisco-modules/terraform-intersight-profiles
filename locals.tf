locals {
  defaults  = yamldecode(file("${path.module}/defaults.yaml"))
  lchassis  = local.defaults.profiles.chassis
  ldomain   = local.defaults.profiles.domain
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
  org_moids     = { for k, v in var.orgs : v => k }
  policies      = lookup(var.policies, "map", {})
  pools         = lookup(var.pools, "map", {})
  profile_names = ["chassis", "domain", "server", "template"]

  #_________________________________________________________________________________________
  #
  # Get Policy Names from Profiles and Templates
  #_________________________________________________________________________________________

  pba = merge({ for i in local.bucket.domain_policies : trimsuffix(i, "_policy") => setsubtract(distinct(compact(
    [for e in local.switch_profiles : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]]
    )), ["UNUSED"]) },
    { for i in local.bucket.domain_dual_policies : trimsuffix(i, "_policies") => setsubtract(distinct(compact(
      flatten([for e in local.switch_profiles : [
        for d in range(length(lookup(e, i, []))) : [d != "UNUSED" ? length(regexall("/", e[i][d])) > 0 ? e[i][d
        ] : "${e.organization}/${e[i][d]}" : "UNUSED"][0]
      ]])
    )), ["UNUSED"]) },
    { for i in local.bucket.policies : trimsuffix(trimsuffix(i, "_policy"), "_pool") => setsubtract(distinct(compact(concat(
      [for e in local.chassis : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]],
      [for e in local.server : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]],
      [for e in local.template : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]]
    ))), ["UNUSED"]) },
  )
  pbb = { for i in local.bucket.domain_duplicate_policies : trimsuffix(i, "_policy") => setsubtract(distinct(compact(
    [for e in local.switch_profiles : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]]
  )), ["UNUSED"]) }
  policy_types = distinct(concat([for e in keys(local.pba) : e if length(regexall("resource|uuid", e)) == 0], [for e in keys(local.pbb) : e]))
  data_policies = { for e in local.policy_types : e => distinct(concat(flatten([contains(keys(local.pba), e) == true ? [
    for v in local.pba[e] : element(split("/", v), 1) if contains(keys(lookup(local.policies, e, {})), v) == false] : []]), flatten([
    contains(keys(local.pbb), e) == true ? [for v in local.pbb[e] : element(split("/", v), 1) if contains(keys(lookup(local.policies, e, {})), v) == false
  ] : []]))) }
  data_pools = { for e in ["resource", "uuid"] : e => [for v in local.pba[e] : element(split("/", v), 1
  ) if contains(keys(lookup(local.pools, e, {})), v) == false] }
  data_templates = { for e in ["ucs_server_template"] : e => distinct([for k, v in local.server : element(split("/", v[e]), 1) if contains(
  keys(local.template), v[e]) == false]) }

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
    domain_dual_policies          = ["port_policies", "vlan_policies", "vsan_policies"]
    domain_duplicate_policies = [
      "network_connectivity_policy", "ntp_policy", "snmp_policy", "syslog_policy",
    ]
    domain_policies = [
      "network_connectivity_policy", "ntp_policy", "snmp_policy",
      "switch_control_policy", "syslog_policy", "system_qos_policy",
    ]
    drive_security_policy = { object_type = "storage.DriveSecurityPolicy", policy = "drive_security", }
    FIAttached = [
      "device_connector_policy", "ldap_policy", "network_connectivity_policy", "ntp_policy", "persistent_memory_policy"
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
    port_policies           = { object_type = "fabric.PortPolicy", policy = "port", }
    port_policy             = { object_type = "fabric.PortPolicy", policy = "port", }
    power_policy            = { object_type = "power.Policy", policy = "power", }
    resource_pool           = { object_type = "resourcepool.Pool", policy = "resource", }
    san_connectivity_policy = { object_type = "vnic.SanConnectivityPolicy", policy = "san_connectivity", }
    sd_card_policy          = { object_type = "sdcard.Policy", policy = "sd_card", }
    serial_over_lan_policy  = { object_type = "sol.Policy", policy = "serial_over_lan", }
    smtp_policy             = { object_type = "smtp.Policy", policy = "smtp", }
    snmp_policy             = { object_type = "snmp.Policy", policy = "snmp", }
    ssh_policy              = { object_type = "ssh.Policy", policy = "ssh", }
    Standalone              = ["imc_access_poicy", "power_policy", "resource_pool", "uuid_pool"]
    storage_policy          = { object_type = "storage.StoragePolicy", policy = "storage", }
    switch_control_policy   = { object_type = "fabric.SwitchControlPolicy", policy = "switch_control", }
    syslog_policy           = { object_type = "syslog.Policy", policy = "syslog", }
    system_qos_policy       = { object_type = "fabric.SystemQosPolicy", policy = "system_qos", }
    thermal_policy          = { object_type = "thermal.Policy", policy = "thermal", }
    uuid_pool               = { object_type = "uuidpool.Pool", policy = "uuid", }
    virtual_kvm_policy      = { object_type = "kvm.Policy", policy = "virtual_kvm", }
    virtual_media_policy    = { object_type = "vmedia.Policy", policy = "virtual_media", }
    vlan_policies           = { object_type = "fabric.EthNetworkPolicy", policy = "vlan", }
    vlan_policy             = { object_type = "fabric.EthNetworkPolicy", policy = "vlan", }
    vsan_policies           = { object_type = "fabric.FcNetworkPolicy", policy = "vsan", }
    vsan_policy             = { object_type = "fabric.FcNetworkPolicy", policy = "vsan", }
  }

  #_________________________________________________________________________________________
  #
  # Domain Profiles
  #_________________________________________________________________________________________
  domain = { for d in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "profiles", {}), "domain", []) : merge(local.ldomain, v, {
      key          = v.name
      name         = "${local.name_prefix[org].domain}${v.name}${local.name_suffix[org].domain}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "profiles", {}), "domain", [])) > 0]) : "${d.organization}/${d.key}" => d }
  switch_profiles = { for i in flatten([
    for k, v in local.domain : [
      for s in [0, 1] : merge(v, {
        domain_profile = k
        name           = s == 0 ? "${v.name}-A" : "${v.name}-B"
        organization   = v.organization
        policy_bucket = merge({
          for e in local.bucket.domain_policies : replace(local.bucket[e].object_type, ".", "") => {
            name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
            object_type = local.bucket[e].object_type
            org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : v.organization
            policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
          }, {
          for e in local.bucket.domain_dual_policies : local.bucket[e].policy => {
            name = length(
              lookup(v, e, [])) > 1 ? [length(regexall("/", v[e][s])) > 0 ? element(split("/", v[e][s]), 1) : v[e][s]][0] : length(
              lookup(v, e, [])) > 0 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 1) : v[e][0]][0
            ] : "UNUSED"
            object_type = local.bucket[e].object_type
            org = length(
              lookup(v, e, [])) > 1 ? [length(regexall("/", v[e][s])) > 0 ? element(split("/", v[e][s]), 0) : v.organization][0] : length(
              lookup(v, e, [])) > 0 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 0) : v.organization][0
            ] : v.organization
            policy = local.bucket[e].policy
          }
        })
        serial_number = length(lookup(v, "serial_numbers", [])) == 2 ? element(v.serial_numbers, s) : length(lookup(v, "serial_numbers", [])
        ) == 1 ? element(v.serial_numbers, 0) : "unknown"
      })
    ]
  ]) : "${i.organization}/${i.name}" => i }
  domain_serial_numbers = compact(flatten([for v in local.switch_profiles : v.serial_number if length(regexall(
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0]))
  wait_for_domain = distinct(compact([for i in local.switch_profiles : i.action if i.action != "No-op"]))

  #_________________________________________________________________________________________
  #
  # Chassis Profile
  #_________________________________________________________________________________________
  chassis = { for d in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "profiles", {}), "chassis", []) : [
      for i in v.targets : merge(local.lchassis, v, i, {
        key          = i.name
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
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])

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
      key          = i.name
      name         = "${local.name_prefix[org].server}${i.name}${local.name_suffix[org].server}"
      organization = org
      policy_bucket = { for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]
        ) : replace(local.bucket[e].object_type, ".", "") => {
        name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
        object_type = local.bucket[e].object_type
        org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
        policy      = local.bucket[e].policy
      } if lookup(v, e, "UNUSED") != "UNUSED" }
      pre_assign = merge(local.lserver.pre_assign, lookup(i, "pre_assign", {}), { domain_name = lookup(v, "domain_name", "") })
      reservations = lookup(v, "ignore_reservations", true
      ) == false ? [for e in lookup(i, "reservations", []) : merge(local.lserver.reservations, e)] : []
      tags = lookup(v, "tags", var.global_settings.tags)
      ucs_server_template = length(regexall("/", lookup(v, "ucs_server_template", "UNUSED"))
      ) > 0 ? v.ucs_server_template : length(compact([lookup(v, "ucs_server_template", "")])) > 0 ? "${org}/${v.ucs_server_template}" : "UNUSED"
    })
  ]] if length(lookup(lookup(var.model[org], "profiles", {}), "server", [])) > 0]) : "${d.organization}/${d.key}" => d }
  server = { for k, v in local.servers : k => merge(v, {
    policy_bucket = length(compact([v.ucs_server_template])) > 0 && length(lookup(local.template, v.ucs_server_template, {})) > 0 ? merge(
    local.template[v.ucs_server_template].policy_bucket, v.policy_bucket) : v.policy_bucket
    target_platform = v.attach_template == true && length(lookup(local.template, v.ucs_server_template, "")
    ) > 0 ? local.template[v.ucs_server_template].target_platform : v.target_platform
  }) }
  server_serial_numbers = compact([for v in local.server : v.serial_number if length(regexall(
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])
}