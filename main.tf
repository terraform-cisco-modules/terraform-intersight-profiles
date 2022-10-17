locals {
  defaults   = lookup(var.model, "defaults", {})
  intersight = lookup(var.model, "intersight", {})
  moids      = local.defaults.intersight.moids
  orgs       = local.moids == true ? var.pools.orgs : {}
  organizations = local.moids == false ? distinct(compact(concat(
    [for i in lookup(local.profiles, "server", []) : lookup(i, "organization", local.defaults.intersight.organization)],
    [for i in lookup(local.templates, "server", []) : lookup(i, "organization", local.defaults.intersight.organization)]
  ))) : []
  policies       = var.policies
  policies_model = lookup(local.intersight, "policies", {})
  pools          = var.pools
  profiles       = lookup(local.intersight, "profiles", {})
  templates      = lookup(local.intersight, "templates", {})
  data_policies = local.moids == false ? {
    adapter_configuration = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "adapter_configuration_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "adapter_configuration_policy", "")]
    )))
    bios = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "bios_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "bios_policy", "")]
    )))
    boot_order = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "boot_order_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "boot_order_policy", "")]
    )))
    certificate_management = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "certificate_management_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "certificate_management_policy", "")]
    )))
    device_connector = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "device_connector_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "device_connector_policy", "")]
    )))
    imc_access = distinct(compact(concat(
      [for i in lookup(local.profiles, "chassis", []) : lookup(i, "imc_access_policy", "")],
      [for i in lookup(local.profiles, "server", []) : lookup(i, "imc_access_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "imc_access_policy", "")]
    )))
    ipmi_over_lan = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "ipmi_over_lan_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "ipmi_over_lan_policy", "")]
    )))
    lan_connectivity = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "lan_connectivity_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "lan_connectivity_policy", "")]
    )))
    ldap = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "ldap_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "ldap_policy", "")]
    )))
    local_user = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "local_user_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "local_user_policy", "")]
    )))
    network_connectivity = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "network_connectivity_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "network_connectivity_policy", "")]
    )))
    ntp = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "ntp_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "ntp_policy", "")]
    )))
    persistent_memory = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "persistent_memory_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "persistent_memory_policy", "")]
    )))
    power = distinct(compact(concat(
      [for i in lookup(local.profiles, "chassis", []) : lookup(i, "power_policy", "")],
      [for i in lookup(local.profiles, "server", []) : lookup(i, "power_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "power_policy", "")]
    )))
    san_connectivity = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "san_connectivity_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "san_connectivity_policy", "")]
    )))
    sd_card = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "sd_card_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "sd_card_policy", "")]
    )))
    serial_over_lan = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "serial_over_lan_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "serial_over_lan_policy", "")]
    )))
    smtp = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "smtp_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "smtp_policy", "")]
    )))
    snmp = distinct(compact(concat(
      [for i in lookup(local.profiles, "chassis", []) : lookup(i, "snmp_policy", "")],
      [for i in lookup(local.profiles, "server", []) : lookup(i, "snmp_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "snmp_policy", "")]
    )))
    ssh = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "ssh_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "ssh_policy", "")]
    )))
    storage = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "storage_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "storage_policy", "")]
    )))
    syslog = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "syslog_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "syslog_policy", "")]
    )))
    thermal = distinct(compact(
      [for i in lookup(local.profiles, "chassis", []) : lookup(i, "thermal_policy", "")]
    ))
    virtual_kvm = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "virtual_kvm_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "virtual_kvm_policy", "")]
    )))
    virtual_media = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "virtual_media_policy", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "virtual_media_policy", "")]
    )))
  } : {}
  data_pools = local.moids == false ? {
    resource = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "resource_pool", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "resource_pool", "")]
    )))
    uuid = distinct(compact(concat(
      [for i in lookup(local.profiles, "server", []) : lookup(i, "uuid_pool", "")],
      [for i in lookup(local.templates, "server", []) : lookup(i, "uuid_pool", "")]
    )))
  } : {}
  chassis_loop = flatten([
    for v in lookup(local.profiles, "chassis", []) : [
      for i in range(length(v.names_serials)) : {
        action      = lookup(v, "action", local.defaults.intersight.profiles.chassis.action)
        description = lookup(v, "description", "")
        imc_access  = lookup(v, "imc_access_policy", "")
        imc_access_policy = length(compact([lookup(v, "imc_access_policy", "")])) > 0 ? {
          name        = v.imc_access_policy
          object_type = "access.Policy"
          policy      = "imc_access"
        } : null
        moids = true
        name  = "${element(element(v.names_serials, i), 0)}${local.defaults.intersight.profiles.chassis.name_suffix}"
        organization = lookup(v, "moids", local.defaults.intersight.moids) == true ? local.orgs[
          lookup(v, "organization", local.defaults.intersight.organization
            )] : data.intersight_organization_organization.org_moid[lookup(
            v, "organization", local.defaults.intersight.organization
        )].results[0].moid
        power = lookup(v, "power_policy", "")
        power_policy = length(compact([lookup(v, "power_policy", "")])) > 0 ? {
          name        = v.power_policy
          object_type = "power.Policy"
          policy      = "power"
        } : null
        serial_number = length(element(v.names_serials, i)
        ) == 2 ? element(element(v.names_serials, i), 1) : ""
        snmp = lookup(v, "snmp_policy", "")
        snmp_policy = length(compact([lookup(v, "snmp_policy", "")])) > 0 ? {
          name        = v.snmp_policy
          object_type = "snmp.Policy"
          policy      = "snmp"
        } : null
        thermal = lookup(v, "thermal_policy", "")
        thermal_policy = length(compact([lookup(v, "thermal_policy", "")])) > 0 ? {
          name        = v.thermal_policy
          object_type = "thermal.Policy"
          policy      = "thermal"
        } : null
        tags = lookup(v, "tags", local.defaults.intersight.tags)
        target_platform = lookup(
          v, "target_platform", local.defaults.intersight.profiles.chassis.target_platform
        )
        wait_for_completion = lookup(
          v, "wait_for_completion", local.defaults.intersight.profiles.chassis.wait_for_completion
        )
      }
    ]
  ])
  chassis = [
    for v in local.chassis_loop : {
      action       = v.action
      description  = v.description
      imc_access   = v.imc_access
      moids        = v.moids
      name         = v.name
      organization = v.organization
      policy_bucket = [
        for i in flatten(
          [
            v.imc_access_policy,
            v.power_policy,
            v.snmp_policy,
            v.thermal_policy
          ]
        ) : i if i != null
      ]
      power               = v.power
      serial_number       = v.serial_number
      snmp                = v.snmp
      tags                = v.tags
      target_platform     = v.target_platform
      thermal             = v.thermal
      wait_for_completion = v.wait_for_completion
    }
  ]

  stemplates = {
    for v in lookup(local.templates, "server", []) : v.name => {
      adapter_configuration_policy  = lookup(v, "adapter_configuration_policy", "")
      bios_policy                   = lookup(v, "bios_policy", "")
      boot_order_policy             = lookup(v, "boot_order_policy", "")
      certificate_management_policy = lookup(v, "certificate_management_policy", "")
      device_connector_policy       = lookup(v, "device_connector_policy", "")
      imc_access_policy             = lookup(v, "imc_access_policy", "")
      ipmi_over_lan_policy          = lookup(v, "ipmi_over_lan_policy", "")
      lan_connectivity_policy       = lookup(v, "lan_connectivity_policy", "")
      ldap_policy                   = lookup(v, "ldap_policy", "")
      local_user_policy             = lookup(v, "local_user_policy", "")
      network_connectivity_policy   = lookup(v, "network_connectivity_policy", "")
      ntp_policy                    = lookup(v, "ntp_policy", "")
      persistent_memory_policy      = lookup(v, "persistent_memory_policy", "")
      power_policy                  = lookup(v, "power_policy", "")
      san_connectivity_policy       = lookup(v, "san_connectivity_policy", "")
      sd_card_policy                = lookup(v, "sd_card_policy", "")
      serial_over_lan_policy        = lookup(v, "serial_over_lan_policy", "")
      smtp_policy                   = lookup(v, "smtp_policy", "")
      snmp_policy                   = lookup(v, "snmp_policy", "")
      ssh_policy                    = lookup(v, "ssh_policy", "")
      storage_policy                = lookup(v, "storage_policy", "")
      syslog_policy                 = lookup(v, "syslog_policy", "")
      uuid_pool                     = lookup(v, "uuid_pool", "")
      virtual_kvm_policy            = lookup(v, "virtual_kvm_policy", "")
      virtual_media_policy          = lookup(v, "virtual_media_policy", "")
    }
  }

  server_merge_template = flatten([
    for v in lookup(local.profiles, "server", []) : [
      for i in range(length(v.names_serials)) : {
        action = lookup(v, "action", local.defaults.intersight.profiles.server.action)
        adapter_configuration_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "adapter_configuration_policy", local.stemplates[v.ucs_server_profile_template
        ].adapter_configuration_policy) : lookup(v, "adapter_configuration_policy", "")
        bios_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "bios_policy", local.stemplates[v.ucs_server_profile_template
        ].bios_policy) : lookup(v, "bios_policy", "")
        boot_order_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "boot_order_policy", local.stemplates[v.ucs_server_profile_template
        ].boot_order_policy) : lookup(v, "boot_order_policy", "")
        certificate_management_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "certificate_management_policy", local.stemplates[v.ucs_server_profile_template
        ].certificate_management_policy) : lookup(v, "certificate_management_policy", "")
        description = lookup(v, "description", "")
        device_connector_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "device_connector_policy", local.stemplates[v.ucs_server_profile_template
        ].device_connector_policy) : lookup(v, "device_connector_policy", "")
        imc_access_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "imc_access_policy", local.stemplates[v.ucs_server_profile_template
        ].imc_access_policy) : lookup(v, "imc_access_policy", "")
        ipmi_over_lan_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "ipmi_over_lan_policy", local.stemplates[v.ucs_server_profile_template
        ].ipmi_over_lan_policy) : lookup(v, "ipmi_over_lan_policy", "")
        lan_connectivity_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "lan_connectivity_policy", local.stemplates[v.ucs_server_profile_template
        ].lan_connectivity_policy) : lookup(v, "lan_connectivity_policy", "")
        ldap_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "ldap_policy", local.stemplates[v.ucs_server_profile_template
        ].ldap_policy) : lookup(v, "ldap_policy", "")
        local_user_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "local_user_policy", local.stemplates[v.ucs_server_profile_template
        ].local_user_policy) : lookup(v, "local_user_policy", "")
        moids = true
        name  = "${element(element(v.names_serials, i), 0)}${local.defaults.intersight.profiles.server.name_suffix}"
        network_connectivity_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "network_connectivity_policy", local.stemplates[v.ucs_server_profile_template
        ].network_connectivity_policy) : lookup(v, "network_connectivity_policy", "")
        ntp_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "ntp_policy", local.stemplates[v.ucs_server_profile_template
        ].ntp_policy) : lookup(v, "ntp_policy", "")
        organization = lookup(v, "moids", local.defaults.intersight.moids) == true ? local.orgs[lookup(
          v, "organization", local.defaults.intersight.organization
          )] : lookup(
          v, "organization", local.defaults.intersight.organization
        )
        persistent_memory_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "persistent_memory_policy", local.stemplates[v.ucs_server_profile_template
        ].persistent_memory_policy) : lookup(v, "persistent_memory_policy", "")
        power_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "power_policy", local.stemplates[v.ucs_server_profile_template
        ].power_policy) : lookup(v, "power_policy", "")
        resource_pool = lookup(v, "resource_pool", "")
        san_connectivity_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "san_connectivity_policy", local.stemplates[v.ucs_server_profile_template
        ].san_connectivity_policy) : lookup(v, "san_connectivity_policy", "")
        sd_card_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "sd_card_policy", local.stemplates[v.ucs_server_profile_template
        ].sd_card_policy) : lookup(v, "sd_card_policy", "")
        serial_number = length(element(v.names_serials, i)
        ) == 2 ? element(element(v.names_serials, i), 1) : ""
        serial_over_lan_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "serial_over_lan_policy", local.stemplates[v.ucs_server_profile_template
        ].serial_over_lan_policy) : lookup(v, "serial_over_lan_policy", "")
        smtp_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "smtp_policy", local.stemplates[v.ucs_server_profile_template
        ].smtp_policy) : lookup(v, "smtp_policy", "")
        snmp_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "snmp_policy", local.stemplates[v.ucs_server_profile_template
        ].snmp_policy) : lookup(v, "snmp_policy", "")
        ssh_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "ssh_policy", local.stemplates[v.ucs_server_profile_template
        ].ssh_policy) : lookup(v, "ssh_policy", "")
        static_uuid_address = lookup(v, "static_uuid_address", "")
        storage_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "storage_policy", local.stemplates[v.ucs_server_profile_template
        ].storage_policy) : lookup(v, "storage_policy", "")
        syslog_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "syslog_policy", local.stemplates[v.ucs_server_profile_template
        ].syslog_policy) : lookup(v, "syslog_policy", "")
        tags = lookup(v, "tags", local.defaults.intersight.tags)
        target_platform = lookup(
          v, "target_platform", local.defaults.intersight.profiles.server.target_platform
        )
        ucs_server_profile_template = lookup(v, "ucs_server_profile_template", "")
        uuid_pool = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "uuid_pool", local.stemplates[v.ucs_server_profile_template
        ].uuid_pool) : lookup(v, "uuid_pool", "")
        virtual_kvm_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "virtual_kvm_policy", local.stemplates[v.ucs_server_profile_template
        ].virtual_kvm_policy) : lookup(v, "virtual_kvm_policy", "")
        virtual_media_policy = length(compact([v.ucs_server_profile_template])) > 0 ? lookup(
          v, "virtual_media_policy", local.stemplates[v.ucs_server_profile_template
        ].virtual_media_policy) : lookup(v, "virtual_media_policy", "")
        wait_for_completion = lookup(
          v, "wait_for_completion", local.defaults.intersight.profiles.server.wait_for_completion
        )
      }
    ]
  ])

  server_policies = [
    for v in local.server_merge_template : {
      action                = v.action
      adapter_configuration = lookup(v, "adapter_configuration_policy", "")
      adapter_configuration_policy = length(compact([v.adapter_configuration_policy])) > 0 ? {
        name        = v.adapter_configuration_policy
        object_type = "adapter.ConfigPolicy"
        policy      = "adapter_configuration"
      } : null
      bios = lookup(v, "bios_policy", "")
      bios_policy = length(compact([v.bios_policy])) > 0 ? {
        name        = v.bios_policy
        object_type = "bios.Policy"
        policy      = "bios"
      } : null
      boot_order = lookup(v, "boot_order_policy", "")
      boot_order_policy = length(compact([v.boot_order_policy])) > 0 ? {
        name        = v.boot_order_policy
        object_type = "boot.PrecisionPolicy"
        policy      = "boot_order"
      } : null
      certificate_management = lookup(v, "certificate_management_policy", "")
      certificate_management_policy = length(compact([v.certificate_management_policy])) > 0 ? {
        name        = v.certificate_management_policy
        object_type = "certificatemanagement.Policy"
        policy      = "certificate_management"
      } : null
      description      = v.description
      device_connector = lookup(v, "device_connector_policy", "")
      device_connector_policy = length(compact([v.device_connector_policy])) > 0 ? {
        name        = v.device_connector_policy
        object_type = "deviceconnector.Policy"
        policy      = "device_connector"
      } : null
      imc_access = lookup(v, "imc_access_policy", "")
      imc_access_policy = length(compact([v.imc_access_policy])) > 0 ? {
        name        = v.imc_access_policy
        object_type = "access.Policy"
        policy      = "imc_access"
      } : null
      ipmi_over_lan = lookup(v, "ipmi_over_lan_policy", "")
      ipmi_over_lan_policy = length(compact([v.ipmi_over_lan_policy])) > 0 ? {
        name        = v.ipmi_over_lan_policy
        object_type = "ipmioverlan.Policy"
        policy      = "ipmi_over_lan"
      } : null
      lan_connectivity = lookup(v, "lan_connectivity_policy", "")
      lan_connectivity_policy = length(compact([v.lan_connectivity_policy])) > 0 ? {
        name        = v.lan_connectivity_policy
        object_type = "vnic.LanConnectivityPolicy"
        policy      = "lan_connectivity"
      } : null
      ldap = lookup(v, "ldap_policy", "")
      ldap_policy = length(compact([v.ldap_policy])) > 0 ? {
        name        = v.ldap_policy
        object_type = "iam.LdapPolicy"
        policy      = "ldap"
      } : null
      local_user = lookup(v, "local_user_policy", "")
      local_user_policy = length(compact([v.local_user_policy])) > 0 ? {
        name        = v.local_user_policy
        object_type = "iam.EndPointUserPolicy"
        policy      = "local_user"
      } : null
      moids                = v.moids
      name                 = v.name
      network_connectivity = lookup(v, "network_connectivity_policy", "")
      network_connectivity_policy = length(compact([v.network_connectivity_policy])) > 0 ? {
        name        = v.network_connectivity_policy
        object_type = "networkconfig.Policy"
        policy      = "network_connectivity"
      } : null
      ntp = lookup(v, "ntp_policy", "")
      ntp_policy = length(compact([v.ntp_policy])) > 0 ? {
        name        = v.ntp_policy
        object_type = "ntp.Policy"
        policy      = "ntp"
      } : null
      organization      = v.organization
      persistent_memory = lookup(v, "persistent_memory_policy", "")
      persistent_memory_policy = length(compact([v.persistent_memory_policy])) > 0 ? {
        name        = v.persistent_memory_policy
        object_type = "memory.PersistentMemoryPolicy"
        policy      = "persistent_memory"
      } : null
      power = lookup(v, "power_policy", "")
      power_policy = length(compact([v.power_policy])) > 0 ? {
        name        = v.power_policy
        object_type = "power.Policy"
        policy      = "power"
      } : null
      resource_pool    = v.resource_pool
      san_connectivity = lookup(v, "san_connectivity_policy", "")
      san_connectivity_policy = length(compact([v.san_connectivity_policy])) > 0 ? {
        name        = v.san_connectivity_policy
        object_type = "vnic.SanConnectivityPolicy"
        policy      = "san_connectivity"
      } : null
      sd_card = lookup(v, "sd_card_policy", "")
      sd_card_policy = length(compact([v.sd_card_policy])) > 0 ? {
        name        = v.sd_card_policy
        object_type = "sdcard.Policy"
        policy      = "sd_card"
      } : null
      serial_number   = v.serial_number
      serial_over_lan = lookup(v, "serial_over_lan_policy", "")
      serial_over_lan_policy = length(compact([v.serial_over_lan_policy])) > 0 ? {
        name        = v.serial_over_lan_policy
        object_type = "sol.Policy"
        policy      = "serial_over_lan"
      } : null
      smtp = lookup(v, "smtp_policy", "")
      smtp_policy = length(compact([v.smtp_policy])) > 0 ? {
        name        = v.smtp_policy
        object_type = "smtp.Policy"
        policy      = "smtp"
      } : null
      snmp = lookup(v, "snmp_policy", "")
      snmp_policy = length(compact([v.snmp_policy])) > 0 ? {
        name        = v.snmp_policy
        object_type = "snmp.Policy"
        policy      = "snmp"
      } : null
      ssh = lookup(v, "ssh_policy", "")
      ssh_policy = length(compact([v.ssh_policy])) > 0 ? {
        name        = v.ssh_policy
        object_type = "ssh.Policy"
        policy      = "ssh"
      } : null
      static_uuid_address = ""
      storage             = lookup(v, "storage_policy", "")
      storage_policy = length(compact([v.storage_policy])) > 0 ? {
        name        = v.storage_policy
        object_type = "storage.StoragePolicy"
        policy      = "storage"
      } : null
      syslog = lookup(v, "syslog_policy", "")
      syslog_policy = length(compact([v.syslog_policy])) > 0 ? {
        name        = v.syslog_policy
        object_type = "syslog.Policy"
        policy      = "syslog"
      } : null
      tags                        = v.tags
      target_platform             = v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool                   = v.uuid_pool
      virtual_kvm                 = lookup(v, "virtual_kvm_policy", "")
      virtual_kvm_policy = length(compact([v.virtual_kvm_policy])) > 0 ? {
        name        = v.virtual_kvm_policy
        object_type = "kvm.Policy"
        policy      = "virtual_kvm"
      } : null
      virtual_media = lookup(v, "virtual_media_policy", "")
      virtual_media_policy = length(compact([v.virtual_media_policy])) > 0 ? {
        name        = v.virtual_media_policy
        object_type = "vmedia.Policy"
        policy      = "virtual_media"
      } : null
      wait_for_completion = v.wait_for_completion
    }
  ]
  server = [
    for v in local.server_policies : {
      action                 = v.action
      adapter_configuration  = v.adapter_configuration
      bios                   = v.bios
      boot_order             = v.boot_order
      certificate_management = v.certificate_management
      description            = v.description
      device_connector       = v.device_connector
      imc_access             = v.imc_access
      ipmi_over_lan          = v.ipmi_over_lan
      lan_connectivity       = v.lan_connectivity
      ldap                   = v.ldap
      local_user             = v.local_user
      moids                  = v.moids
      name                   = v.name
      network_connectivity   = v.network_connectivity
      ntp                    = v.ntp
      organization           = v.organization
      persistent_memory      = v.persistent_memory
      policy_bucket = [
        for i in flatten(
          [
            v.adapter_configuration_policy,
            v.bios_policy,
            v.boot_order_policy,
            v.certificate_management_policy,
            v.device_connector_policy,
            v.imc_access_policy,
            v.ipmi_over_lan_policy,
            v.lan_connectivity_policy,
            v.ldap_policy,
            v.local_user_policy,
            v.network_connectivity_policy,
            v.ntp_policy,
            v.persistent_memory_policy,
            v.power_policy,
            v.san_connectivity_policy,
            v.sd_card_policy,
            v.serial_over_lan_policy,
            v.smtp_policy,
            v.snmp_policy,
            v.ssh_policy,
            v.storage_policy,
            v.syslog_policy,
            v.virtual_kvm_policy,
            v.virtual_media_policy
          ]
        ) : i if i != null
      ]
      power                       = v.power
      resource_pool               = v.resource_pool
      san_connectivity            = v.san_connectivity
      sd_card                     = v.sd_card
      serial_over_lan             = v.serial_over_lan
      serial_number               = v.serial_number
      smtp                        = v.smtp
      snmp                        = v.snmp
      ssh                         = v.ssh
      static_uuid_address         = v.static_uuid_address
      storage                     = v.storage
      syslog                      = v.syslog
      tags                        = v.tags
      target_platform             = v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool                   = v.uuid_pool
      virtual_kvm                 = v.virtual_kvm
      virtual_media               = v.virtual_media
      wait_for_completion         = v.wait_for_completion
    }
  ]
}

