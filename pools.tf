resource "intersight_resourcepool_pool" "data" {
  for_each = { for v in local.pb.resource : v => v if contains(lookup(lookup(local.pools, "locals", {}), "resource", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization { moid = var.orgs[element(split("/", each.value), 0)] }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, create_time, description, domain_group_moid,
      mod_time, owners, parent, permission_resources, pool_type, resource_pool_parameters, resource_type, selectors,
      shared_scope, size, tags, version_context
    ]
    prevent_destroy = true
  }
}

resource "intersight_uuidpool_pool" "data" {
  for_each = { for v in local.pb.uuid : v => v if contains(lookup(lookup(local.pools, "locals", {}), "uuid", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, block_heads, create_time, description, domain_group_moid,
      mod_time, owners, parent, permission_resources, prefix, reservations, reserved, shared_scope, size, tags, uuid_suffix_blocks, version_context
    ]
    prevent_destroy = true
  }
}
