locals {
  defaults    = var.defaults
  lchassis    = local.defaults.profiles.chassis
  lserver     = local.defaults.profiles.server
  ltemplate   = local.defaults.templates.server
  model       = var.model
  name_prefix = local.defaults.profiles.name_prefix
  orgs        = var.orgs
  profiles    = lookup(lookup(local.model, "profiles", {}), var.organization, [])
  templates   = lookup(lookup(local.model, "templates", {}), var.organization, [])
  data_search = {
    adapter_configuration  = data.intersight_search_search_item.adapter_configuration
    bios                   = data.intersight_search_search_item.bios
    boot_order             = data.intersight_search_search_item.boot_order
    certificate_management = data.intersight_search_search_item.certificate_management
    device_connector       = data.intersight_search_search_item.device_connector
    imc_access             = data.intersight_search_search_item.imc_access
    ipmi_over_lan          = data.intersight_search_search_item.ipmi_over_lan
    lan_connectivity       = data.intersight_search_search_item.lan_connectivity
    ldap                   = data.intersight_search_search_item.ldap
    local_user             = data.intersight_search_search_item.local_user
    network_connectivity   = data.intersight_search_search_item.network_connectivity
    ntp                    = data.intersight_search_search_item.ntp
    persistent_memory      = data.intersight_search_search_item.persistent_memory
    power                  = data.intersight_search_search_item.power
    resource_pool          = data.intersight_search_search_item.resource_pool
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
  # Get Policy Names from Profiles and Templates
  adapter_configuration = distinct(compact(concat(
    [for i in local.server : i.adapter_configuration_policy],
    [for i in local.template : i.adapter_configuration_policy]
  )))
  bios = distinct(compact(concat(
    [for i in local.server : i.bios_policy],
    [for i in local.template : i.bios_policy]
  )))
  boot_order = distinct(compact(concat(
    [for i in local.server : i.boot_order_policy],
    [for i in local.template : i.boot_order_policy]
  )))
  certificate_management = distinct(compact(concat(
    [for i in local.server : i.certificate_management_policy],
    [for i in local.template : i.certificate_management_policy]
  )))
  device_connector = distinct(compact(concat(
    [for i in local.server : i.device_connector_policy],
    [for i in local.template : i.device_connector_policy]
  )))
  imc_access = distinct(compact(concat(
    [for i in local.chassis : i.imc_access_policy],
    [for i in local.server : i.imc_access_policy],
    [for i in local.template : i.imc_access_policy]
  )))
  ipmi_over_lan = distinct(compact(concat(
    [for i in local.server : i.ipmi_over_lan_policy],
    [for i in local.template : i.ipmi_over_lan_policy]
  )))
  lan_connectivity = distinct(compact(concat(
    [for i in local.server : i.lan_connectivity_policy],
    [for i in local.template : i.lan_connectivity_policy]
  )))
  ldap = distinct(compact(concat(
    [for i in local.server : i.ldap_policy],
    [for i in local.template : i.ldap_policy]
  )))
  local_user = distinct(compact(concat(
    [for i in local.server : i.local_user_policy],
    [for i in local.template : i.local_user_policy]
  )))
  network_connectivity = distinct(compact(concat(
    [for i in local.server : i.network_connectivity_policy],
    [for i in local.template : i.network_connectivity_policy]
  )))
  ntp = distinct(compact(concat(
    [for i in local.server : i.ntp_policy],
    [for i in local.template : i.ntp_policy]
  )))
  persistent_memory = distinct(compact(concat(
    [for i in local.server : i.persistent_memory_policy],
    [for i in local.template : i.persistent_memory_policy]
  )))
  power = distinct(compact(concat(
    [for i in local.chassis : i.imc_access_policy],
    [for i in local.server : i.imc_access_policy],
    [for i in local.template : i.imc_access_policy]
  )))
  resource_pool = distinct(compact(concat(
    [for i in local.server : i.resource_pool.name if i.resource_pool.name != "UNUSED"]
  )))
  san_connectivity = distinct(compact(concat(
    [for i in local.server : i.san_connectivity_policy],
    [for i in local.template : i.san_connectivity_policy]
  )))
  sd_card = distinct(compact(concat(
    [for i in local.server : i.sd_card_policy],
    [for i in local.template : i.sd_card_policy]
  )))
  serial_over_lan = distinct(compact(concat(
    [for i in local.server : i.serial_over_lan_policy],
    [for i in local.template : i.serial_over_lan_policy]
  )))
  smtp = distinct(compact(concat(
    [for i in local.server : i.smtp_policy],
    [for i in local.template : i.smtp_policy]
  )))
  snmp = distinct(compact(concat(
    [for i in local.chassis : i.snmp_policy],
    [for i in local.server : i.snmp_policy],
    [for i in local.template : i.snmp_policy]
  )))
  ssh = distinct(compact(concat(
    [for i in local.server : i.ssh_policy],
    [for i in local.template : i.ssh_policy]
  )))
  storage = distinct(compact(concat(
    [for i in local.server : i.storage_policy],
    [for i in local.template : i.storage_policy]
  )))
  syslog = distinct(compact(concat(
    [for i in local.server : i.syslog_policy],
    [for i in local.template : i.syslog_policy]
  )))
  thermal = distinct(compact(
    [for i in local.chassis : i.thermal_policy]
  ))
  uuid = distinct(compact(concat(
    [for i in local.server : i.uuid_pool.name if i.uuid_pool.name != "UNUSED"],
    [for i in local.template : i.uuid_pool.name if i.uuid_pool.name != "UNUSED"]
  )))
  virtual_kvm = distinct(compact(concat(
    [for i in local.server : i.virtual_kvm_policy],
    [for i in local.template : i.virtual_kvm_policy]
  )))
  virtual_media = distinct(compact(concat(
    [for i in local.server : i.virtual_media_policy],
    [for i in local.template : i.virtual_media_policy]
  )))

  #_________________________________________________________________________________________
  #
  # Chassis Profile
  #_________________________________________________________________________________________
  chassis_loop = flatten([
    for v in lookup(local.profiles, "chassis", []) : [
      for i in v.targets : {
        action      = lookup(v, "action", local.lchassis.action)
        description = lookup(i, "description", "")
        imc_access_policy = lookup(v, "imc_access_policy", "") != "" ? try(
          {
            name        = tostring(v.imc_access_policy)
            object_type = "access.Policy"
            org         = var.organization
            policy      = "imc_access"
          },
          merge(v.imc_access_policy, {
            object_type = "access.Policy"
            policy      = "imc_access"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        name         = "${local.name_prefix}${i.name}${local.lchassis.name_suffix}"
        organization = var.organization
        power_policy = lookup(v, "power_policy", "") != "" ? try(
          {
            name        = tostring(v.power_policy)
            object_type = "power.Policy"
            org         = var.organization
            policy      = "power"
          },
          merge(v.power_policy, {
            object_type = "power.Policy"
            policy      = "power"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        serial_number = i.serial_number
        snmp_policy = lookup(v, "snmp_policy", "") != "" ? try(
          {
            name        = tostring(v.snmp_policy)
            object_type = "snmp.Policy"
            org         = var.organization
            policy      = "snmp"
          },
          merge(v.snmp_policy, {
            object_type = "snmp.Policy"
            policy      = "snmp"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        thermal_policy = lookup(v, "thermal_policy", "") != "" ? try(
          {
            name        = tostring(v.thermal_policy)
            object_type = "thermal.Policy"
            org         = var.organization
            policy      = "thermal"
          },
          merge(v.thermal_policy, {
            object_type = "thermal.Policy"
            policy      = "thermal"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        tags = lookup(v, "tags", var.tags)
        target_platform = lookup(
          v, "target_platform", local.lchassis.target_platform
        )
      }
    ]
  ])
  chassis = {
    for v in local.chassis_loop : v.name => {
      action            = v.action
      description       = v.description
      imc_access_policy = length(regexall("UNUSED", v.imc_access_policy.name)) == 0 ? v.imc_access_policy.name : ""
      name              = v.name
      organization      = v.organization
      policy_bucket = [
        for i in flatten(
          [
            v.imc_access_policy,
            v.power_policy,
            v.snmp_policy,
            v.thermal_policy
          ]
        ) : i if i.name != "UNUSED"
      ]
      power_policy    = length(regexall("UNUSED", v.power_policy.name)) == 0 ? v.power_policy.name : ""
      serial_number   = v.serial_number
      snmp_policy     = length(regexall("UNUSED", v.snmp_policy.name)) == 0 ? v.snmp_policy.name : ""
      tags            = v.tags
      target_platform = v.target_platform
      thermal_policy  = length(regexall("UNUSED", v.thermal_policy.name)) == 0 ? v.thermal_policy.name : ""
    }
  }
  chassis_serial_numbers = compact([for v in local.chassis : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", v.serial_number)) > 0])

  #_________________________________________________________________________________________
  #
  # Server Template
  #_________________________________________________________________________________________
  template_loop = {
    for v in lookup(local.templates, "server", []) : v.name => {
      adapter_configuration_policy = lookup(v, "adapter_configuration_policy", "") != "" ? try(
        {
          name        = tostring(v.adapter_configuration_policy)
          object_type = "adapter.ConfigPolicy"
          org         = var.organization
          policy      = "adapter_configuration"
        },
        merge(v.adapter_configuration_policy, {
          object_type = "adapter.ConfigPolicy"
          policy      = "adapter_configuration"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      bios_policy = lookup(v, "bios_policy", "") != "" ? try(
        {
          name        = tostring(v.bios_policy)
          object_type = "bios.Policy"
          org         = var.organization
          policy      = "bios"
        },
        merge(v.bios_policy, {
          object_type = "bios.Policy"
          policy      = "bios"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      boot_order_policy = lookup(v, "boot_order_policy", "") != "" ? try(
        {
          name        = tostring(v.boot_order_policy)
          object_type = "boot.PrecisionPolicy"
          org         = var.organization
          policy      = "boot"
        },
        merge(v.boot_order_policy, {
          object_type = "boot.PrecisionPolicy"
          policy      = "boot"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      certificate_management_policy = lookup(v, "certificate_management_policy", "") != "" ? try(
        {
          name        = tostring(v.certificate_management_policy)
          object_type = "certificatemanagement.Policy"
          org         = var.organization
          policy      = "certificate_management"
        },
        merge(v.certificate_management_policy, {
          object_type = "certificatemanagement.Policy"
          policy      = "certificate_management"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      create_template = lookup(v, "create_template", local.ltemplate.create_template)
      description     = lookup(v, "description", "")
      device_connector_policy = lookup(v, "device_connector_policy", "") != "" ? try(
        {
          name        = tostring(v.device_connector_policy)
          object_type = "deviceconnector.Policy"
          org         = var.organization
          policy      = "device_connector"
        },
        merge(v.device_connector_policy, {
          object_type = "deviceconnector.Policy"
          policy      = "device_connector"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      imc_access_policy = lookup(v, "imc_access_policy", "") != "" ? try(
        {
          name        = tostring(v.imc_access_policy)
          object_type = "access.Policy"
          org         = var.organization
          policy      = "imc_access"
        },
        merge(v.imc_access_policy, {
          object_type = "access.Policy"
          policy      = "imc_access"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      ipmi_over_lan_policy = lookup(v, "ipmi_over_lan_policy", "") != "" ? try(
        {
          name        = tostring(v.ipmi_over_lan_policy)
          object_type = "ipmioverlan.Policy"
          org         = var.organization
          policy      = "ipmi_over_lan"
        },
        merge(v.ipmi_over_lan_policy, {
          object_type = "ipmioverlan.Policy"
          policy      = "ipmi_over_lan"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      lan_connectivity_policy = lookup(v, "lan_connectivity_policy", "") != "" ? try(
        {
          name        = tostring(v.lan_connectivity_policy)
          object_type = "vnic.LanConnectivityPolicy"
          org         = var.organization
          policy      = "lan_connectivity"
        },
        merge(v.lan_connectivity_policy, {
          object_type = "vnic.LanConnectivityPolicy"
          policy      = "lan_connectivity"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      ldap_policy = lookup(v, "ldap_policy", "") != "" ? try(
        {
          name        = tostring(v.ldap_policy)
          object_type = "iam.LdapPolicy"
          org         = var.organization
          policy      = "ldap"
        },
        merge(v.ldap_policy, {
          object_type = "iam.LdapPolicy"
          policy      = "ldap"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      local_user_policy = lookup(v, "local_user_policy", "") != "" ? try(
        {
          name        = tostring(v.local_user_policy)
          object_type = "iam.EndPointUserPolicy"
          org         = var.organization
          policy      = "local_user"
        },
        merge(v.local_user_policy, {
          object_type = "iam.EndPointUserPolicy"
          policy      = "local_user"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      name = "${local.name_prefix}${v.name}${local.ltemplate.name_suffix}"
      network_connectivity_policy = lookup(v, "network_connectivity_policy", "") != "" ? try(
        {
          name        = tostring(v.network_connectivity_policy)
          object_type = "networkconfig.Policy"
          org         = var.organization
          policy      = "network_connectivity"
        },
        merge(v.network_connectivity_policy, {
          object_type = "networkconfig.Policy"
          policy      = "network_connectivity"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      ntp_policy = lookup(v, "ntp_policy", "") != "" ? try(
        {
          name        = tostring(v.ntp_policy)
          object_type = "ntp.Policy"
          org         = var.organization
          policy      = "ntp"
        },
        merge(v.ntp_policy, {
          object_type = "ntp.Policy"
          policy      = "ntp"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      organization = var.organization
      persistent_memory_policy = lookup(v, "persistent_memory_policy", "") != "" ? try(
        {
          name        = tostring(v.persistent_memory_policy)
          object_type = "memory.PersistentMemoryPolicy"
          org         = var.organization
          policy      = "persistent_memory"
        },
        merge(v.persistent_memory_policy, {
          object_type = "memory.PersistentMemoryPolicy"
          policy      = "persistent_memory"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      power_policy = lookup(v, "power_policy", "") != "" ? try(
        {
          name        = tostring(v.power_policy)
          object_type = "power.Policy"
          org         = var.organization
          policy      = "power"
        },
        merge(v.power_policy, {
          object_type = "power.Policy"
          policy      = "power"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      san_connectivity_policy = lookup(v, "san_connectivity_policy", "") != "" ? try(
        {
          name        = tostring(v.san_connectivity_policy)
          object_type = "vnic.SanConnectivityPolicy"
          org         = var.organization
          policy      = "san_connectivity"
        },
        merge(v.san_connectivity_policy, {
          object_type = "vnic.SanConnectivityPolicy"
          policy      = "san_connectivity"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      sd_card_policy = lookup(v, "sd_card_policy", "") != "" ? try(
        {
          name        = tostring(v.sd_card_policy)
          object_type = "sdcard.Policy"
          org         = var.organization
          policy      = "sd_card"
        },
        merge(v.sd_card_policy, {
          object_type = "sdcard.Policy"
          policy      = "sd_card"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      serial_over_lan_policy = lookup(v, "serial_over_lan_policy", "") != "" ? try(
        {
          name        = tostring(v.serial_over_lan_policy)
          object_type = "sol.Policy"
          org         = var.organization
          policy      = "serial_over_lan"
        },
        merge(v.serial_over_lan_policy, {
          object_type = "sol.Policy"
          policy      = "serial_over_lan"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      smtp_policy = lookup(v, "smtp_policy", "") != "" ? try(
        {
          name        = tostring(v.smtp_policy)
          object_type = "smtp.Policy"
          org         = var.organization
          policy      = "smtp"
        },
        merge(v.smtp_policy, {
          object_type = "smtp.Policy"
          policy      = "smtp"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      snmp_policy = lookup(v, "snmp_policy", "") != "" ? try(
        {
          name        = tostring(v.snmp_policy)
          object_type = "snmp.Policy"
          org         = var.organization
          policy      = "snmp"
        },
        merge(v.snmp_policy, {
          object_type = "snmp.Policy"
          policy      = "snmp"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      ssh_policy = lookup(v, "ssh_policy", "") != "" ? try(
        {
          name        = tostring(v.ssh_policy)
          object_type = "ssh.Policy"
          org         = var.organization
          policy      = "ssh"
        },
        merge(v.ssh_policy, {
          object_type = "ssh.Policy"
          policy      = "ssh"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      storage_policy = lookup(v, "storage_policy", "") != "" ? try(
        {
          name        = tostring(v.storage_policy)
          object_type = "storage.StoragePolicy"
          org         = var.organization
          policy      = "storage"
        },
        merge(v.storage_policy, {
          object_type = "storage.StoragePolicy"
          policy      = "storage"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      syslog_policy = lookup(v, "syslog_policy", "") != "" ? try(
        {
          name        = tostring(v.syslog_policy)
          object_type = "syslog.Policy"
          org         = var.organization
          policy      = "syslog"
        },
        merge(v.syslog_policy, {
          object_type = "syslog.Policy"
          policy      = "syslog"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      tags = lookup(v, "tags", var.tags)
      target_platform = lookup(
        v, "target_platform", local.lchassis.target_platform
      )
      uuid_pool = lookup(v, "uuid_pool", "") != "" ? try(
        {
          name = tostring(v.uuid_pool)
          org  = var.organization
        },
        v.uuid_pool
        ) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      virtual_kvm_policy = lookup(v, "virtual_kvm_policy", "") != "" ? try(
        {
          name        = tostring(v.virtual_kvm_policy)
          object_type = "kvm.Policy"
          org         = var.organization
          policy      = "virtual_kvm"
        },
        merge(v.virtual_kvm_policy, {
          object_type = "kvm.Policy"
          policy      = "virtual_kvm"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      virtual_media_policy = lookup(v, "virtual_media_policy", "") != "" ? try(
        {
          name        = tostring(v.virtual_media_policy)
          object_type = "vmedia.Policy"
          org         = var.organization
          policy      = "virtual_media"
        },
        merge(v.virtual_media_policy, {
          object_type = "vmedia.Policy"
          policy      = "virtual_media"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
    }
  }
  template = {
    for v in local.template_loop : v.name => {
      create_template = v.create_template
      adapter_configuration_policy = length(regexall("UNUSED", v.adapter_configuration_policy.name)
      ) == 0 ? v.adapter_configuration_policy.name : ""
      bios_policy       = length(regexall("UNUSED", v.bios_policy.name)) == 0 ? v.bios_policy.name : ""
      boot_order_policy = length(regexall("UNUSED", v.boot_order_policy.name)) == 0 ? v.boot_order_policy.name : ""
      certificate_management_policy = length(regexall("UNUSED", v.certificate_management_policy.name)
      ) == 0 ? v.certificate_management_policy.name : ""
      description = v.description
      device_connector_policy = length(regexall("UNUSED", v.device_connector_policy.name)
      ) == 0 ? v.device_connector_policy.name : ""
      imc_access_policy = length(regexall("UNUSED", v.imc_access_policy.name)) == 0 ? v.imc_access_policy.name : ""
      ipmi_over_lan_policy = length(regexall("UNUSED", v.ipmi_over_lan_policy.name)
      ) == 0 ? v.ipmi_over_lan_policy.name : ""
      lan_connectivity_policy = length(regexall("UNUSED", v.lan_connectivity_policy.name)
      ) == 0 ? v.lan_connectivity_policy.name : ""
      ldap_policy       = length(regexall("UNUSED", v.ldap_policy.name)) == 0 ? v.ldap_policy.name : ""
      local_user_policy = length(regexall("UNUSED", v.local_user_policy.name)) == 0 ? v.local_user_policy.name : ""
      name              = v.name
      network_connectivity_policy = length(regexall("UNUSED", v.network_connectivity_policy.name)
      ) == 0 ? v.network_connectivity_policy.name : ""
      ntp_policy   = length(regexall("UNUSED", v.ntp_policy.name)) == 0 ? v.ntp_policy.name : ""
      organization = v.organization
      persistent_memory_policy = length(regexall("UNUSED", v.persistent_memory_policy.name)
      ) == 0 ? v.persistent_memory_policy.name : ""
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
        ) : i if i.name != "UNUSED"
      ]
      power_policy = length(regexall("UNUSED", v.power_policy.name)) == 0 ? v.power_policy.name : ""
      san_connectivity_policy = length(regexall("UNUSED", v.san_connectivity_policy.name)
      ) == 0 ? v.san_connectivity_policy.name : ""
      sd_card_policy = length(regexall("UNUSED", v.sd_card_policy.name)) == 0 ? v.sd_card_policy.name : ""
      serial_over_lan_policy = length(regexall("UNUSED", v.serial_over_lan_policy.name)
      ) == 0 ? v.serial_over_lan_policy.name : ""
      smtp_policy     = length(regexall("UNUSED", v.smtp_policy.name)) == 0 ? v.smtp_policy.name : ""
      snmp_policy     = length(regexall("UNUSED", v.snmp_policy.name)) == 0 ? v.snmp_policy.name : ""
      ssh_policy      = length(regexall("UNUSED", v.ssh_policy.name)) == 0 ? v.ssh_policy.name : ""
      storage_policy  = length(regexall("UNUSED", v.storage_policy.name)) == 0 ? v.storage_policy.name : ""
      syslog_policy   = length(regexall("UNUSED", v.syslog_policy.name)) == 0 ? v.syslog_policy.name : ""
      tags            = v.tags
      target_platform = v.target_platform
      uuid_pool       = v.uuid_pool
      virtual_kvm_policy = length(regexall("UNUSED", v.virtual_kvm_policy.name)
      ) == 0 ? v.virtual_kvm_policy.name : ""
      virtual_media_policy = length(regexall("UNUSED", v.virtual_media_policy.name)
      ) == 0 ? v.virtual_media_policy.name : ""
    }
  }


  server_loop = flatten([
    for v in lookup(local.profiles, "server", []) : [
      for i in v.targets : {
        action = lookup(v, "action", local.lserver.action)
        adapter_configuration_policy = lookup(v, "adapter_configuration_policy", "") != "" ? try(
          {
            name        = tostring(v.adapter_configuration_policy)
            object_type = "adapter.ConfigPolicy"
            org         = var.organization
            policy      = "adapter_configuration"
          },
          merge(v.adapter_configuration_policy, {
            object_type = "adapter.ConfigPolicy"
            policy      = "adapter_configuration"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        bios_policy = lookup(v, "bios_policy", "") != "" ? try(
          {
            name        = tostring(v.bios_policy)
            object_type = "bios.Policy"
            org         = var.organization
            policy      = "bios"
          },
          merge(v.bios_policy, {
            object_type = "bios.Policy"
            policy      = "bios"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        boot_order_policy = lookup(v, "boot_order_policy", "") != "" ? try(
          {
            name        = tostring(v.boot_order_policy)
            object_type = "boot.PrecisionPolicy"
            org         = var.organization
            policy      = "boot"
          },
          merge(v.boot_order_policy, {
            object_type = "boot.PrecisionPolicy"
            policy      = "boot"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        certificate_management_policy = lookup(v, "certificate_management_policy", "") != "" ? try(
          {
            name        = tostring(v.certificate_management_policy)
            object_type = "certificatemanagement.Policy"
            org         = var.organization
            policy      = "certificate_management"
          },
          merge(v.certificate_management_policy, {
            object_type = "certificatemanagement.Policy"
            policy      = "certificate_management"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        create_from_template = lookup(v, "create_from_template", local.lserver.create_from_template)
        description          = lookup(i, "description", "")
        device_connector_policy = lookup(v, "device_connector_policy", "") != "" ? try(
          {
            name        = tostring(v.device_connector_policy)
            object_type = "deviceconnector.Policy"
            org         = var.organization
            policy      = "device_connector"
          },
          merge(v.device_connector_policy, {
            object_type = "deviceconnector.Policy"
            policy      = "device_connector"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        imc_access_policy = lookup(v, "imc_access_policy", "") != "" ? try(
          {
            name        = tostring(v.imc_access_policy)
            object_type = "access.Policy"
            org         = var.organization
            policy      = "imc_access"
          },
          merge(v.imc_access_policy, {
            object_type = "access.Policy"
            policy      = "imc_access"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        ipmi_over_lan_policy = lookup(v, "ipmi_over_lan_policy", "") != "" ? try(
          {
            name        = tostring(v.ipmi_over_lan_policy)
            object_type = "ipmioverlan.Policy"
            org         = var.organization
            policy      = "ipmi_over_lan"
          },
          merge(v.ipmi_over_lan_policy, {
            object_type = "ipmioverlan.Policy"
            policy      = "ipmi_over_lan"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        lan_connectivity_policy = lookup(v, "lan_connectivity_policy", "") != "" ? try(
          {
            name        = tostring(v.lan_connectivity_policy)
            object_type = "vnic.LanConnectivityPolicy"
            org         = var.organization
            policy      = "lan_connectivity"
          },
          merge(v.lan_connectivity_policy, {
            object_type = "vnic.LanConnectivityPolicy"
            policy      = "lan_connectivity"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        ldap_policy = lookup(v, "ldap_policy", "") != "" ? try(
          {
            name        = tostring(v.ldap_policy)
            object_type = "iam.LdapPolicy"
            org         = var.organization
            policy      = "ldap"
          },
          merge(v.ldap_policy, {
            object_type = "iam.LdapPolicy"
            policy      = "ldap"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        local_user_policy = lookup(v, "local_user_policy", "") != "" ? try(
          {
            name        = tostring(v.local_user_policy)
            object_type = "iam.EndPointUserPolicy"
            org         = var.organization
            policy      = "local_user"
          },
          merge(v.local_user_policy, {
            object_type = "iam.EndPointUserPolicy"
            policy      = "local_user"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        name = "${local.name_prefix}${i.name}${local.lserver.name_suffix}"
        network_connectivity_policy = lookup(v, "network_connectivity_policy", "") != "" ? try(
          {
            name        = tostring(v.network_connectivity_policy)
            object_type = "networkconfig.Policy"
            org         = var.organization
            policy      = "network_connectivity"
          },
          merge(v.network_connectivity_policy, {
            object_type = "networkconfig.Policy"
            policy      = "network_connectivity"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        ntp_policy = lookup(v, "ntp_policy", "") != "" ? try(
          {
            name        = tostring(v.ntp_policy)
            object_type = "ntp.Policy"
            org         = var.organization
            policy      = "ntp"
          },
          merge(v.ntp_policy, {
            object_type = "ntp.Policy"
            policy      = "ntp"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        organization = var.organization
        persistent_memory_policy = lookup(v, "persistent_memory_policy", "") != "" ? try(
          {
            name        = tostring(v.persistent_memory_policy)
            object_type = "memory.PersistentMemoryPolicy"
            org         = var.organization
            policy      = "persistent_memory"
          },
          merge(v.persistent_memory_policy, {
            object_type = "memory.PersistentMemoryPolicy"
            policy      = "persistent_memory"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        power_policy = lookup(v, "power_policy", "") != "" ? try(
          {
            name        = tostring(v.power_policy)
            object_type = "power.Policy"
            org         = var.organization
            policy      = "power"
          },
          merge(v.power_policy, {
            object_type = "power.Policy"
            policy      = "power"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        reservations = [
          for i in lookup(v, "reservations", []) : {
            identity         = i.identity
            ip_type          = lookup(i, "ip_type", "IPv4")
            management_type  = lookup(i, "management_type", "OutofBand")
            pool_name        = i.pool_name
            reservation_type = i.reservation_type
            vnic_name        = lookup(i, "vnic_name", null)
            vhba_name        = lookup(i, "vhba_name", null)
          }
        ]
        resource_pool = lookup(v, "resource_pool", "") != "" ? try(
          {
            name = tostring(v.resource_pool)
            org  = var.organization
          },
          v.resource_pool
          ) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        san_connectivity_policy = lookup(v, "san_connectivity_policy", "") != "" ? try(
          {
            name        = tostring(v.san_connectivity_policy)
            object_type = "vnic.SanConnectivityPolicy"
            org         = var.organization
            policy      = "san_connectivity"
          },
          merge(v.san_connectivity_policy, {
            object_type = "vnic.SanConnectivityPolicy"
            policy      = "san_connectivity"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        sd_card_policy = lookup(v, "sd_card_policy", "") != "" ? try(
          {
            name        = tostring(v.sd_card_policy)
            object_type = "sdcard.Policy"
            org         = var.organization
            policy      = "sd_card"
          },
          merge(v.sd_card_policy, {
            object_type = "sdcard.Policy"
            policy      = "sd_card"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        serial_number = lookup(i, "serial_number", "unknown")
        serial_over_lan_policy = lookup(v, "serial_over_lan_policy", "") != "" ? try(
          {
            name        = tostring(v.serial_over_lan_policy)
            object_type = "sol.Policy"
            org         = var.organization
            policy      = "serial_over_lan"
          },
          merge(v.serial_over_lan_policy, {
            object_type = "sol.Policy"
            policy      = "serial_over_lan"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        smtp_policy = lookup(v, "smtp_policy", "") != "" ? try(
          {
            name        = tostring(v.smtp_policy)
            object_type = "smtp.Policy"
            org         = var.organization
            policy      = "smtp"
          },
          merge(v.smtp_policy, {
            object_type = "smtp.Policy"
            policy      = "smtp"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        snmp_policy = lookup(v, "snmp_policy", "") != "" ? try(
          {
            name        = tostring(v.snmp_policy)
            object_type = "snmp.Policy"
            org         = var.organization
            policy      = "snmp"
          },
          merge(v.snmp_policy, {
            object_type = "snmp.Policy"
            policy      = "snmp"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        ssh_policy = lookup(v, "ssh_policy", "") != "" ? try(
          {
            name        = tostring(v.ssh_policy)
            object_type = "ssh.Policy"
            org         = var.organization
            policy      = "ssh"
          },
          merge(v.ssh_policy, {
            object_type = "ssh.Policy"
            policy      = "ssh"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        static_uuid_address = lookup(i, "static_uuid_address", "")
        storage_policy = lookup(v, "storage_policy", "") != "" ? try(
          {
            name        = tostring(v.storage_policy)
            object_type = "storage.StoragePolicy"
            org         = var.organization
            policy      = "storage"
          },
          merge(v.storage_policy, {
            object_type = "storage.StoragePolicy"
            policy      = "storage"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        syslog_policy = lookup(v, "syslog_policy", "") != "" ? try(
          {
            name        = tostring(v.syslog_policy)
            object_type = "syslog.Policy"
            org         = var.organization
            policy      = "syslog"
          },
          merge(v.syslog_policy, {
            object_type = "syslog.Policy"
            policy      = "syslog"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        tags = lookup(v, "tags", var.tags)
        target_platform = lookup(
          v, "target_platform", local.lchassis.target_platform
        )
        ucs_server_profile_template = lookup(v, "ucs_server_profile_template", "")
        uuid_pool = lookup(v, "uuid_pool", "") != "" ? try(
          {
            name = tostring(v.uuid_pool)
            org  = var.organization
          },
          v.uuid_pool
          ) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        virtual_kvm_policy = lookup(v, "virtual_kvm_policy", "") != "" ? try(
          {
            name        = tostring(v.virtual_kvm_policy)
            object_type = "kvm.Policy"
            org         = var.organization
            policy      = "virtual_kvm"
          },
          merge(v.virtual_kvm_policy, {
            object_type = "kvm.Policy"
            policy      = "virtual_kvm"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
        virtual_media_policy = lookup(v, "virtual_media_policy", "") != "" ? try(
          {
            name        = tostring(v.virtual_media_policy)
            object_type = "vmedia.Policy"
            org         = var.organization
            policy      = "virtual_media"
          },
          merge(v.virtual_media_policy, {
            object_type = "vmedia.Policy"
            policy      = "virtual_media"
          })) : {
          name = "UNUSED"
          org  = "UNUSED"
        }
      }
    ]
  ])
  servers = [
    for v in local.server_loop : {
      action = v.action
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
        ) : i if i.name != "UNUSED" && i.name != ""
      ]
      adapter_configuration_policy = length(regexall("UNUSED", v.adapter_configuration_policy.name)
      ) == 0 ? v.adapter_configuration_policy.name : ""
      bios_policy       = length(regexall("UNUSED", v.bios_policy.name)) == 0 ? v.bios_policy.name : ""
      boot_order_policy = length(regexall("UNUSED", v.boot_order_policy.name)) == 0 ? v.boot_order_policy.name : ""
      certificate_management_policy = length(regexall("UNUSED", v.certificate_management_policy.name)
      ) == 0 ? v.certificate_management_policy.name : ""
      create_from_template = v.create_from_template
      description          = v.description
      device_connector_policy = length(regexall("UNUSED", v.device_connector_policy.name)
      ) == 0 ? v.device_connector_policy.name : ""
      imc_access_policy = length(regexall("UNUSED", v.imc_access_policy.name)) == 0 ? v.imc_access_policy.name : ""
      ipmi_over_lan_policy = length(regexall("UNUSED", v.ipmi_over_lan_policy.name)
      ) == 0 ? v.ipmi_over_lan_policy.name : ""
      lan_connectivity_policy = length(regexall("UNUSED", v.lan_connectivity_policy.name)
      ) == 0 ? v.lan_connectivity_policy.name : ""
      ldap_policy       = length(regexall("UNUSED", v.ldap_policy.name)) == 0 ? v.ldap_policy.name : ""
      local_user_policy = length(regexall("UNUSED", v.local_user_policy.name)) == 0 ? v.local_user_policy.name : ""
      name              = v.name
      network_connectivity_policy = length(regexall("UNUSED", v.network_connectivity_policy.name)
      ) == 0 ? v.network_connectivity_policy.name : ""
      ntp_policy   = length(regexall("UNUSED", v.ntp_policy.name)) == 0 ? v.ntp_policy.name : ""
      organization = v.organization
      persistent_memory_policy = length(regexall("UNUSED", v.persistent_memory_policy.name)
      ) == 0 ? v.persistent_memory_policy.name : ""
      power_policy  = length(regexall("UNUSED", v.power_policy.name)) == 0 ? v.power_policy.name : ""
      reservations  = v.reservations
      resource_pool = v.resource_pool
      san_connectivity_policy = length(regexall("UNUSED", v.san_connectivity_policy.name)
      ) == 0 ? v.san_connectivity_policy.name : ""
      sd_card_policy = length(regexall("UNUSED", v.sd_card_policy.name)) == 0 ? v.sd_card_policy.name : ""
      serial_number  = v.serial_number
      serial_over_lan_policy = length(regexall("UNUSED", v.serial_over_lan_policy.name)
      ) == 0 ? v.serial_over_lan_policy.name : ""
      smtp_policy         = length(regexall("UNUSED", v.smtp_policy.name)) == 0 ? v.smtp_policy.name : ""
      snmp_policy         = length(regexall("UNUSED", v.snmp_policy.name)) == 0 ? v.snmp_policy.name : ""
      ssh_policy          = length(regexall("UNUSED", v.ssh_policy.name)) == 0 ? v.ssh_policy.name : ""
      static_uuid_address = v.static_uuid_address
      storage_policy      = length(regexall("UNUSED", v.storage_policy.name)) == 0 ? v.storage_policy.name : ""
      syslog_policy = length(regexall("UNUSED", v.syslog_policy.name)
      ) == 0 ? v.syslog_policy.name : ""
      tags                        = v.tags
      target_platform             = v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool                   = v.uuid_pool
      virtual_kvm_policy = length(regexall("UNUSED", v.virtual_kvm_policy.name)
      ) == 0 ? v.virtual_kvm_policy.name : ""
      virtual_media_policy = length(regexall("UNUSED", v.virtual_media_policy.name)
      ) == 0 ? v.virtual_media_policy.name : ""
    }
  ]
  server = {
    for v in local.servers : v.name => {
      action                        = v.action
      adapter_configuration_policy  = v.adapter_configuration_policy
      bios_policy                   = v.bios_policy
      boot_order_policy             = v.boot_order_policy
      certificate_management_policy = v.boot_order_policy
      create_from_template          = v.create_from_template
      description                   = v.description
      device_connector_policy       = v.device_connector_policy
      imc_access_policy             = v.imc_access_policy
      ipmi_over_lan_policy          = v.ipmi_over_lan_policy
      lan_connectivity_policy       = v.lan_connectivity_policy
      ldap_policy                   = v.ldap_policy
      local_user_policy             = v.local_user_policy
      name                          = v.name
      network_connectivity_policy   = v.network_connectivity_policy
      ntp_policy                    = v.ntp_policy
      organization                  = v.organization
      persistent_memory_policy      = v.persistent_memory_policy
      policy_bucket = length(compact([v.ucs_server_profile_template])
      ) > 0 ? concat(v.policy_bucket, local.template[v.ucs_server_profile_template].policy_bucket) : v.policy_bucket
      power_policy            = v.power_policy
      reservations            = v.reservations
      resource_pool           = v.resource_pool
      san_connectivity_policy = v.san_connectivity_policy
      sd_card_policy          = v.sd_card_policy
      serial_number           = v.serial_number
      serial_over_lan_policy  = v.serial_over_lan_policy
      smtp_policy             = v.smtp_policy
      snmp_policy             = v.snmp_policy
      ssh_policy              = v.ssh_policy
      static_uuid_address     = v.static_uuid_address
      storage_policy          = v.storage_policy
      syslog_policy           = v.syslog_policy
      tags                    = v.tags
      target_platform = v.create_from_template == true && length(compact([v.ucs_server_profile_template])
      ) > 0 ? local.template[v.ucs_server_profile_template].target_platform : v.target_platform
      ucs_server_profile_template = v.ucs_server_profile_template
      uuid_pool = length(compact([v.ucs_server_profile_template])
      ) > 0 ? local.template[v.ucs_server_profile_template].uuid_pool : v.uuid_pool
      virtual_kvm_policy   = v.virtual_kvm_policy
      virtual_media_policy = v.virtual_media_policy
    }
  }
  server_serial_numbers = compact([for v in local.server : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", v.serial_number)) > 0])
}