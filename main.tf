locals {
  defaults       = lookup(var.model, "defaults", {})
  intersight     = lookup(var.model, "intersight", {})
  orgs           = local.defaults.intersight.moids == true ? var.pools.orgs : {}
  policies       = var.policies
  policies_model = lookup(local.intersight, "policies", {})
  pools          = var.pools
  profiles       = lookup(local.intersight, "profiles", {})
  templates      = lookup(local.intersight, "templates", {})
  chassis_loop = flatten([
    for v in lookup(local.profiles, "chassis", []) : [
      for i in range(length(v.names_serials)) : {
        action      = lookup(v, "action", local.defaults.intersight.profiles.chassis.action)
        description = lookup(v, "description", "")
        imc_access_policy = length(compact([lookup(v, "imc_access_policy", "")])) > 0 ? {
          name        = v.imc_access_policy
          object_type = "access.Policy"
          policy      = "imc_access"
        } : null
        moids = lookup(v, "moids", local.defaults.intersight.moids)
        name  = "${element(element(v.names_serials, i), 0)}${local.defaults.intersight.profiles.chassis.name_suffix}"
        organization = lookup(v, "moids", local.defaults.intersight.moids) == true ? local.orgs[
          lookup(v, "organization", local.defaults.intersight.organization
          )] : lookup(v, "organization", local.defaults.intersight.organization
        )
        power_policy = length(compact([lookup(v, "power_policy", "")])) > 0 ? {
          name        = v.power_policy
          object_type = "power.Policy"
          policy      = "power"
        } : null
        serial_number = length(element(v.names_serials, i)
        ) == 2 ? element(element(v.names_serials, i), 1) : ""
        snmp_policy = length(compact([lookup(v, "snmp_policy", "")])) > 0 ? {
          name        = v.snmp_policy
          object_type = "snmp.Policy"
          policy      = "snmp"
        } : null
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
      serial_number       = v.serial_number
      tags                = v.tags
      target_platform     = v.target_platform
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
        moids = lookup(v, "moids", local.defaults.intersight.moids)
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
      action = v.action
      adapter_configuration_policy = length(compact([v.adapter_configuration_policy])) > 0 ? {
        name        = v.adapter_configuration_policy
        object_type = "adapter.ConfigPolicy"
        policy      = "adapter_configuration"
      } : null
      bios_policy = length(compact([v.bios_policy])) > 0 ? {
        name        = v.bios_policy
        object_type = "bios.Policy"
        policy      = "bios"
      } : null
      boot_order_policy = length(compact([v.boot_order_policy])) > 0 ? {
        name        = v.boot_order_policy
        object_type = "boot.PrecisionPolicy"
        policy      = "boot_order"
      } : null
      certificate_management_policy = length(compact([v.certificate_management_policy])) > 0 ? {
        name        = v.certificate_management_policy
        object_type = "certificatemanagement.Policy"
        policy      = "certificate_management"
      } : null
      description = v.description
      device_connector_policy = length(compact([v.device_connector_policy])) > 0 ? {
        name        = v.device_connector_policy
        object_type = "deviceconnector.Policy"
        policy      = "device_connector"
      } : null
      imc_access_policy = length(compact([v.imc_access_policy])) > 0 ? {
        name        = v.imc_access_policy
        object_type = "access.Policy"
        policy      = "imc_access"
      } : null
      ipmi_over_lan_policy = length(compact([v.ipmi_over_lan_policy])) > 0 ? {
        name        = v.ipmi_over_lan_policy
        object_type = "ipmioverlan.Policy"
        policy      = "ipmi_over_lan"
      } : null
      lan_connectivity_policy = length(compact([v.lan_connectivity_policy])) > 0 ? {
        name        = v.lan_connectivity_policy
        object_type = "vnic.LanConnectivityPolicy"
        policy      = "lan_connectivity"
      } : null
      ldap_policy = length(compact([v.ldap_policy])) > 0 ? {
        name        = v.ldap_policy
        object_type = "iam.LdapPolicy"
        policy      = "ldap"
      } : null
      local_user_policy = length(compact([v.local_user_policy])) > 0 ? {
        name        = v.local_user_policy
        object_type = "iam.EndPointUserPolicy"
        policy      = "local_user"
      } : null
      moids = v.moids
      name  = v.name
      network_connectivity_policy = length(compact([v.network_connectivity_policy])) > 0 ? {
        name        = v.network_connectivity_policy
        object_type = "networkconfig.Policy"
        policy      = "network_connectivity"
      } : null
      ntp_policy = length(compact([v.ntp_policy])) > 0 ? {
        name        = v.ntp_policy
        object_type = "ntp.Policy"
        policy      = "ntp"
      } : null
      organization = v.organization
      persistent_memory_policy = length(compact([v.persistent_memory_policy])) > 0 ? {
        name        = v.persistent_memory_policy
        object_type = "memory.PersistentMemoryPolicy"
        policy      = "persistent_memory"
      } : null
      power_policy = length(compact([v.power_policy])) > 0 ? {
        name        = v.power_policy
        object_type = "power.Policy"
        policy      = "power"
      } : null
      resource_pool = v.resource_pool
      san_connectivity_policy = length(compact([v.san_connectivity_policy])) > 0 ? {
        name        = v.san_connectivity_policy
        object_type = "vnic.SanConnectivityPolicy"
        policy      = "san_connectivity"
      } : null
      sd_card_policy = length(compact([v.sd_card_policy])) > 0 ? {
        name        = v.sd_card_policy
        object_type = "sdcard.Policy"
        policy      = "sd_card"
      } : null
      serial_number = v.serial_number
      serial_over_lan_policy = length(compact([v.serial_over_lan_policy])) > 0 ? {
        name        = v.serial_over_lan_policy
        object_type = "sol.Policy"
        policy      = "serial_over_lan"
      } : null
      smtp_policy = length(compact([v.smtp_policy])) > 0 ? {
        name        = v.smtp_policy
        object_type = "smtp.Policy"
        policy      = "smtp"
      } : null
      snmp_policy = length(compact([v.snmp_policy])) > 0 ? {
        name        = v.snmp_policy
        object_type = "snmp.Policy"
        policy      = "snmp"
      } : null
      ssh_policy = length(compact([v.ssh_policy])) > 0 ? {
        name        = v.ssh_policy
        object_type = "ssh.Policy"
        policy      = "ssh"
      } : null
      static_uuid_address = ""
      storage_policy = length(compact([v.storage_policy])) > 0 ? {
        name        = v.storage_policy
        object_type = "storage.StoragePolicy"
        policy      = "storage"
      } : null
      syslog_policy = length(compact([v.syslog_policy])) > 0 ? {
        name        = v.syslog_policy
        object_type = "syslog.Policy"
        policy      = "syslog"
      } : null
      tags                        = v.tags
      target_platform             = v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool                   = v.uuid_pool
      virtual_kvm_policy = length(compact([v.virtual_kvm_policy])) > 0 ? {
        name        = v.virtual_kvm_policy
        object_type = "kvm.Policy"
        policy      = "virtual_kvm"
      } : null
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
      action       = v.action
      description  = v.description
      moids        = v.moids
      name         = v.name
      organization = v.organization
      policy_bucket = [
        for i in flatten(
          [
            v.adapter_configuration_policy,
            v.bios_policy,
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
      resource_pool               = v.resource_pool
      serial_number               = v.serial_number
      static_uuid_address         = v.static_uuid_address
      tags                        = v.tags
      target_platform             = v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool                   = v.uuid_pool
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

  for_each            = { for v in local.chassis : v.name => v }
  action              = each.value.action
  description         = each.value.description
  moids               = each.value.moids
  name                = each.value.name
  organization        = each.value.organization
  policies            = local.policies
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
  version = ">= 1.0.7"

  for_each            = { for v in local.server : v.name => v }
  action              = each.value.action
  description         = each.value.description
  moids               = each.value.moids
  name                = each.value.name
  organization        = each.value.organization
  policies            = local.policies
  policy_bucket       = each.value.policy_bucket
  pools               = local.pools
  resource_pool       = each.value.resource_pool
  serial_number       = each.value.serial_number
  static_uuid_address = each.value.static_uuid_address
  tags                = each.value.tags
  target_platform     = each.value.target_platform
  #server_template     = each.value.ucs_server_profile_template
  uuid_pool           = each.value.uuid_pool
  wait_for_completion = each.value.wait_for_completion
}
