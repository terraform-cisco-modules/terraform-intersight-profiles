locals {
  defaults     = yamldecode(file("${path.module}/defaults.yaml"))
  modelp       = { for org in local.org_keys : org => lookup(var.model[org], "profiles", {}) }
  modelt       = { for org in local.org_keys : org => lookup(var.model[org], "templates", {}) }
  org_keys     = sort(keys(var.model))
  org_names    = merge({ for k, v in var.orgs : v => k }, { x_cisco_intersight_internal = "5ddfd9ff6972652d31ee6582" })
  policy_names = [for e in keys(local.bucket) : replace(e, "_policy", "") if length(regexall("_policy", e)) > 0]
  policies = merge(lookup(var.policies, "map", {}), {
    npfx = { for org in keys(var.orgs) : org => {
      for e in local.policy_names : e => lookup(lookup(lookup(lookup(var.model, org, {}), "policies", {}), "name_prefix", {}
      ), e, lookup(lookup(lookup(lookup(var.model, org, {}), "policies", {}), "name_prefix", local.defaults.policy_prefix), "default", ""))
    } }
    nsfx = { for org in keys(var.orgs) : org => {
      for e in local.policy_names : e => lookup(lookup(lookup(lookup(var.model, org, {}), "policies", {}), "name_suffix", {}
      ), e, lookup(lookup(lookup(lookup(var.model, org, {}), "policies", {}), "name_suffix", local.defaults.policy_suffix), "default", ""))
    } }
  })
  pools = merge(lookup(var.pools, "map", {}), {
    npfx = { for org in keys(var.orgs) : org => {
      for e in ["resource", "uuid"] : e => lookup(lookup(lookup(lookup(var.model, org, {}), "pools", {}), "name_prefix", {}
      ), e, lookup(lookup(lookup(lookup(var.model, org, {}), "pools", {}), "name_prefix", local.defaults.pool_suffix), "default", ""))
    } }
    nsfx = { for org in keys(var.orgs) : org => {
      for e in ["resource", "uuid"] : e => lookup(lookup(lookup(lookup(var.model, org, {}), "pools", {}), "name_suffix", {}
      ), e, lookup(lookup(lookup(lookup(var.model, org, {}), "pools", {}), "name_suffix", local.defaults.pool_suffix), "default", ""))
    } }
  })
  ppfx = { for org in local.org_keys : org => {
    for e in local.profile_names : e => lookup(lookup(local.modelp[org], "name_prefix", {}
    ), e, lookup(lookup(local.modelp[org], "name_prefix", local.defaults.profiles.name_prefix), "default", ""))
  } }
  psfx = { for org in local.org_keys : org => {
    for e in local.profile_names : e => lookup(lookup(local.modelp[org], "name_suffix", {}
    ), e, lookup(lookup(local.modelp[org], "name_suffix", local.defaults.profiles.name_suffix), "default", ""))
  } }
  profile_chassis  = local.defaults.profiles.chassis
  profile_domain   = local.defaults.profiles.domain
  profile_names    = ["chassis", "domain", "server"]
  profile_server   = local.defaults.profiles.server
  template_chassis = local.defaults.templates.chassis
  template_domain  = local.defaults.templates.domain
  template_server  = local.defaults.templates.server
  tpfx = { for org in local.org_keys : org => {
    for e in local.profile_names : e => lookup(lookup(local.modelt[org], "name_prefix", {}
    ), e, lookup(lookup(local.modelt[org], "name_prefix", local.defaults.profiles.name_prefix), "default", ""))
  } }
  tsfx = { for org in local.org_keys : org => {
    for e in local.profile_names : e => lookup(lookup(local.modelt[org], "name_suffix", {}
    ), e, lookup(lookup(local.modelt[org], "name_suffix", local.defaults.profiles.name_suffix), "default", ""))
  } }

  #_________________________________________________________________________________________
  #
  # Get Policy Names from Profiles and Templates
  #_________________________________________________________________________________________

  pba = merge({ for i in local.bucket.domain_policies : trimsuffix(i, "_policy") => setsubtract(distinct(compact(concat(
    [for e in local.switch_profiles : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]],
    [for e in local.switch_templates : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]]
    ))), ["UNUSED"]) },
    { for i in local.bucket.domain_dual_policies : trimsuffix(i, "_policies") => setsubtract(distinct(compact(concat(
      flatten([for e in local.switch_profiles : [
        for d in range(length(lookup(e, i, []))) : [d != "UNUSED" ? length(regexall("/", e[i][d])) > 0 ? e[i][d
        ] : "${e.org}/${e[i][d]}" : "UNUSED"][0]
      ]]),
      flatten([for e in local.switch_templates : [
        for d in range(length(lookup(e, i, []))) : [d != "UNUSED" ? length(regexall("/", e[i][d])) > 0 ? e[i][d
        ] : "${e.org}/${e[i][d]}" : "UNUSED"][0]
      ]])
    ))), ["UNUSED"]) },
    { for i in local.bucket.policies : trimsuffix(trimsuffix(i, "_policy"), "_pool") => setsubtract(distinct(compact(concat(
      [for e in local.chassis : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]],
      [for e in local.chassis_template : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]],
      [for e in local.server : [
        length(regexall("UNUSED|^[0-9a-f]{24}$", lookup(e, i, "UNUSED"))) == 0 ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]
      ],
      [for e in local.server_template : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]]
    ))), ["UNUSED"]) },
  )
  pbb = { for i in local.bucket.domain_duplicate_policies : trimsuffix(i, "_policy") => setsubtract(distinct(compact(concat(
    [for e in local.switch_profiles : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]],
    [for e in local.switch_templates : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])
    ) > 0 ? e[i] : "${e.org}/${e[i]}" : "UNUSED"][0]]
  ))), ["UNUSED"]) }
  policy_types = distinct(concat([for e in keys(local.pba) : e if length(regexall("resource|uuid", e)) == 0], [for e in keys(local.pbb) : e]))
  pool_types   = ["resource", "uuid"]
  data_policies = { for e in local.policy_types : e => setsubtract(distinct(concat(flatten([contains(keys(local.pba), e) == true ? [
    for v in local.pba[e] : element(split("/", v), 1) if contains(keys(lookup(local.policies, e, {})), v) == false] : []]), flatten([
    contains(keys(local.pbb), e) == true ? [for v in local.pbb[e] : element(split("/", v), 1) if contains(keys(lookup(local.policies, e, {})), v) == false
  ] : []]))), ["UNUSED"]) }
  data_pools = { for e in local.pool_types : e => [for v in local.pba[e] : element(split("/", v), 1
  ) if contains(keys(lookup(local.pools, e, {})), v) == false] }
  data_templates = { for e in local.template_types : e => distinct([for k, v in local.profiles[element(split("_", e), 1)] : element(split("/", v[e]), 1
  ) if contains(keys(local.templates[element(split("_", e), 1)]), v[e]) == false && length(regexall("UNUSED", element(split("/", v[e]), 1))) == 0]) }
  template_types = ["ucs_chassis_profile_template", "ucs_domain_profile_template", "ucs_server_profile_template", "ucs_switch_profile_template"]
  profiles       = { chassis = local.chassis, domain = local.domain, server = local.server, switch = local.switch_profiles }
  templates      = { chassis = local.chassis_template, domain = local.domain_template, server = local.server_template, switch = local.switch_templates }
  policies_data = { for k in keys(data.intersight_search_search_item.policies) : k => {
    for e in lookup(data.intersight_search_search_item.policies[k], "results", []
      ) : "${local.org_names[jsondecode(e.additional_properties).Organization.Moid]}/${jsondecode(e.additional_properties).Name}" => merge({
        additional_properties = jsondecode(e.additional_properties)
        moid                  = e.moid
    })
  } }
  pools_data = { for k in ["resource", "uuid"] : k => merge({
    for e in lookup(lookup(data.intersight_search_search_item.pools, k, {}), "results", []
      ) : "${local.org_names[jsondecode(e.additional_properties).Organization.Moid]}/${jsondecode(e.additional_properties).Name}" => merge({
        additional_properties = jsondecode(e.additional_properties)
        moid                  = e.moid
    })
  }, { for e in keys(lookup(local.pools, k, {})) : e => { moid = local.pools[k][e] } }) }
  ucs_templates = {
    chassis = merge(
      { for k, v in intersight_chassis_profile_template.map : k => v },
      { for i in flatten([for k, v in data.intersight_chassis_profile_template.map : [for e in v.results : merge(e, {
        org = e.organization[0].moid
    })]]) : "${local.org_names[i.org]}/${i.name}" => i })
    domain = merge(
      { for k, v in intersight_fabric_switch_cluster_profile_template.map : k => v },
      { for i in flatten([for k, v in data.intersight_fabric_switch_cluster_profile_template.map : [for e in v.results : merge(e, {
        org = e.organization[0].moid
    })]]) : "${local.org_names[i.org]}/${i.name}" => i })
    server = merge(
      { for k, v in intersight_server_profile_template.map : k => v },
      { for i in flatten([for k, v in data.intersight_server_profile_template.map : [for e in v.results : merge(e, {
        org = e.organization[0].moid
    })]]) : "${local.org_names[i.org]}/${i.name}" => i })
    switch = merge(
      { for k, v in intersight_fabric_switch_profile_template.map : k => v },
      { for i in flatten([for k, v in data.intersight_fabric_switch_profile_template.map : [for e in v.results : merge(e, {
        org = e.organization[0].moid
    })]]) : "${local.org_names[i.org]}/${i.name}" => i })
  }

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
      "certificate_management_policy", "ldap_policy", "network_connectivity_policy", "ntp_policy", "snmp_policy", "syslog_policy",
    ]
    domain_policies = [
      "certificate_management_policy", "ldap_policy", "network_connectivity_policy", "ntp_policy", "snmp_policy",
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
    memory_policy               = { object_type = "memory.Policy", policy = "memory", }
    network_connectivity_policy = { object_type = "networkconfig.Policy", policy = "network_connectivity", }
    ntp_policy                  = { object_type = "ntp.Policy", policy = "ntp", }
    persistent_memory_policy    = { object_type = "memory.PersistentMemoryPolicy", policy = "persistent_memory", }
    policies = [
      "adapter_configuration_policy", "bios_policy", "boot_order_policy", "certificate_management_policy",
      "device_connector_policy", "drive_security_policy", "firmware_policy", "imc_access_policy",
      "ipmi_over_lan_policy", "lan_connectivity_policy", "ldap_policy", "local_user_policy", "memory_policy",
      "network_connectivity_policy", "ntp_policy", "persistent_memory_policy", "power_policy", "resource_pool",
      "san_connectivity_policy", "scrub_policy", "sd_card_policy", "serial_over_lan_policy", "smtp_policy", "snmp_policy",
      "ssh_policy", "storage_policy", "syslog_policy", "thermal_policy", "uuid_pool", "virtual_kvm_policy", "virtual_media_policy",
    ]
    port_policies                = { object_type = "fabric.PortPolicy", policy = "port", }
    port_policy                  = { object_type = "fabric.PortPolicy", policy = "port", }
    power_policy                 = { object_type = "power.Policy", policy = "power", }
    resource_pool                = { object_type = "resourcepool.Pool", policy = "resource", }
    san_connectivity_policy      = { object_type = "vnic.SanConnectivityPolicy", policy = "san_connectivity", }
    scrub_policy                 = { object_type = "compute.ScrubPolicy", policy = "scrub", }
    sd_card_policy               = { object_type = "sdcard.Policy", policy = "sd_card", }
    serial_over_lan_policy       = { object_type = "sol.Policy", policy = "serial_over_lan", }
    smtp_policy                  = { object_type = "smtp.Policy", policy = "smtp", }
    snmp_policy                  = { object_type = "snmp.Policy", policy = "snmp", }
    ssh_policy                   = { object_type = "ssh.Policy", policy = "ssh", }
    Standalone                   = ["imc_access_poicy", "power_policy", "resource_pool", "uuid_pool"]
    storage_policy               = { object_type = "storage.StoragePolicy", policy = "storage", }
    switch_control_policy        = { object_type = "fabric.SwitchControlPolicy", policy = "switch_control", }
    syslog_policy                = { object_type = "syslog.Policy", policy = "syslog", }
    system_qos_policy            = { object_type = "fabric.SystemQosPolicy", policy = "system_qos", }
    thermal_policy               = { object_type = "thermal.Policy", policy = "thermal", }
    uuid_pool                    = { object_type = "uuidpool.Pool", policy = "uuid", }
    virtual_kvm_policy           = { object_type = "kvm.Policy", policy = "virtual_kvm", }
    virtual_media_policy         = { object_type = "vmedia.Policy", policy = "virtual_media", }
    vlan_policies                = { object_type = "fabric.EthNetworkPolicy", policy = "vlan", }
    vlan_policy                  = { object_type = "fabric.EthNetworkPolicy", policy = "vlan", }
    vsan_policies                = { object_type = "fabric.FcNetworkPolicy", policy = "vsan", }
    vsan_policy                  = { object_type = "fabric.FcNetworkPolicy", policy = "vsan", }
    ucs_chassis_profile_template = { object_type = "chassis.ProfileTemplate", template = "chassis" }
    ucs_domain_profile_template  = { object_type = "fabric.SwitchClusterProfileTemplate", template = "domain" }
    ucs_server_profile_template  = { object_type = "server.ProfileTemplate", template = "server" }
    ucs_switch_profile_template  = { object_type = "fabric.SwitchProfileTemplate", template = "switch" }
  }

  #_________________________________________________________________________________________
  #
  # Domain Profile Templates
  #_________________________________________________________________________________________
  domain_template = { for i in flatten([for org in local.org_keys : [
    for v in lookup(local.modelt[org], "domain", []) : merge(
      local.defaults.policy_bucket_domain, local.template_domain, v, {
        key  = v.name
        name = "${local.tpfx[org].domain}${v.name}${local.tsfx[org].domain}"
        org  = org
        tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(local.modelt[org], "domain", [])) > 0]) : "${i.org}/${i.key}" => i }
  switch_templates_loop_1 = { for i in flatten([
    for k, v in local.domain_template : [
      for x in [0, 1] : merge(v, {
        domain_template = k
        name            = x == 0 ? "${v.name}-A" : "${v.name}-B"
        org             = v.org
        policy_bucket = merge({
          for e in local.bucket.domain_policies : replace(local.bucket[e].object_type, ".", "") => {
            name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
            object_type = local.bucket[e].object_type
            org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : v.org
            policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
          }, {
          for e in local.bucket.domain_dual_policies : local.bucket[e].policy => {
            name = length(lookup(v, e, [])) >= 2 ? [length(regexall("/", v[e][x])) > 0 ? element(split("/", v[e][x]), 1) : v[e][x]][0] : length(lookup(v, e, [])
            ) == 1 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 1) : v[e][0]][0] : "UNUSED"
            object_type = local.bucket[e].object_type
            org = length(lookup(v, e, [])) >= 2 ? [length(regexall("/", v[e][x])) > 0 ? element(split("/", v[e][x]), 0) : v.org][0] : length(lookup(v, e, [])
            ) == 1 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 0) : v.org][0] : "UNUSED"
            policy = local.bucket[e].policy
          }
        })
        switch_id = x == 0 ? "A" : "B"
        tags      = lookup(v, "tags", var.global_settings.tags)
      })
  ]]) : "${i.org}/${i.name}" => i }
  switch_templates = { for k, v in local.switch_templates_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }

  #_________________________________________________________________________________________
  #
  # Domain Profiles
  #_________________________________________________________________________________________
  domain = { for d in flatten([for org in local.org_keys : [
    for v in lookup(local.modelp[org], "domain", []) : merge(local.profile_domain, v, {
      name = "${local.ppfx[org].domain}${v.name}${local.psfx[org].domain}"
      org  = org
      tags = lookup(v, "tags", var.global_settings.tags)
      ucs_domain_profile_template = length(regexall("/", lookup(v, "ucs_domain_profile_template", "UNUSED"))
      ) > 0 ? v.ucs_domain_profile_template : length(compact([lookup(v, "ucs_domain_profile_template", "")])) > 0 ? "${org}/${v.ucs_domain_profile_template}" : "${org}/UNUSED"
    })
  ] if length(lookup(local.modelp[org], "domain", [])) > 0]) : "${d.org}/${d.name}" => d }
  switch_profiles_loop_1 = { for i in flatten([
    for k, v in local.domain : [
      for x in [0, 1] : merge(v, {
        domain_profile = k
        name           = x == 0 ? "${v.name}-A" : "${v.name}-B"
        org            = v.org
        policy_bucket = merge({
          for e in local.bucket.domain_policies : replace(local.bucket[e].object_type, ".", "") => {
            name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
            object_type = local.bucket[e].object_type
            org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : v.org
            policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
          }, {
          for e in local.bucket.domain_dual_policies : local.bucket[e].policy => {
            name = length(lookup(v, e, [])) >= 2 ? [length(regexall("/", v[e][x])) > 0 ? element(split("/", v[e][x]), 1) : v[e][x]][0] : length(lookup(v, e, [])
            ) == 1 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 1) : v[e][0]][0] : "UNUSED"
            object_type = local.bucket[e].object_type
            org = length(lookup(v, e, [])) >= 2 ? [length(regexall("/", v[e][x])) > 0 ? element(split("/", v[e][x]), 0) : v.org][0] : length(lookup(v, e, [])
            ) == 1 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 0) : v.org][0] : "UNUSED"
            policy = local.bucket[e].policy
          }
        })
        serial_number = length(lookup(v, "serial_numbers", [])) == 2 ? element(v.serial_numbers, x) : length(lookup(v, "serial_numbers", [])
        ) == 1 ? element(v.serial_numbers, 0) : "unknown"
        switch_id                   = x == 0 ? "A" : "B"
        ucs_domain_profile_template = v.ucs_domain_profile_template
        ucs_switch_profile_template = x == 0 ? "${v.ucs_domain_profile_template}-A" : "${v.ucs_domain_profile_template}-B"
      })
    ]
  ]) : "${i.org}/${i.name}" => i }
  switch_profiles_loop_2 = { for k, v in local.switch_profiles_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }
  switch_profiles = { for k, v in local.switch_profiles_loop_2 : k => merge(v, {
    policy_bucket = length(compact([v.ucs_switch_profile_template])) > 0 && length(lookup(local.switch_templates, v.ucs_domain_profile_template, {})) > 0 ? merge(
    local.switch_templates[v.ucs_switch_profile_template].policy_bucket, v.policy_bucket) : v.policy_bucket
  }) }
  domain_serial_numbers = compact(flatten([for v in local.switch_profiles : v.serial_number if length(regexall(
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0]))
  wait_for_domain = distinct(compact([for i in local.switch_profiles : i.action if i.action != "No-op"]))

  #_________________________________________________________________________________________
  #
  # Chassis Profile Templates
  #_________________________________________________________________________________________
  chassis_template_loop_1 = { for i in flatten([for org in local.org_keys : [
    for v in lookup(local.modelt[org], "chassis", []) : merge(
      local.defaults.policy_bucket_chassis, local.template_chassis, v, {
        name = "${local.tpfx[org].chassis}${v.name}${local.tsfx[org].chassis}"
        org  = org
        policy_bucket = { for e in local.bucket.chassis : replace(local.bucket[e].object_type, ".", "") => {
          name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED" }
        tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(local.modelt[org], "chassis", [])) > 0]) : "${i.org}/${i.name}" => i }
  chassis_template = { for k, v in local.chassis_template_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }

  #_________________________________________________________________________________________
  #
  # Chassis Profiles
  #_________________________________________________________________________________________
  chassis_loop_1 = { for d in flatten([for org in local.org_keys : [for v in lookup(local.modelp[org], "chassis", []) : [
    for i in v.targets : merge(local.defaults.policy_bucket_chassis, local.profile_chassis, v, i, {
      name = "${local.ppfx[org].server}${i.name}${local.psfx[org].server}"
      org  = org
      policy_bucket = { for e in local.bucket.chassis : replace(local.bucket[e].object_type, ".", "") => {
        name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
        object_type = local.bucket[e].object_type
        org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
        policy      = local.bucket[e].policy
      } if lookup(v, e, "UNUSED") != "UNUSED" }
      tags = lookup(v, "tags", var.global_settings.tags)
      ucs_chassis_profile_template = length(regexall("/", lookup(v, "ucs_chassis_profile_template", "UNUSED"))
      ) > 0 ? v.ucs_chassis_profile_template : length(compact([lookup(v, "ucs_chassis_profile_template", "")])) > 0 ? "${org}/${v.ucs_chassis_profile_template}" : "UNUSED"
    })
  ]] if length(lookup(local.modelp[org], "chassis", [])) > 0]) : "${d.org}/${d.name}" => d }
  chassis_loop_2 = { for k, v in local.chassis_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }
  chassis = { for k, v in local.chassis_loop_2 : k => merge(v, {
    policy_bucket = length(compact([v.ucs_chassis_profile_template])) > 0 && length(lookup(local.chassis_template, v.ucs_chassis_profile_template, {})) > 0 ? merge(
    local.chassis_template[v.ucs_chassis_profile_template].policy_bucket, v.policy_bucket) : v.policy_bucket
  }) }
  chassis_serial_numbers = compact([for v in local.chassis : v.serial_number if length(regexall(
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])

  #_________________________________________________________________________________________
  #
  # Server Profile Templates
  #_________________________________________________________________________________________
  server_template_loop_1 = { for i in flatten([for org in local.org_keys : [
    for v in lookup(local.modelt[org], "server", []) : merge(
      local.defaults.policy_bucket_server, local.template_server, v, {
        name = "${local.tpfx[org].server}${v.name}${local.tsfx[org].server}"
        org  = org
        policy_bucket = { for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]) : replace(
          local.bucket[e].object_type, ".", "") => {
          name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
          object_type = local.bucket[e].object_type
          org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
          policy      = local.bucket[e].policy
        } if lookup(v, e, "UNUSED") != "UNUSED" }
        tags = lookup(v, "tags", var.global_settings.tags)
        uuid_address_type = length(regexall("UNUSED", lookup(v, "uuid_pool", "UNUSED"))
        ) == 0 && length(compact([lookup(v, "uuid_pool", "")])) > 0 ? "POOL" : "NONE"
    })
  ] if length(lookup(local.modelt[org], "server", [])) > 0]) : "${i.org}/${i.name}" => i }
  server_template = { for k, v in local.server_template_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 && length(regexall("resource|uuid", b.policy)
        ) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : length(regexall("^UNUSED$", b.name)
      ) == 0 ? "${b.org}/${local.pools.npfx[b.org][b.policy]}${b.name}${local.pools.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }

  #_________________________________________________________________________________________
  #
  # Server Profiles
  #_________________________________________________________________________________________
  server_loop_1 = { for d in flatten([for org in local.org_keys : [for v in lookup(local.modelp[org], "server", []) : [
    for i in v.targets : merge(local.defaults.policy_bucket_server, local.profile_server, v, i, {
      key  = i.name
      name = "${local.ppfx[org].server}${i.name}${local.psfx[org].server}"
      org  = org
      policy_bucket = { for e in setsubtract(local.bucket.policies, local.bucket[v.target_platform]
        ) : replace(local.bucket[e].object_type, ".", "") => {
        name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
        object_type = local.bucket[e].object_type
        org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : org
        object_type = local.bucket[e].object_type
        policy      = local.bucket[e].policy
      } if lookup(v, e, "UNUSED") != "UNUSED" }
      pre_assign = merge(local.profile_server.pre_assign, lookup(i, "pre_assign", {}), { domain_name = lookup(v, "domain_name", "") })
      reservations = lookup(v, "ignore_reservations", false
        ) == false ? [for e in lookup(i, "reservations", []) : merge(local.profile_server.reservations, e, {
          pool_name = length(regexall("/", e.pool_name)) > 0 ? e.pool_name : "${org}/${e.pool_name}"
      })] : []
      tags = lookup(v, "tags", var.global_settings.tags)
      ucs_server_profile_template = length(compact([lookup(v, "ucs_server_template", "")])) > 0 ? length(regexall("/", lookup(v, "ucs_server_template", "UNUSED"))
        ) > 0 ? v.ucs_server_template : length(compact([lookup(v, "ucs_server_template", "")])) > 0 ? "${org}/${v.ucs_server_template}" : "UNUSED" : length(
        regexall("/", lookup(v, "ucs_server_profile_template", "UNUSED"))
        ) > 0 ? v.ucs_server_profile_template : length(compact([lookup(v, "ucs_server_profile_template", "")])
      ) > 0 ? "${org}/${v.ucs_server_profile_template}" : "${org}/UNUSED"
    })
  ]] if length(lookup(local.modelp[org], "server", [])) > 0]) : "${d.org}/${d.key}" => d }
  server_loop_2 = { for k, v in local.server_loop_1 : k => merge(v, {
    policy_bucket = { for a, b in v.policy_bucket : a => merge(b, {
      name = length(regexall("^UNUSED$", b.name)) == 0 && length(regexall("resource|uuid", b.policy)
        ) == 0 ? "${b.org}/${local.policies.npfx[b.org][b.policy]}${b.name}${local.policies.nsfx[b.org][b.policy]}" : length(regexall("^UNUSED$", b.name)
      ) == 0 ? "${b.org}/${local.pools.npfx[b.org][b.policy]}${b.name}${local.pools.nsfx[b.org][b.policy]}" : b.name
    }) }
  }) }
  server = { for k, v in local.server_loop_2 : k => merge(v, {
    policy_bucket = length(regexall("UNUSED", v.ucs_server_profile_template)) == 0 && contains(keys(local.server_template), v.ucs_server_profile_template) ? merge(
    local.server_template[v.ucs_server_profile_template].policy_bucket, v.policy_bucket) : v.policy_bucket
    resource_pool = length(regexall("/", v.resource_pool)
    ) > 0 ? "${local.pools.npfx[v.org].resource}${v.resource_pool}${local.pools.nsfx[v.org].resource}" : "${v.org}/${local.pools.npfx[v.org].resource}${v.resource_pool}${local.pools.nsfx[v.org].resource}"
    target_platform = v.attach_template == true && length(lookup(local.server_template, v.ucs_server_profile_template, "")
    ) > 0 ? local.server_template[v.ucs_server_profile_template].target_platform : v.target_platform
  }) }
  udefault = { name = "default/UNUSED", object_type = "uuidpool.Pool", org = "default", policy = "uuid" }
  server_final = { for k, v in local.server : k => merge(v, {
    uuid_address_type = length(compact([v.static_uuid_address])) > 0 ? "STATIC" : v.attach_template == true && length(regexall("UNUSED", v.ucs_server_profile_template)
      ) == 0 ? local.ucs_templates.server[v.ucs_server_profile_template].uuid_address_type : length(regexall("UNUSED", lookup(
      v.policy_bucket, "uuidpoolPool", local.udefault).name)
    ) == 0 ? "POOL" : "NONE"
    uuid_pool = v.attach_template == true && length(regexall("UNUSED", v.ucs_server_profile_template)
    ) == 0 ? local.ucs_templates.server[v.ucs_server_profile_template].uuid_pool[0].moid : lookup(v.policy_bucket, "uuidpoolPool", local.udefault).name
  }) }
  server_serial_numbers = compact([for v in local.server : v.serial_number if length(regexall(
  "^[A-Z]{3}[1-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0])
}