#___________________________________________________________________________
#
# Intersight UCS Chassis Profile
# GUI Location: Profiles > UCS Chassis Profile > Create UCS Chassis Profile
#___________________________________________________________________________

module "chassis" {
  source  = "terraform-cisco-modules/profiles-chassis/intersight"
  version = ">= 1.0.7"

  for_each     = { for v in local.chassis : v.name => v }
  action       = each.value.action
  description  = each.value.description
  moids        = each.value.moids
  name         = each.value.name
  organization = data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid
  policies = local.moids == true ? local.policies : {
    imc_access = length(compact([each.value.imc_access_policy])) > 0 ? {
      for s in [each.value.imc_access_policy] : s => [
        for i in data.intersight_access_policy.imc_access[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    snmp = length(compact([each.value.snmp_policy])) > 0 ? {
      for s in [each.value.snmp_policy] : s => [
        for i in data.intersight_snmp_policy.snmp[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    syslog = length(compact([each.value.syslog_policy])) > 0 ? {
      for s in [each.value.syslog_policy] : s => [
        for i in data.intersight_syslog_policy.syslog[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    thermal = length(compact([each.value.thermal_policy])) > 0 ? {
      for s in [each.value.thermal_policy] : s => [
        for i in data.intersight_thermal_policy.thermal[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
  }
  policy_bucket       = each.value.policy_bucket
  serial_number       = each.value.serial_number
  tags                = each.value.tags
  target_platform     = each.value.target_platform
  wait_for_completion = each.value.wait_for_completion
}


#___________________________________________________________________________
#
# Intersight UCS Server Profile
# GUI Location: Profiles > UCS Server Profile > Create UCS Server Profile
#___________________________________________________________________________

module "server" {
  source  = "terraform-cisco-modules/profiles-server/intersight"
  version = ">= 1.0.8"

  for_each     = { for v in local.server : v.name => v }
  action       = each.value.action
  description  = each.value.description
  moids        = true
  name         = each.value.name
  organization = data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid
  policies = local.moids == true ? local.policies : {
    adapter_configuration = length(compact([each.value.adapter_configuration])) > 0 ? {
      for s in [each.value.adapter_configuration] : s => [
        for i in data.intersight_adapter_config_policy.adapter_configuration[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    bios = length(compact([each.value.bios])) > 0 ? {
      for s in [each.value.bios] : s => [
        for i in data.intersight_bios_policy.bios[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    boot_order = length(compact([each.value.boot_order])) > 0 ? {
      for s in [each.value.boot_order] : s => [
        for i in data.intersight_boot_precision_policy.boot_order[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    certificate_management = length(compact([each.value.certificate_management])) > 0 ? {
      for s in [each.value.certificate_management] : s => [
        for i in data.intersight_certificatemanagement_policy.certificate_management[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    device_connector = length(compact([each.value.device_connector])) > 0 ? {
      for s in [each.value.device_connector] : s => [
        for i in data.intersight_deviceconnector_policy.device_connector[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    imc_access = length(compact([each.value.imc_access])) > 0 ? {
      for s in [each.value.imc_access] : s => [
        for i in data.intersight_access_policy.imc_access[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    ipmi_over_lan = length(compact([each.value.ipmi_over_lan])) > 0 ? {
      for s in [each.value.ipmi_over_lan] : s => [
        for i in data.intersight_ipmioverlan_policy.ipmi_over_lan[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    lan_connectivity = length(compact([each.value.lan_connectivity])) > 0 ? {
      for s in [each.value.lan_connectivity] : s => [
        for i in data.intersight_vnic_lan_connectivity_policy.lan_connectivity[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    ldap = length(compact([each.value.ldap])) > 0 ? {
      for s in [each.value.ldap] : s => [
        for i in data.intersight_iam_ldap_policy.ldap[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    local_user = length(compact([each.value.local_user])) > 0 ? {
      for s in [each.value.local_user] : s => [
        for i in data.intersight_iam_end_point_user_policy.local_user[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    network_connectivity = length(compact([each.value.network_connectivity])) > 0 ? {
      for s in [each.value.network_connectivity] : s => [
        for i in data.intersight_networkconfig_policy.network_connectivity[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    ntp = length(compact([each.value.ntp])) > 0 ? {
      for s in [each.value.ntp] : s => [
        for i in data.intersight_ntp_policy.ntp[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    persistent_memory = length(compact([each.value.persistent_memory])) > 0 ? {
      for s in [each.value.persistent_memory] : s => [
        for i in data.intersight_memory_persistent_memory_policy.persistent_memory[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    power = length(compact([each.value.power])) > 0 ? {
      for s in [each.value.power] : s => [
        for i in data.intersight_power_policy.power[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    san_connectivity = length(compact([each.value.san_connectivity])) > 0 ? {
      for s in [each.value.san_connectivity] : s => [
        for i in data.intersight_vnic_san_connectivity_policy.san_connectivity[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    sd_card = length(compact([each.value.sd_card])) > 0 ? {
      for s in [each.value.sd_card] : s => [
        for i in data.intersight_sdcard_policy.sd_card[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    serial_over_lan = length(compact([each.value.serial_over_lan])) > 0 ? {
      for s in [each.value.serial_over_lan] : s => [
        for i in data.intersight_sol_policy.serial_over_lan[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    smtp = length(compact([each.value.smtp])) > 0 ? {
      for s in [each.value.smtp] : s => [
        for i in data.intersight_smtp_policy.smtp[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    snmp = length(compact([each.value.snmp])) > 0 ? {
      for s in [each.value.snmp] : s => [
        for i in data.intersight_snmp_policy.snmp[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    ssh = length(compact([each.value.ssh])) > 0 ? {
      for s in [each.value.ssh] : s => [
        for i in data.intersight_ssh_policy.ssh[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    storage = length(compact([each.value.storage])) > 0 ? {
      for s in [each.value.storage] : s => [
        for i in data.intersight_storage_storage_policy.storage[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    syslog = length(compact([each.value.syslog])) > 0 ? {
      for s in [each.value.syslog] : s => [
        for i in data.intersight_syslog_policy.syslog[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    virtual_kvm = length(compact([each.value.virtual_kvm])) > 0 ? {
      for s in [each.value.virtual_kvm] : s => [
        for i in data.intersight_kvm_policy.virtual_kvm[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    virtual_media = length(compact([each.value.virtual_media])) > 0 ? {
      for s in [each.value.virtual_media] : s => [
        for i in data.intersight_vmedia_policy.virtual_media[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
  }
  policy_bucket = each.value.policy_bucket
  pools = local.moids == true ? local.pools : {
    resource = length(compact([each.value.resource_pool])) > 0 ? {
      for s in [each.value.resource_pool] : s => [
        for i in data.intersight_resourcepool_pool.resource[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
    uuid = length(compact([each.value.uuid_pool])) > 0 ? {
      for s in [each.value.uuid_pool] : s => [
        for i in data.intersight_uuidpool_pool.uuid[s
        ].results : i.moid if i.organization[0]
      .moid == data.intersight_organization_organization.org_moid[each.value.organization].results[0].moid][0]
    } : {}
  }
  resource_pool       = each.value.resource_pool
  serial_number       = each.value.serial_number
  static_uuid_address = each.value.static_uuid_address
  tags                = each.value.tags
  target_platform     = each.value.target_platform
  #server_template     = each.value.ucs_server_profile_template
  uuid_pool           = each.value.uuid_pool
  wait_for_completion = each.value.wait_for_completion
}
